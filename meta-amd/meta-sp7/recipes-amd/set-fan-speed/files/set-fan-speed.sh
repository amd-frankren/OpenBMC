#!/bin/bash

set -e

#Speed Limit 20% (Range 0x0 to 0xFF)
SPEED_LIMIT=0x32

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
    echo "Error : You can not set Fan speed less then 20% (0x32)"
    exit 1
else
    speed_val=$1
fi

board_id=$(/sbin/fw_printenv -n board_id)
case "$board_id" in
    # Marley(79, 0x7A, 0x7B)
    # Congo(0x80, 0x81, 0x86)
    # Morocco(0x82, 0x83, 0x87)
    "79" | "7A" | "7B" | "80" | "81" | "86" | "82" | "83" | "87")
        # Call functions to set EMC2305  Fan speeds
        set_emc2305_fan_speed
        ;;
    *)
        echo " Unknown board_id $board_id"
        echo " Please program board FRU EEPROM"
        ;;
esac

exit 0
