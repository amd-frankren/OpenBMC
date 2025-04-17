#!/bin/bash

set -e

# Speed Limit 30% (Range 0x0 to 0xFF)
SPEED_LIMIT=0x4C

init_nct7363_fan_controller()
{
    # Define platform specific nct7363 controller registers
    if [[ "$board_id" == "84" ]]; then
        echo "Initializing fans for Kenya"
        FAN_SET_REG=(
            # PWM initilization Regs, for 3-channel PWM
            "0x2A 0x00"        # Disable WDT for no-fan testing
            "0x38 0x01"        # Enable PWM0
            "0x39 0x81"        # Enable PWM8 and PWM15
            "0x41 0x7E"        # Enable FANIN1-6
            "0x42 0xF6"        # Enable FANIN9-10 & FANIN12-15
            "0x20 0x29"        # Set FANIN10 FANIN9 PWM0
            "0x21 0xAA"        # Set FANIN15 FANIN4 FANIN13 FANIN12
            "0x22 0xA9"        # Set FANIN3 FANIN2 FANIN1 PWM8
            "0x23 0x6A"        # Set PWM15 FANIN6 FANIN5 FANIN4

            # Fan speed control Regs, for 1-6 fans
            "0x90 $speed_val"  # Set PWM0 FSCPxDUTY
            "0xA0 $speed_val"  # Set PWM8 FSCPxDUTY
            "0xAE $speed_val"  # Set PWM15 FSCPxDUTY
        )
    elif [[ "$board_id" == "85" ]]; then
        echo "Initializing fans for Nigeria"
        FAN_SET_REG=(
            # PWM initilization Regs, for 1-channel PWM
            "0x2A 0x00"        # Disable WDT for no-fan testing
            "0x38 0x01"        # Enable PWM0
            "0x42 0x1E"        # Enable FANIN9-12
            "0x20 0xA9"        # Set FANIN11 FANIN10 FANIN9 PWM0
            "0x21 0x02"        # Set FANIN12
            "0x22 0x00"        # Set GPIO10-13
            "0x23 0x00"        # Set GPIO14-17

            # Fan speed control Regs, for 1-2 fans
            "0x90 $speed_val"  # Set PWM0 FSCPxDUTY
        )
    elif [[ "$board_id" == "8E" ]]; then
        echo "Initializing fans for Ghana"
        FAN_SET_REG=(
            # PWM initilization Regs, for 1-channel PWM
            "0x2A 0x00"        # Disable WDT for no-fan testing
            "0x38 0x01"        # Enable PWM0
            "0x42 0x1E"        # Enable FANIN9-12
            "0x20 0xA9"        # Set FANIN11 FANIN10 FANIN9 PWM0
            "0x21 0x02"        # Set FANIN12
            "0x22 0x00"        # Set GPIO10-13
            "0x23 0x00"        # Set GPIO14-17

            # Fan speed control Regs, for 1-2 fans
            "0x90 $speed_val"  # Set PWM0 FSCPxDUTY
        )
    else
        echo "Error: Unsupported board ID $board_id for nct7363 fan controller"
        return 1
    fi

    return 0
}

set_nct7363_fan_speed()
{
    # Fan Controller Dev ID
    NCT7363_DEV=0x20

    # prepare nct7363 controller registers
    init_nct7363_fan_controller || retval=$?
    if [[ "$retval" -ne 0 ]]; then
        echo "Error: init_nct7363_fan_controller failed."
        return 1
    fi

    # prepare a list of nct7363 controllers on the board
    mapfile -t i2c_bus_array < <(find /sys/bus/i2c/drivers \
            | grep nct736 | grep 0020 | cut -d"/" -f 7 | cut -d"-" -f 1 | sort)

    # Get the number of nct7363 controllers
    num_of_nct7363_controller=${#i2c_bus_array[@]}
    echo "Number of NCT7363 controllers: ${num_of_nct7363_controller}"
    echo "Setting all Fan speeds to $speed_val pwm"

    # Set nct7363 fan controller registers
    for ((i=0; i<num_of_nct7363_controller; i++)); do
        local bus=${i2c_bus_array[i]}

        for reg_val in "${FAN_SET_REG[@]}"; do
            local register="${reg_val%% *}"
            local value="${reg_val##* }"
            i2cset -f -y "$bus" "$NCT7363_DEV" "$register" "$value" || retval=$?

            if [[ "$retval" -ne 0 ]]; then
                echo "Error: set_nct7363_fan_controller failed" \
                        "bus:$bus dev:$NCT7363_DEV reg:$register val:$value"
                break
            fi
        done
    done
}

# Set all Fans speeds at argument passed by user
set_emc2305_fan_speed()
{
    # Fan Controller Dev ID
    EMC2305_DEV=0x4D

    #Fan speed control Regs, for 1-5 fans
    FAN_SET_REG=("0x30" "0x40" "0x50" "0x60" "0x70")
    num_of_fans=${#FAN_SET_REG[@]}

    # prepare a list of emc2305 controllers on the board
    mapfile -t i2c_bus_array < <(find /sys/bus/i2c/drivers | grep emc2305 | grep 004d | cut -d"/" -f 7 | cut -d"-" -f 1 | sort)

    # Get the number of emc2305 controllers
    num_of_emc2305_controller=${#i2c_bus_array[@]}

    echo "Number of emc2305 controller = ${num_of_emc2305_controller}"
    # Write speed value to emc2305 controller Regs.
    echo "Setting all Fan speeds to $speed_val pwm"
    for ((i=0; i<num_of_emc2305_controller; i++));
    do
        for (( j=0; j <num_of_fans; j++));
        do
            i2cset -f -y "${i2c_bus_array[i]}" $EMC2305_DEV "${FAN_SET_REG[j]}" "$speed_val" || retval=$?
            if [[ "$retval" -ne 0 ]]; then
                echo "Error: Setting fan speed failed or there is no fan connected..."
                break
            fi
        done
    done
}

# Main()
#---------
# Verify that input speed is not below Limit value.
if [[ $1 -lt $SPEED_LIMIT ]]; then
    echo "Error : You cannot set Fan speed less than 30% (0x4C)"
    exit 1
else
    speed_val=$1
fi

board_id=$(/sbin/fw_printenv -n board_id)
case "$board_id" in
    # Marley(79, 0x7A, 0x7B)
    # Congo(0x80, 0x81, 0x86)
    # Morocco(0x82, 0x83, 0x87)
    # Senegal (0x88)
    # Malawi (0x8A)
    "79" | "7A" | "7B" | "80" | "81" | "86" | "82" | "83" | "87" | "88" | "8A")
        # Call functions to set EMC2305 Fan speeds
        set_emc2305_fan_speed
        ;;
    # Kenya(0x84)
    # Nigeria(0x85)
    # Ghana (0x8E)
    "84" | "85" | "8E")
        # Call functions to set NCT7363 Fan speeds
        # TDB: remove the loop. once after CPLD fix
        while :
        do
            set_nct7363_fan_speed
            sleep 3
        done
        ;;
    *)
        echo " Unknown board_id $board_id"
        echo " Please program board FRU EEPROM"
        ;;
esac

exit 0
