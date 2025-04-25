#!/bin/bash

readonly GPIO_BASE=$(cat /sys/devices/platform/soc@14000000/14c34c00.ltpi0-gpio/gpio/*/base)

readonly P0_MGMT_ASSERT_CLR_CMOS=$((GPIO_BASE + 3))
readonly P0_MGMT_ASSERT_PROCHOT_L=$((GPIO_BASE + 5))
readonly P0_ASSERT_RSMRST=$((GPIO_BASE + 7))
readonly P0_MGMT_ASSERT_THERMTRIP_L=$((GPIO_BASE + 9))
readonly P0_MGMT_ASSERT_WARM_RST_BTN_L=$((GPIO_BASE + 41))
readonly P0_MGMT_UPDATE_FLASH_0=$((GPIO_BASE + 25))
readonly P0_MGMT_UPDATE_FLASH_1=$((GPIO_BASE + 27))
readonly P0_MGMT_UPDATE_FLASH_2=$((GPIO_BASE + 29))

# MultiHost support.
readonly P1_MGMT_ASSERT_CLR_CMOS=$((GPIO_BASE + 101))
readonly P1_MGMT_ASSERT_PROCHOT_L=$((GPIO_BASE + 53))
readonly P1_ASSERT_RSMRST=$((GPIO_BASE + 55))
readonly P1_MGMT_ASSERT_THERMTRIP_L=$((GPIO_BASE + 51))
readonly P1_MGMT_ASSERT_WARM_RST_BTN_L=$((GPIO_BASE + 97))

# HPM Board ID
hpm_board_id=0

set_gpio_power_pins() {
    GPIO=$1
    value=$2
    if [ ! -d "/sys/class/gpio/gpio$GPIO" ]; then
        echo "$GPIO" >/sys/class/gpio/export
        cd "/sys/class/gpio/gpio$GPIO" || exit 1
    else
        cd "/sys/class/gpio/gpio$GPIO" || exit 1
    fi
    echo "$value" >value
    echo "$GPIO" >/sys/class/gpio/unexport
    return 0
}

# Function to set GPIO power pins for P0
set_p0_gpio_pins() {
    set_gpio_power_pins $P0_MGMT_ASSERT_PROCHOT_L 0
    set_gpio_power_pins $P0_MGMT_ASSERT_CLR_CMOS 0
    set_gpio_power_pins $P0_ASSERT_RSMRST 0
    set_gpio_power_pins $P0_MGMT_ASSERT_THERMTRIP_L 0
    set_gpio_power_pins $P0_MGMT_ASSERT_WARM_RST_BTN_L 1
    set_gpio_power_pins $P0_MGMT_UPDATE_FLASH_0 0
    set_gpio_power_pins $P0_MGMT_UPDATE_FLASH_1 0
    set_gpio_power_pins $P0_MGMT_UPDATE_FLASH_2 0
}

# Function to set GPIO power pins for P1
set_p1_gpio_pins() {
    set_gpio_power_pins $P1_MGMT_ASSERT_PROCHOT_L 0
    set_gpio_power_pins $P1_MGMT_ASSERT_CLR_CMOS 0
    set_gpio_power_pins $P1_ASSERT_RSMRST 0
    set_gpio_power_pins $P1_MGMT_ASSERT_THERMTRIP_L 0
    set_gpio_power_pins $P1_MGMT_ASSERT_WARM_RST_BTN_L 1
}

# Helper function to check if multihost is supported
multihost_supported() {
    hpm_board_id=$(/sbin/fw_printenv -n board_id)
    # Check for 2P Platforms Morocco(0x82, 0x83, 0x87), Nigeria(0x85), Ghana(0x8E)
    if [[ ! "$HPM_BOARD_ID" =~ ^(82|83|85|87|8E)$ ]]; then
        return 0
    else
        return 1
    fi
}

# Main function to execute the GPIO pin settings
main() {
    echo "power-ctl-gpio: AMD power control GPIO started"
    set_p0_gpio_pins

    # Check if multihost is supported
    if multihost_supported; then
        set_p1_gpio_pins
    fi
}

# Execute the main function
main
