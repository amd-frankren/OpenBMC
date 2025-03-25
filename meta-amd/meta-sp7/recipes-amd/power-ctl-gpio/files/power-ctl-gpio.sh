#!/bin/bash

P0_MGMT_ASSERT_CLR_CMOS=1015
P0_MGMT_ASSERT_PROCHOT_L=1017
P0_ASSERT_RSMRST=1019
P0_MGMT_ASSERT_THERMTRIP_L=1021
P0_MGMT_ASSERT_WARM_RST_BTN_L=1053
P0_MGMT_UPDATE_FLASH_0=1037
P0_MGMT_UPDATE_FLASH_1=1039
P0_MGMT_UPDATE_FLASH_2=1041

LTPI_STATUS_ADDR=0x14c34108

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

value=$(devmem $LTPI_STATUS_ADDR)
bit_field=$((value & 0xF))

if [ "$bit_field" -ne 7 ]; then
    if [ -f /var/lib/ltpi_reboot ]; then
        echo "LTPI is NOT up even after reboot, Please AC CYCLE"
        rm /var/lib/ltpi_reboot
    else
        touch /var/lib/ltpi_reboot
        echo "Rebooting system due to LTPI not being up"
        reboot
    fi
    exit 1
else
    if [ -f /var/lib/ltpi_reboot ]; then
        rm /var/lib/ltpi_reboot
    fi
    echo  "LTPI Link is up"
fi
set_gpio_pwer_pins "$P0_MGMT_ASSERT_PROCHOT_L" "0"
set_gpio_pwer_pins "$P0_MGMT_ASSERT_CLR_CMOS" "0"
set_gpio_pwer_pins "$P0_ASSERT_RSMRST" "0"
set_gpio_pwer_pins "$P0_MGMT_ASSERT_THERMTRIP_L" "0"
set_gpio_pwer_pins "$P0_MGMT_ASSERT_WARM_RST_BTN_L" "1"
set_gpio_pwer_pins "$P0_MGMT_UPDATE_FLASH_0" "0"
set_gpio_pwer_pins "$P0_MGMT_UPDATE_FLASH_1" "0"
set_gpio_pwer_pins "$P0_MGMT_UPDATE_FLASH_2" "0"
