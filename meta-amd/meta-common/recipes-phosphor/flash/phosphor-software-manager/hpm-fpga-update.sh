#!/bin/bash

# HPM FPGA upgrade
# Below are the BMC SGPIO settings to access HPM FPGA SPI flash
# GPIOs: [SGPIO_O7, SGPIO_O5, SGPIO_O3]
#   	[000] = Run Mode
#   	[001] = Local P0 BIOS SPI
#   	[101] = Local P1 BIOS SPI
#   	[010] = HPM FPGA SPI
#   	[011] = HPM LOM SPI
#

set +e

IMAGE_DIR=$1

GPIOCHIP=524
GPIOO3=$((${GPIOCHIP} + 115))
GPIOO5=$((${GPIOCHIP} + 117))
GPIOO7=$((${GPIOCHIP} + 119))

SPI_DEV="1e631000.spi"
SPI_PATH="/sys/bus/platform/drivers/aspeed-smc"

set_gpio_to_bmc()
{
    echo "switch HPM FPGA GPIO to bmc"
#GPIO_O3
    if [ ! -d /sys/class/gpio/gpio$GPIOO3 ]; then
        cd /sys/class/gpio
        echo $GPIOO3 > export
        cd gpio$GPIOO3
    else
        cd /sys/class/gpio/gpio$GPIOO3
    fi
    direc=`cat direction`
    if [ $direc == "in" ]; then
        echo "out" > direction
    fi
    data=`cat value`
    if [ "$data" == "1" ]; then
        echo 0 > value
    fi

# GPIO_O5
    if [ ! -d /sys/class/gpio/gpio$GPIOO5 ]; then
        cd /sys/class/gpio
        echo $GPIOO5 > export
        cd gpio$GPIOO5
    else
        cd /sys/class/gpio/gpio$GPIOO5
    fi
    direc=`cat direction`
    if [ $direc == "in" ]; then
        echo "out" > direction
    fi
    data=`cat value`
    if [ "$data" == "0" ]; then
        echo 1 > value
    fi

#GPIO_O7
    if [ ! -d /sys/class/gpio/gpio$GPIOO7 ]; then
        cd /sys/class/gpio
        echo $GPIOO7 > export
        cd gpio$GPIOO7
    else
        cd /sys/class/gpio/gpio$GPIOO7
    fi
    direc=`cat direction`
    if [ $direc == "in" ]; then
        echo "out" > direction
    fi
    data=`cat value`
    if [ "$data" == "1" ]; then
        echo 0 > value
    fi
    return 0
}

set_gpio_to_hpm_fpga()
{
    # Set back to Run Mode '000'
    echo "switch GPIO to HPM FPGA"
#GPIO_O3
    if [ ! -d /sys/class/gpio/gpio$GPIOO3 ]; then
        cd /sys/class/gpio
        echo $GPIOO3 > export
        cd gpio$GPIOO3
    else
        cd /sys/class/gpio/gpio$GPIOO3
    fi
    direc=`cat direction`
    if [ $direc == "in" ]; then
        echo "out" > direction
    fi
    data=`cat value`
    if [ "$data" == "1" ]; then
        echo 0 > value
    fi

# GPIO_O5
    if [ ! -d /sys/class/gpio/gpio$GPIOO5 ]; then
        cd /sys/class/gpio
        echo $GPIOO5 > export
        cd gpio$GPIOO5
    else
        cd /sys/class/gpio/gpio$GPIOO5
    fi
    direc=`cat direction`
    if [ $direc == "in" ]; then
        echo "out" > direction
    fi
    data=`cat value`
    if [ "$data" == "1" ]; then
        echo 0 > value
    fi

#GPIO_O7
    if [ ! -d /sys/class/gpio/gpio$GPIOO7 ]; then
        cd /sys/class/gpio
        echo $GPIOO7 > export
        cd gpio$GPIOO7
    else
        cd /sys/class/gpio/gpio$GPIOO7
    fi
    direc=`cat direction`
    if [ $direc == "in" ]; then
        echo "out" > direction
    fi
    data=`cat value`
    if [ "$data" == "1" ]; then
        echo 0 > value
    fi
    return 0
}

echo "HPM FPGA upgrade started at $(date)"
ret=-1
#Flip GPIO to access SPI flash used by HPM FPGA.
echo "Set GPIO to access SPI flash from BMC used by hpm fpga"
set_gpio_to_bmc

#Bind spi driver to access flash
echo "bind aspeed-smc spi driver"
echo -n $SPI_DEV > $SPI_PATH/bind
if [ $? -eq 0 ];
then
    echo "SPI Driver Bind Successful"
    ret=0
else
    echo "SPI Driver Bind Failed.Run micron_v2.ini or micron_v3.ini using DediProg."
    set_gpio_to_hpm_fpga
    sleep 5
    ret=-1
fi
sleep 1

if [ $ret -eq 0 ];
then
    ret=-1
    #Flashcp image to device.
    echo $IMAGE_DIR
    pushd $IMAGE_DIR
    IMAGE_FILE=$(find -type f -name '*.bin')
    if [ -e "$IMAGE_FILE" ];
    then
        echo "Hpm fpga image is $IMAGE_FILE"
        for d in mtd6 mtd7 ; do
            if [ -e "/dev/$d" ]; then
                mtd=`cat /sys/class/mtd/$d/name`
                if [ $mtd == "pnor" ]; then
                    echo "Flashing hpm fpga image to $d..."
                    flashcp -v $IMAGE_FILE /dev/$d
                    if [ $? -eq 0 ]; then
                        echo "hpm fpga updated successfully..."
                        ret=0
                    else
                        echo "hpm fpga update failed..."
                    fi
                    break
                fi
                echo "$d is not a pnor device"
            fi
            echo "$d not available"
        done
    else
        echo "Hpm fpga image $IMAGE_FILE doesn't exist"
    fi
    popd

    #Unbind spi driver
    sleep 1
    echo "Unbind aspeed-smc spi driver"
    echo -n $SPI_DEV > $SPI_PATH/unbind
    sleep 10

    #Flip GPIO back for HPM FPGA to access SPI flash
    echo "Set GPIO back for HPM FPGA to access SPI flash"
    set_gpio_to_hpm_fpga
    sleep 5

    #reboot HOST
    echo "WARNING!! AC POWER CYCLE required to activate HPM FPGA"
fi
exit ${ret}
