#!/bin/bash

board_id=$(/sbin/fw_printenv -n board_id)
case "$board_id" in
    # Congo(0x80, 0x81, 0x86)
    # Kenya(0x84)
    # Senegal (0x88)
    # Sahara (0x89)
    # Zambia (0x8B)
    # Zimbabwe (0x8C)
    # Zanzibar (0x8D)
    "80" | "81" | "84" | "86" | "88" | "89" | "8B" | "8C" | "8D")
        num_of_cpu=1
        ;;
    # Morocco(0x82, 0x83, 0x87)
    # Malawi (0x8A)
    # Nigeria(0x85)
    # Ghana (0x8E)
    "82" | "83" | "85" | "87" | "8A" | "8E")
        num_of_cpu=2
        ;;
    *)
    # all i3c devices must be unbind before removing i3c driver
    # it is safer to remove devices for both P0/P1 if Board ID is unknown
        num_of_cpu=2
        ;;
esac

DEV_I3C_SBTSI_PATH="/sys/bus/i3c/drivers/sbtsi_i3c"
DEV_I3C_SBTSI_4="4-118"
DEV_I3C_SBTSI_4_1="4-10118"
DEV_I3C_SBTSI_5="5-1000118"
DEV_I3C_SBTSI_5_1="5-1010118"

DEV_I3C_SBRMI_PATH="/sys/bus/i3c/drivers/sbrmi_i3c"
DEV_I3C_SBRMI_4="4-1118"
DEV_I3C_SBRMI_5="5-1001118"

DEV_I3C_SCOOB_PATH="/sys/bus/i3c/drivers/mctp-i3c"
DEV_I3C_SCOOB_4="4-2118"
DEV_I3C_SCOOB_4_1="4-12118"
DEV_I3C_SCOOB_5="5-1002118"
DEV_I3C_SCOOB_5_1="5-1012118"

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
    echo  $DEV_I3C_SBTSI_4_1 > $DEV_I3C_SBTSI_PATH/unbind
    sleep 1
    echo  $DEV_I3C_SBRMI_4 > $DEV_I3C_SBRMI_PATH/unbind
    sleep 1
    echo  $DEV_I3C_SCOOB_4 > $DEV_I3C_SCOOB_PATH/unbind
    sleep 1
    echo  $DEV_I3C_SCOOB_4_1 > $DEV_I3C_SCOOB_PATH/unbind
    sleep 1
    if [[ $num_of_cpu == 2 ]]
    then
        echo  $DEV_I3C_SBTSI_5 > $DEV_I3C_SBTSI_PATH/unbind
        sleep 1
        echo  $DEV_I3C_SBTSI_5_1 > $DEV_I3C_SBTSI_PATH/unbind
        sleep 1
        echo  $DEV_I3C_SBRMI_5 > $DEV_I3C_SBRMI_PATH/unbind
        sleep 1
        echo  $DEV_I3C_SCOOB_5 > $DEV_I3C_SCOOB_PATH/unbind
        sleep 1
        echo  $DEV_I3C_SCOOB_5_1 > $DEV_I3C_SCOOB_PATH/unbind
        sleep 1
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
