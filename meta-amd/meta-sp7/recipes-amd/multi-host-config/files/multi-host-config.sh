#!/bin/bash

# Multi Host Service, object, and interface to monitor
declare -r SERVICE="xyz.openbmc_project.Settings"
declare -r OBJECT="/xyz/openbmc_project/control/HostMode"
declare -r INTERFACE="xyz.openbmc_project.Control.HostMode"
declare -r CURRENT_MODE="CurrentMode"
declare -r USER_MODE="Mode"

# Platform config GPIOs
declare -r MGMT_MON_PLATFORM_CONFIG=1114
declare -r MGMT_ASSERT_PLATFORM_CONFIG=1115

# Directory for runtime data
readonly RUN_CONFIG_DIR="/var/run/amd"

# HPM board ID
HPM_BOARD_ID=0

# Function to set the MGMT_PLATFORM_CONFIG GPIO pins
set_platform_gpio_pin() {
    GPIO=$1
    value=$2

    if [ ! -d "/sys/class/gpio/gpio$GPIO" ]; then
        echo "$GPIO" > /sys/class/gpio/export
        cd "/sys/class/gpio/gpio$GPIO" || exit 1
    else
        cd "/sys/class/gpio/gpio$GPIO" || exit 1
    fi
    echo "$value" > value
    echo "$GPIO" > /sys/class/gpio/unexport

    return 0
}

# Function to get the MGMT_PLATFORM_CONFIG GPIO pins
get_platform_gpio_pin() {
    GPIO=$1

    if [ ! -d "/sys/class/gpio/gpio$GPIO" ]; then
        echo "$GPIO" > /sys/class/gpio/export
    fi

    GPIO_PATH="/sys/class/gpio/gpio$GPIO"

    if [ ! -d "$GPIO_PATH" ]; then
        echo "Error: GPIO $GPIO not found" >&2
        return 1
    fi

    gpio_val=$(cat "$GPIO_PATH/value")
    echo "$GPIO" > /sys/class/gpio/unexport
    echo "$gpio_val"

    return 0
}

# Function to perform custom multi-host power off action
power_off() {
    local mode=$1

    # Power off host based on processor mode
    if [ "$mode" -eq 0 ]; then
        busctl set-property xyz.openbmc_project.State.Chassis /xyz/openbmc_project/state/chassis0 xyz.openbmc_project.State.Chassis RequestedPowerTransition s xyz.openbmc_project.State.Chassis.Transition.Off

    elif [ "$mode" -eq 1 ]; then
        busctl set-property xyz.openbmc_project.State.Chassis /xyz/openbmc_project/state/chassis1 xyz.openbmc_project.State.Chassis RequestedPowerTransition s xyz.openbmc_project.State.Chassis.Transition.Off

        busctl set-property xyz.openbmc_project.State.Chassis /xyz/openbmc_project/state/chassis2 xyz.openbmc_project.State.Chassis RequestedPowerTransition s xyz.openbmc_project.State.Chassis.Transition.Off
    fi
}

# Function to configure the BRD_ID FRU for P0 and P1 based on the current mode
# configured by the user.
configure_board_id_fru() {
    local p0_bus=12
    local p1_bus=13
    local brd_id_slave=0x53
    local brd_id_mux=0x70
    local brd_id_channel=0x01
    local mode=$1

    echo "DEBUG: Programming BRD_ID FRU for mode $mode"
    #Set the Board ID FRU base on the mode and platform
    if [[ $mode == 1 ]]; then
        if [[ "$HPM_BOARD_ID" == "87" ]]; then #Morocco Validation
            P0_board_id=8F
            P1_board_id=90
        elif [[ "$HPM_BOARD_ID" == "82" ]]; then #Morocco major performance
            P0_board_id=9A
            P1_board_id=9B
        elif [[ "$HPM_BOARD_ID" == "83" ]]; then #Morocco minor performance
            P0_board_id=9C
            P1_board_id=9D
        elif [[ "$HPM_BOARD_ID" == "85" ]]; then #Nigeria
            P0_board_id=91
            P1_board_id=92
        elif [[ "$HPM_BOARD_ID" == "8E"  ]]; then #Ghana
            P0_board_id=93
            P1_board_id=94
        fi
    elif [[ $mode == 0 ]]; then
        if [[ "$HPM_BOARD_ID" == "87" ]]; then #Morocco Validation
            P0_board_id=87
            P1_board_id=90
        elif [[ "$HPM_BOARD_ID" == "82" ]]; then #Morocco major performance
            P0_board_id=82
            P1_board_id=9B
        elif [[ "$HPM_BOARD_ID" == "83" ]]; then #Morocco minor performance
            P0_board_id=83
            P1_board_id=9D
        elif [[ "$HPM_BOARD_ID" == "85" ]]; then #Nigeria
            P0_board_id=85
            P1_board_id=92
        elif [[ "$HPM_BOARD_ID" == "8E"  ]]; then #Ghana
            P0_board_id=8E
            P1_board_id=94
        fi
    fi

    #Set mux setttings to acces brd_id
    i2cset -y -f $p0_bus $brd_id_mux $brd_id_channel
    i2cset -y -f $p1_bus $brd_id_mux $brd_id_channel

    #Set Board ID field at offset 16 (0x10)
    if [[ $mode == 0 ]]; then
        i2ctransfer -f -y $p0_bus w3@$brd_id_slave 0x00 0x10 0x0$P0_board_id
        i2ctransfer -f -y $p1_bus w3@$brd_id_slave 0x00 0x10 0x0$P1_board_id

    elif [[ $mode == 1 ]]; then
        i2ctransfer -f -y $p0_bus w3@$brd_id_slave 0x00 0x10 0x0$P0_board_id
        i2ctransfer -f -y $p1_bus w3@$brd_id_slave 0x00 0x10 0x0$P1_board_id
    fi
}

