#!/bin/bash

num_of_cpu=`/sbin/fw_printenv -n num_of_cpu`

# i2c BUS
DEV_I2C_2="/dev/i2c-2"
DEV_I2C_3="/dev/i2c-3"
I2C_BUS=2
I2C_MUX=0x70

DEV_I2C_SBTSI_PATH="/sys/bus/i2c/drivers/sbtsi"
DEV_I2C_SBTSI_2="2-004c"
DEV_I2C_SBTSI_3="3-0048"
DEV_I2C_SBRMI_PATH="/sys/bus/i2c/drivers/sbrmi"
DEV_I2C_SBRMI_2="2-003c"
DEV_I2C_SBRMI_3="3-0038"

# i3c bus
I3C_TOOL="/usr/bin/i3ctransfer"
DEV_I3C_PATH="/sys/bus/platform/drivers/dw-i3c-master"
DEV_I3C_4="1e7a6000.i3c4"
DEV_I3C_5="1e7a7000.i3c5"
I3C_MUX_0="/dev/i3c-4-4cc00000000"
I3C_MUX_1="/dev/i3c-5-4cc00000000"
i3c_mux_present=0

DEV_I3C_SBTSI_PATH="/sys/bus/i3c/drivers/sbtsi_i3c"
DEV_I3C_SBTSI_4="4-22400000001"
DEV_I3C_SBTSI_5="5-22400000001"

DEV_I3C_SBRMI_PATH="/sys/bus/i3c/drivers/sbrmi_i3c"
DEV_I3C_SBRMI_4="4-22400000002"
DEV_I3C_SBRMI_5="5-22400000002"

# Set i2c APML
set_i2c_apml()
{
    echo "Setting I2C-2 Mux for CPU APML "
    I2C_BUS=2
    i2cset -f -y $I2C_BUS $I2C_MUX 0x46 0x01 || retval=$?
    if [[ "$retval" -ne 0 ]]; then
        echo "Error: Setting I2C Mux Reg 0x46"
    fi
    i2cset -f -y $I2C_BUS $I2C_MUX 0x40 0x40 || retval=$?
    if [[ "$retval" -ne 0 ]]; then
        echo "Error: Setting I2C Mux Reg 0x40"
    fi
    i2cset -f -y $I2C_BUS $I2C_MUX 0x41 0x40 || retval=$?
    if [[ "$retval" -ne 0 ]]; then
        echo "Error: Setting I2C Mux Reg 0x41"
    fi
    # bind sbtsi/sbrmi driver
    echo  $DEV_I2C_SBTSI_2 > $DEV_I2C_SBTSI_PATH/bind
    echo  $DEV_I2C_SBRMI_2 > $DEV_I2C_SBRMI_PATH/bind

    if [ -a "$DEV_I2C_3" ]
    then
        echo "Setting I2C-3 Mux for CPU APML "
        I2C_BUS=3
        i2cset -f -y $I2C_BUS $I2C_MUX 0x46 0x01 || retval=$?
        if [[ "$retval" -ne 0 ]]; then
            echo "Error: Setting I2C Mux Reg 0x46"
        fi
        i2cset -f -y $I2C_BUS $I2C_MUX 0x40 0x40 || retval=$?
        if [[ "$retval" -ne 0 ]]; then
            echo "Error: Setting I2C Mux Reg 0x40"
        fi
        i2cset -f -y $I2C_BUS $I2C_MUX 0x41 0x40 || retval=$?
        if [[ "$retval" -ne 0 ]]; then
            echo "Error: Setting I2C Mux Reg 0x41"
        fi
        # bind sbtsi/sbrmi driver
        echo  $DEV_I2C_SBTSI_3 > $DEV_I2C_SBTSI_PATH/bind
        echo  $DEV_I2C_SBRMI_3 > $DEV_I2C_SBRMI_PATH/bind
    fi
}

# unbind i2c drivers
unbind_i2c_drivers()
{
    echo "Unbind i2c-2 SBRMI and SBTSI drivers "
    I2C_BUS=2
    # Unbind sbtsi/sbrmi driver
    echo  $DEV_I2C_SBTSI_2 > $DEV_I2C_SBTSI_PATH/unbind
    echo  $DEV_I2C_SBRMI_2 > $DEV_I2C_SBRMI_PATH/unbind
    #disable i2c MUX
    i2cset -f -y $I2C_BUS $I2C_MUX 0x40 0x00 || retval=$?
    if [[ "$retval" -ne 0 ]]; then
        echo "Error: Setting I2C Mux Reg 0x40"
    fi
    i2cset -f -y $I2C_BUS $I2C_MUX 0x41 0x00 || retval=$?
    if [[ "$retval" -ne 0 ]]; then
        echo "Error: Setting I2C Mux Reg 0x41"
    fi
    if [ -a "$DEV_I2C_3" ]
    then
        echo "unbind i2c-3 SBRMI and SBTSI drivers"
        I2C_BUS=3
        # Unbind sbtsi/sbrmi driver
        echo  $DEV_I2C_SBTSI_3 > $DEV_I2C_SBTSI_PATH/unbind
        echo  $DEV_I2C_SBRMI_3 > $DEV_I2C_SBRMI_PATH/unbind
        #disable i2c MUX
        i2cset -f -y $I2C_BUS $I2C_MUX 0x40 0x00 || retval=$?
        if [[ "$retval" -ne 0 ]]; then
            echo "Error: Setting I2C Mux Reg 0x40"
        fi
        i2cset -f -y $I2C_BUS $I2C_MUX 0x41 0x00 || retval=$?
        if [[ "$retval" -ne 0 ]]; then
            echo "Error: Setting I2C Mux Reg 0x41"
        fi
    fi
}

