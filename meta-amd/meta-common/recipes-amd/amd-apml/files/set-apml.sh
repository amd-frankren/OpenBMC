#!/bin/bash

num_of_cpu=$(/sbin/fw_printenv -n num_of_cpu)

DEV_I3C_SBTSI_PATH="/sys/bus/i3c/drivers/sbtsi_i3c"
DEV_I3C_SBTSI_4="4-118"
DEV_I3C_SBTSI_5="5-118"

DEV_I3C_SBRMI_PATH="/sys/bus/i3c/drivers/sbrmi_i3c"
DEV_I3C_SBRMI_4="4-1118"
DEV_I3C_SBRMI_5="5-1118"

# Set i3c APML
set_i3c_apml()
{
    echo "Starting APML over i3c "

    # start platform i3c driver
    modprobe mipi_i3c_hci
}

# unbind i3c drivers
unbind_i3c_drivers()
{
    # Unbind sbtsi and sbrmi drivers
    echo  $DEV_I3C_SBTSI_4 > $DEV_I3C_SBTSI_PATH/unbind
    sleep 1
    echo  $DEV_I3C_SBRMI_4 > $DEV_I3C_SBRMI_PATH/unbind
    if [[ $num_of_cpu == 2 ]]
    then
        echo  $DEV_I3C_SBTSI_5 > $DEV_I3C_SBTSI_PATH/unbind
        echo  $DEV_I3C_SBRMI_5 > $DEV_I3C_SBRMI_PATH/unbind
    fi
    # Remove platform i3c driver
    sleep 3
    rmmod mipi_i3c_hci
}

# Main()
#---------

# check num of cpu
echo "Num of CPU " "$num_of_cpu"
if [[ $1 == "bind" ]];then
    set_i3c_apml
elif [[ $1 == "unbind" ]];then
    unbind_i3c_drivers
else
    echo "set-apml.sh takes a single string as input"
    echo "    bind   = Bind   I2C/I3C drivers for APML"
    echo "    unbind = Unbind I2C/I3C drivers for APML"
fi
