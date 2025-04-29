#!/bin/bash

GPIO_BASE=$(cat /sys/devices/platform/soc@14000000/14c34c00.ltpi0-gpio/gpio/*/base)

P0_MGMT_ASSERT_CLR_CMOS=$((GPIO_BASE + 3)) 
P0_MGMT_ASSERT_PROCHOT_L=$((GPIO_BASE + 5)) 
P0_ASSERT_RSMRST=$((GPIO_BASE + 7)) 
P0_MGMT_ASSERT_THERMTRIP_L=$((GPIO_BASE + 9)) 
P0_MGMT_ASSERT_WARM_RST_BTN_L=$((GPIO_BASE + 41)) 
P0_MGMT_UPDATE_FLASH_0=$((GPIO_BASE + 25)) 
P0_MGMT_UPDATE_FLASH_1=$((GPIO_BASE + 27)) 
P0_MGMT_UPDATE_FLASH_2=$((GPIO_BASE + 29)) 

set_gpio_pwer_pins() {
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
set_gpio_pwer_pins "$P0_MGMT_ASSERT_PROCHOT_L" "0"
set_gpio_pwer_pins "$P0_MGMT_ASSERT_CLR_CMOS" "0"
set_gpio_pwer_pins "$P0_ASSERT_RSMRST" "0"
set_gpio_pwer_pins "$P0_MGMT_ASSERT_THERMTRIP_L" "0"
set_gpio_pwer_pins "$P0_MGMT_ASSERT_WARM_RST_BTN_L" "1"
set_gpio_pwer_pins "$P0_MGMT_UPDATE_FLASH_0" "0"
set_gpio_pwer_pins "$P0_MGMT_UPDATE_FLASH_1" "0"
set_gpio_pwer_pins "$P0_MGMT_UPDATE_FLASH_2" "0"