# Set i3c APML
set_i3c_apml()
{
    echo "Setting I3C Mux for CPU 0 APML "

    sleep 1
    # Bind platform i3c driver
    echo  $DEV_I3C_4 > $DEV_I3C_PATH/bind
    sleep 1

    $I3C_TOOL -d $I3C_MUX_0 -w 0x46,0x00,0x01
    $I3C_TOOL -d $I3C_MUX_0 -w 0x0E,0x00,0x24
    $I3C_TOOL -d $I3C_MUX_0 -w 0x40,0x00,0x40
    $I3C_TOOL -d $I3C_MUX_0 -w 0x41,0x00,0x40

    # Unbind sbtsi driver
    echo  $DEV_I3C_SBTSI_4 > $DEV_I3C_SBTSI_PATH/unbind
    echo  $DEV_I3C_SBRMI_4 > $DEV_I3C_SBRMI_PATH/unbind
    sleep 1
    # Unbind platform i3c driver
    echo  $DEV_I3C_4 > $DEV_I3C_PATH/unbind
    sleep 1
    # Bind platform i3c driver
    echo  $DEV_I3C_4 > $DEV_I3C_PATH/bind

    if [[ $num_of_cpu == 2 ]]
    then
        sleep 1
        # Bind platform i3c driver
        echo  $DEV_I3C_5 > $DEV_I3C_PATH/bind
        sleep 1

        $I3C_TOOL -d $I3C_MUX_1 -w 0x46,0x00,0x01
        $I3C_TOOL -d $I3C_MUX_1 -w 0x0E,0x00,0x24
        $I3C_TOOL -d $I3C_MUX_1 -w 0x40,0x00,0x40
        $I3C_TOOL -d $I3C_MUX_1 -w 0x41,0x00,0x40
        # Unbind sbtsi driver
        echo  $DEV_I3C_SBTSI_5 > $DEV_I3C_SBTSI_PATH/unbind
        echo  $DEV_I3C_SBRMI_5 > $DEV_I3C_SBRMI_PATH/unbind
        sleep 1
        # Unbind platform i3c driver
        echo  $DEV_I3C_5 > $DEV_I3C_PATH/unbind
        sleep 1
        # Bind platform i3c driver
        echo  $DEV_I3C_5 > $DEV_I3C_PATH/bind
    fi
}

# unbind i3c drivers
unbind_i3c_drivers()
{
    # Unbind sbtsi and sbrmi drivers
    echo  $DEV_I3C_SBTSI_4 > $DEV_I3C_SBTSI_PATH/unbind
    echo  $DEV_I3C_SBRMI_4 > $DEV_I3C_SBRMI_PATH/unbind
    # Unbind platform i3c driver
    sleep 1
    echo  $DEV_I3C_4 > $DEV_I3C_PATH/unbind

    if [[ $num_of_cpu == 2 ]]
    then
        echo  $DEV_I3C_SBTSI_5 > $DEV_I3C_SBTSI_PATH/unbind
        echo  $DEV_I3C_SBRMI_5 > $DEV_I3C_SBRMI_PATH/unbind
        # Unbind platform i3c driver
        sleep 1
        echo  $DEV_I3C_5 > $DEV_I3C_PATH/unbind
    fi
}

# Main()
#---------

# check num of cpu
echo "Num of CPU " $num_of_cpu

if [[ $1 == "i3c" ]];then
    fw_setenv apml_i3c true
    reboot now
elif [[ $1 == "i2c" ]];then
    fw_setenv apml_i3c false
    reboot now
elif [[ $1 == "bind" ]];then
    if [[ -a "$DEV_I2C_2" ]];then
        echo "Bind I2C Drivers"
        set_i2c_apml
    else
        echo "Bind I3C Drivers"
        set_i3c_apml
    fi
elif [[ $1 == "unbind" ]];then
    if [[ -a "$DEV_I2C_2" ]];then
        echo "UnBind I2C Drivers"
        unbind_i2c_drivers
    else
        echo "UnBind I3C Drivers"
        unbind_i3c_drivers
    fi
else
    echo "set-apml.sh takes a single string as input"
    echo "    i3c    = set APML to I3C mode, and Reboot"
    echo "    i2c    = set APML to I2C mode, and Reboot"
    echo "    bind   = Bind   I2C/I3C drivers for APML"
    echo "    unbind = Unbind I2C/I3C drivers for APML"
    echo "APML mode is"
    fw_printenv |grep apml_i3c
fi
