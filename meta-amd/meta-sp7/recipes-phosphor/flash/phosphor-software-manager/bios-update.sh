#!/bin/bash

set +e

IMAGE_DIR=$1

#gpiochip512 + AB[3] (219)
GPIOAB3=731

#gpiochip512 + AB[4] (220)
GPIOAB4=732

#gpiochip512 + AB[5] (221)
GPIOAB5=733

SPI_DEVICE_1="14020000.spi"
SPI_DEV_1="14020000.spi/spi_master/spi2/spi2.0/mtd/"

SPI_PATH="/sys/bus/platform/drivers/spi-aspeed-smc"

power_off() {
    busctl set-property xyz.openbmc_project.State.Chassis /xyz/openbmc_project/state/chassis0 xyz.openbmc_project.State.Chassis RequestedPowerTransition s xyz.openbmc_project.State.Chassis.Transition.Off
}

power_on() {
    busctl set-property xyz.openbmc_project.State.Chassis /xyz/openbmc_project/state/chassis0 xyz.openbmc_project.State.Chassis RequestedPowerTransition s xyz.openbmc_project.State.Chassis.Transition.On
}

power_status() {
    st=$(busctl get-property xyz.openbmc_project.State.Chassis /xyz/openbmc_project/state/chassis0 xyz.openbmc_project.State.Chassis CurrentPowerState | cut -d"." -f6)
    if [ "$st" == "On\"" ]; then
        echo "on"
    else
        echo "off"
    fi
}

get_mtd_info() {
    if spi_part=$(basename "$(find "$SPI_PATH/$1" -type d -maxdepth 1 | grep "mtd[6-9]$")") ; then
        logger -t bios-update "Partition found: $spi_part"
        # shellcheck disable=SC2003,SC2046,SC2006
        mbsize=$(expr `cat "$SPI_PATH/$1"/*/size` / 1048576) # convert to MB (divide by 1024*1024)
        logger -t bios-update "SPI size: $mbsize MB"
        mtd_num=$spi_part
    else
        logger -t bios-update "MTD part not found for $1"
        exit 1
    fi
}

bind_spi_dev() {

    GPIO0=$2
    GPIO1=$3
    GPIO2=$4

    logger -t bios-update "unbinding $1 to aspeed-smc spi driver"
    echo -n "$1" > $SPI_PATH/unbind

    logger -t bios-update "binding $1 to aspeed-smc spi driver"
    if echo -n "$1" > $SPI_PATH/bind; then
        logger -t bios-update "SPI Driver Bind Successful"
    else
        logger -t bios-update "SPI Driver Bind Failed."
        set_gpio_to_host "$GPIO0"
        set_gpio_to_host "$GPIO1"
        if [ -n "$GPIO2" ]; then
            set_gpio_to_host "$GPIO2"
        fi
        exit 1
    fi
}

unbind_spi_dev() {
    logger -t bios-update "Unbind aspeed-smc spi driver for $1"
    echo -n "$1" > $SPI_PATH/unbind
}

power_status() {
    st=$(busctl get-property xyz.openbmc_project.State.Chassis /xyz/openbmc_project/state/chassis0 xyz.openbmc_project.State.Chassis CurrentPowerState | cut -d"." -f6)
    if [ "$st" == "On\"" ]; then
        echo "on"
    else
        echo "off"
    fi
}

set_gpio_to_bmc()
{
    GPIO=$1
    value=$2

    logger -t bios-update "switch bios GPIO $GPIO to bmc"

    if [ ! -d "/sys/class/gpio/gpio$GPIO" ]; then

        echo "$GPIO" > /sys/class/gpio/export
        cd "/sys/class/gpio/gpio$GPIO" || exit 1
    else
        cd "/sys/class/gpio/gpio$GPIO" || exit 1
    fi
    direc=$(cat direction)
    if [ "$direc" == "in" ]; then
        echo "out" > direction
    fi
    data=$(cat value)
    if [ "$data" == "0" ]; then
        echo "$value" > value
    fi

    return 0
}

