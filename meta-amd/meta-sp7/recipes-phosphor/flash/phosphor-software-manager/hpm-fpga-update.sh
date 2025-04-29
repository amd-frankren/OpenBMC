#!/bin/bash

set +e

IMAGE_DIR=$1

GPIO_BASE=$(cat /sys/devices/platform/soc@14000000/14c34c00.ltpi0-gpio/gpio/*/base)
logger -t hpm-fpga-update "GPIO base value is $GPIO_BASE"  

#gpiochip1012 + AB[3] (25)
GPIOAB3=$((GPIO_BASE + 25)) 

#gpiochip1012 + AB[4] (27)
GPIOAB4=$((GPIO_BASE + 27)) 

#gpiochip1012 + AB[5] (29)
GPIOAB5=$((GPIO_BASE + 29)) 

SPI_DEV="14030000.spi"
SPI_PATH="/sys/bus/platform/drivers/spi-aspeed-smc"

set_gpio_to_bmc()
{
    GPIOs=($GPIOAB3 $GPIOAB4 $GPIOAB5)
    values=(0 1 0)

    logger -t hpm-fpga-update "switch HPM FPGA GPIO $GPIO to bmc"

    for i in "${!GPIOs[@]}"; do
        GPIO=${GPIOs[$i]}
        value=${values[$i]}

        if [ ! -d "/sys/class/gpio/gpio$GPIO" ]; then
            echo "$GPIO" > /sys/class/gpio/export
            cd "/sys/class/gpio/gpio$GPIO" || exit 1
        else
            cd "/sys/class/gpio/gpio$GPIO" || exit 1
        fi

        echo "$value" > value
    done

    return 0
}

bind_spi_dev() {

    GPIO0=$2
    GPIO1=$3
    GPIO2=$4

    if [ ! -d "$SPI_PATH/$1/spi_master/spi3/spi3.0/mtd" ] ; then
        logger -t hpm-fpga-update "unbinding $1 to aspeed-smc spi driver"
        echo -n "$1" > $SPI_PATH/unbind

        logger -t hpm-fpga-update "binding $1 to aspeed-smc spi driver"
        if echo -n "$1" > $SPI_PATH/bind; then
            logger -t hpm-fpga-update "SPI Driver Bind Successful"
        else
            logger -t hpm-fpga-update "SPI Driver Bind Failed."
            set_gpio_to_host "$GPIO0"
            set_gpio_to_host "$GPIO1"
            set_gpio_to_host "$GPIO2"
            exit 1
        fi
    else
        logger -t hpm-fpga-update "Partition already mounted"
    fi
}

get_mtd_info() {
    if spi_part=$(basename "$(find "$SPI_PATH/$1/spi_master/spi3/spi3.0/mtd/" -type d -maxdepth 1 | grep "mtd[6-9]$")") ; then
        logger -t hpm-fpga-update "Partition found: $spi_part"
        mtd_num=$spi_part

        if [ -z "$mtd_num" ]; then
            update_fail=1
        fi
    else
        logger -t hpm-fpga-update "MTD part not found for $1"
        update_fail=1
    fi

    if [[ $update_fail -eq 1 ]]; then
        unbind_spi_dev $SPI_DEV
        set_gpio_to_host "$GPIO0"
        set_gpio_to_host "$GPIO1"
        set_gpio_to_host "$GPIO2"
        exit 1
    fi
}

flash_image_to_mtd()
{
    logger -t hpm-fpga-update "$IMAGE_DIR"

    pushd "$IMAGE_DIR" || exit 1

    IMAGE_FILE=$(find . -type f -name '*.bin')

    if [ -e "$IMAGE_FILE" ];
    then
        logger -t hpm-fpga-update "HPM image is $IMAGE_FILE"
        for d in $mtd_num ; do
            if [ -e "/dev/$d" ]; then
                mtd=$(cat "/sys/class/mtd/$d/name")
                if [ "$mtd" == "pnor" ]; then
                    logger -t hpm-fpga-update "Flashing hpm fpga image to $d..."
                    if flashcp -v "$IMAGE_FILE" /dev/"$d"; then
                        logger -t hpm-fpga-update "hpm fpga updated successfully..."
                    else
                        logger -t hpm-fpga-update "hpm fpga update failed..."
                        unbind_spi_dev $SPI_DEV
                        set_gpio_to_host
                        exit 1
                    fi
                    break
                fi
                logger -t hpm-fpga-update "$d is not a pnor device"
            fi
            logger -t hpm-fpga-update "$d not available"
        done
    else
        logger -t hpm-fpga-update "HPM FPGA image $IMAGE_FILE doesn't exist"
    fi
    popd || return
}

set_gpio_to_host()
{
    GPIOs=($GPIOAB3 $GPIOAB4 $GPIOAB5)

    logger -t hpm-fpga-update "switch HPM FPGA GPIO $GPIO0 to host"

    for i in "${!GPIOs[@]}"; do
        GPIO=${GPIOs[$i]}

        if [ ! -d "/sys/class/gpio/gpio$GPIO" ]; then
            echo "$GPIO" > /sys/class/gpio/export
            cd "/sys/class/gpio/gpio$GPIO" || exit 1
        else
            cd "/sys/class/gpio/gpio$GPIO" || exit 1
        fi

        echo 1 > value
        echo "$GPIO" > /sys/class/gpio/unexport
    done

    return 0
}

unbind_spi_dev() {
    logger -t hpm-fpga-update "Unbind aspeed-smc spi driver for $1"
    echo -n "$1" > $SPI_PATH/unbind
}

echo "HPM FPGA upgrade started at $(date)"

logger -t hpm-fpga-update "Set GPIO $GPIO0, $GPIO1, $GPIO2 to access BIOS flash from BMC used by host"

#Flip GPIO to access SPI flash used by HPM FPGA.
# Set MGMT_UPDATE_FLASH[0] = 0, MGMT_UPDATE_FLASH[1]  = 1, MGMT_UPDATE_FLASH[1] = 0

set_gpio_to_bmc

#Bind spi driver to access flash
bind_spi_dev $SPI_DEV "$GPIOAB3" "$GPIOAB4" "$GPIOAB5"
sleep 1

#Flashcp image to device.
get_mtd_info $SPI_DEV
sleep 1
flash_image_to_mtd

#Unbind spi driver
sleep 1
unbind_spi_dev $SPI_DEV
sleep 1

#Flip GPIO back for host to access SPI flash
logger -t hpm-fpga-update "Set GPIO $GPIOAB3, $GPIOAB4, $GPIOAB5 back for host to access SPI flash"
set_gpio_to_host
sleep 5

#reboot HOST
echo "WARNING!! AC POWER CYCLE required to activate HPM FPGA"

exit 0