# Function to monitor multi-host state changes via D-Bus property
monitor_multi_host_state_change() {
    while read -r line; do
        if echo "$line" | grep -q "string \"Mode\""; then
            read -r line
            value=$(echo "$line" | awk '{print $3}')
            if [[ $value == 1 ]]; then
                echo "MultiHostConfig changed to 2x1P"
            else
                echo "MultiHostConfig changed to 2P"
            fi
            break
        fi
    done < <(dbus-monitor --system "type='signal',\
        interface='org.freedesktop.DBus.Properties',\
        member='PropertiesChanged',\
        path='$OBJECT',\
        arg0namespace='$INTERFACE'")
}

# Function to configure the boot mode
setMode() {
    local mode="$1"
    local bootstrap_mode

    # Ensure /etc/hosts.d/ directory exists
    if [ ! -d /etc/hosts.d ]; then
        mkdir -p /etc/hosts.d
    fi

    # Ensure RUN_CONFIG_DIR directory exists
    if [ ! -d $RUN_CONFIG_DIR ];then
        mkdir -p $RUN_CONFIG_DIR
    fi

    if [[ "$mode" == 0 ]]; then
        # Create host0 file
        touch /etc/hosts.d/host0.conf

        # Remove host1 and host2 config if present
        if [ -f /etc/hosts.d/host1.conf ]; then
            rm /etc/hosts.d/host1.conf
        fi

        if [ -f /etc/hosts.d/host2.conf ]; then
            rm /etc/hosts.d/host2.conf
        fi

        # Check the bootstrap mode
        bootstrap_mode=$(get_platform_gpio_pin "$MGMT_MON_PLATFORM_CONFIG")

        echo "DEBUG: bootstrap_mode $bootstrap_mode "
        if [[ "$bootstrap_mode" != 0 ]]; then
            # Power off host0
            power_off "$bootstrap_mode"

            # Configure BRD_ID_EEPROM
            configure_board_id_fru "$mode"

            # Set the bootstrap mode
            set_platform_gpio_pin "$MGMT_ASSERT_PLATFORM_CONFIG" "$mode"
        fi

        # Signal read status to services
        touch "$RUN_CONFIG_DIR/amd-config-ready"

        # Set the new current mode
        busctl set-property $SERVICE $OBJECT $INTERFACE $CURRENT_MODE q $mode

    elif [[ "$mode" == 1 ]]; then
        # Create host1 and host2 files
        touch /etc/hosts.d/host1.conf
        touch /etc/hosts.d/host2.conf

        # Remove host0 config if present
        if [ -f /etc/hosts.d/host0.conf ]; then
            rm /etc/hosts.d/host0.conf
        fi

        # Check the bootstrap mode
        bootstrap_mode=$(get_platform_gpio_pin "$MGMT_MON_PLATFORM_CONFIG")

        if [[ "$bootstrap_mode" != 1 ]]; then
            # Power off host1 and host2
            power_off "$bootstrap_mode"

            # Configure BRD_ID_EEPROM
            configure_board_id_fru "$mode"

            # Set the bootstrap mode
            set_platform_gpio_pin "$MGMT_ASSERT_PLATFORM_CONFIG" "$mode"
        fi

        # Signal read status to services
        touch "$RUN_CONFIG_DIR/amd-config-ready"

        # Set the new current mode
        busctl set-property $SERVICE $OBJECT $INTERFACE $CURRENT_MODE q $mode
    else
        echo "Invalid mode: $mode"
        exit 1
    fi
}

# Main function
main() {

    HPM_BOARD_ID=$(/sbin/fw_printenv -n board_id)
    echo "DEBUG: $HPM_BOARD_ID"

    # Check for 2P Platforms Morocco(0x82, 0x83, 0x87), Nigeria(0x85), Ghana(0x8E)
    if [[ ! "$HPM_BOARD_ID" =~ ^(82|83|85|87|8E)$ ]]; then
        echo "Invalid board ID: $HPM_BOARD_ID. System is not 2P"
        exit 1
    fi

    # Check for current mode
    current_mode=$(busctl get-property $SERVICE $OBJECT $INTERFACE $CURRENT_MODE | awk '{print $2}')

    # Configure the curent mode
    setMode $current_mode

    # Monitor the D-Bus property change
    monitor_multi_host_state_change

    user_config_mode=$(busctl get-property $SERVICE $OBJECT $INTERFACE $USER_MODE | awk '{print $2}')

    # Check if the mode configured by user is same as the current mode
    if [[ $user_config_mode != $current_mode ]]; then
        setMode $user_config_mode

        # Set current mode same as user mode
        busctl set-property $SERVICE $OBJECT $INTERFACE $CURRENT_MODE q $user_config_mode
    fi

    reboot;
}

# Call the main function
main