set_gpio_to_host()
{
    GPIO0=$1

    logger -t bios-update "switch bios GPIO $GPIO0 to host"

    if [ ! -d "/sys/class/gpio/gpio$GPIO0" ]; then
        echo "$GPIO0" > /sys/class/gpio/export
        cd "/sys/class/gpio/gpio$GPIO0" || exit 1
    else
        cd "/sys/class/gpio/gpio$GPIO0" || exit 1
    fi
    direc="cat direction"
    if [ "$direc" == "in" ]; then
        echo "out" > direction
    fi
    data="cat value"
    if [ "$data" == "1" ]; then
        echo 0 > value
    fi
    echo "in" > direction
    echo "$GPIO0" > /sys/class/gpio/unexport

    return 0
}

flash_image_to_mtd()
{
    logger -t bios-update "$IMAGE_DIR"

    pushd "$IMAGE_DIR" || exit 1

    IMAGE_FILE=$(find . -type f -name '*.FD')

    if [ -e "$IMAGE_FILE" ];
    then
        logger -t bios-update "Bios image is $IMAGE_FILE"
        for d in $mtd_num ; do
            if [ -e "/dev/$d" ]; then
                mtd=$(cat "/sys/class/mtd/$d/name")
                if [ "$mtd" == "pnor" ]; then
                    logger -t bios-update "Flashing bios image to $d..."
                    flash_eraseall /dev/"$d"
                    if dd if="$IMAGE_FILE" of=/dev/"$d" bs=4096; then
                        logger -t bios-update "bios updated successfully..."
                    else
                        logger -t bios-update "bios update failed..."
                    fi
                    break
                fi
                logger -t bios-update "$d is not a pnor device"
            fi
            logger -t bios-update "$d not available"
        done
    else
        logger -t bios-update "Bios image $IMAGE_FILE doesn't exist"
    fi
    popd || return
}

trigger_local_bios_update()
{
    GPIO0=$1
    GPIO1=$2
    GPIO2=$3

    value0=$4
    value1=$5
    value2=$6

    #Flip GPIO to access SPI flash used by host.
    logger -t bios-update "Set GPIO $GPIO0 and $GPIO1 to access BIOS flash from BMC used by host"
    set_gpio_to_bmc "$GPIO0" "$value0"
    set_gpio_to_bmc "$GPIO1" "$value1"
    set_gpio_to_bmc "$GPIO2" "$value2"

    #Bind spi driver to access flash
    bind_spi_dev $SPI_DEVICE_1 "$GPIO0" "$GPIO1" "$GPIO2"
    sleep 1

    #Flashcp image to device.
    get_mtd_info $SPI_DEV_1
    sleep 1
    flash_image_to_mtd

    #Unbind spi driver
    sleep 1
    unbind_spi_dev $SPI_DEVICE_1
    sleep 1

    #Flip GPIO back for host to access SPI flash
    logger -t bios-update "Set GPIO $GPIO0, $GPIO1, $GPIO2 back for host to access SPI flash"
    set_gpio_to_host "$GPIO0"
    set_gpio_to_host "$GPIO1"
    set_gpio_to_host "$GPIO2"
    sleep 1
}

logger -t bios-update "Bios upgrade started at $(date)"

if [ "$(power_status)" == "on" ]; then
    logger -t bios-update "Power off host server"
    power_off
    sleep 10
fi

if [ "$(power_status)" != "off" ];
then
    logger -t bios-update "Host server didn't power off"
    logger -t bios-update "Bios upgrade failed"
    exit 1
fi
logger -t bios-update "Host server powered off"

#Trigger local bios update for P0 flash
# [001] = P0 Local BIOS
logger -t bios-update "Updating P0 local BIOS flash"
trigger_local_bios_update "$GPIOAB3" "$GPIOAB4" "$GPIOAB5" 1 0 0

logger -t bios-update "Updating P1 local BIOS flash"
trigger_local_bios_update "$GPIOAB3" "$GPIOAB4" "$GPIOAB5" 1 0 1

if [ "$st" == "On\"" ]; then
    logger -t bios-update "Power on host server"
    power_on
    sleep 1
fi

exit 0
