#!/bin/bash

set -e

SLEEP_TIME=5

# Pump Fans
HWMON_PATH="/sys/class/hwmon/"
PUMP_I2C_1P=122
PUMP_I2C_2P=125

MAX_CNT=12
declare -i faultCnt1=0
declare -i faultCnt2=0

power_off()
{
    busctl set-property xyz.openbmc_project.State.Chassis /xyz/openbmc_project/state/chassis0 xyz.openbmc_project.State.Chassis RequestedPowerTransition s xyz.openbmc_project.State.Chassis.Transition.Off
}

check_cpu_temp()
{
    # Extract the temperature value from the output using awk
    temp=$(apml_tool 0 --readregister sbtsi 0x01 |grep 0x1 | cut -c 19-21)
    temp_int=$((16#${temp}))

    # Check the temperature value and run the appropriate script

    if [ "$temp_int" -ge 90 ]; then
        echo "Temperature is above 90°C. Running set-fan-speed.sh 100%"
        set-fan-speed.sh 0xff  >/dev/null
    elif [ "$temp_int" -ge 70 ] && [ "$temp_int" -lt 90 ]; then
        echo "Temperature is between 70°C and 90°C. Running set-fan-speed.sh 50%"
        set-fan-speed.sh 0x7f  >/dev/null
    else
        set-fan-speed.sh 0x4C  >/dev/null
    fi
}

check_rpm()
{
    if [ "$2" -eq 1 ]; then
        faultCnt=$faultCnt1
    else
        faultCnt=$faultCnt2
    fi
    if [ "$1" -ge 5200 ]; then
        faultCnt=$((faultCnt + 1))
        echo "Pump Fault Cnt = " $faultCnt " RPM = " $1
        if [ "$faultCnt" -ge "$MAX_CNT"]; then
            echo "PUMP RPM is above 5200. Power Off "
            logger -t "manage-fan-speed" "Error: PUMP RPM is above 5200. Power Off "
            power_off
            faultCnt=0
        fi
    elif [ "$1" -le 3400 ]; then
        faultCnt=$((faultCnt + 1))
        echo "Pump Fault Cnt = " $faultCnt " RPM = " $1
        if [ "$faultCnt" -ge "$MAX_CNT" ]; then
            echo "PUMP RPM is below 3400. Power Off "
            logger -t "manage-fan-speed" "Error: PUMP RPM is below 3400. Power Off "
            power_off
            faultCnt=0
        fi
    else
        faultCnt=0
    fi
    if [ "$2" -eq 1 ]; then
        faultCnt1=$faultCnt
    else
        faultCnt2=$faultCnt
    fi
}
check_pump_fan()
{
    hwmon=$(ls -l $HWMON_PATH |grep -i $PUMP_I2C-004d |cut -c 58-63)
    if [ "$P2" == "true" ]; then
        rpm=$(cat "$HWMON_PATH$hwmon/fan1_input")
        check_rpm $rpm 1
        if [ "$P1present" == "true" ]; then
            rpm=$(cat "$HWMON_PATH$hwmon/fan2_input")
            check_rpm $rpm 2
        fi
    else
        rpm=$(cat "$HWMON_PATH$hwmon/fan5_input")
        check_rpm $rpm 1
    fi
}

# Main()
#---------
board_id=$(/sbin/fw_printenv -n board_id)
case "$board_id" in
    # Marley(79, 0x7A, 0x7B)
    # Morocco(0x82, 0x83, 0x87)
    # Malawi (0x8A)
    "79" | "7A" | "7B" | "82" | "83" | "87" | "8A")
        PUMP_I2C=$PUMP_I2C_2P
        P2="true"
        # TBD do not check P1 yet, need new FPGA
        # gpioget 2 12
        P1present="false"
        ;;
    # Congo(0x80, 0x81, 0x86)
    # Senegal (0x88)
    # Sahara (0x89)
    # Zambia (0x8B)
    # Zimbabwe (0x8C)
    # Zanzibar (0x8D)
    # Zaire (0x9E)
    # Marrakesh (0xB0)
    "80" | "81" | "86" | "88" | "89" | "8B" | "8C" | "8D" | "9E" | "B0")
        PUMP_I2C=$PUMP_I2C_1P
        P2="false"
        ;;
    # Kenya(0x84)
    # Nigeria(0x85)
    "84" | "85")
        PUMP_I2C=0
        ;;
    # Ghana (0x8E)
    "8E")
        PUMP_I2C=$PUMP_I2C_2P
        ;;
    *)
        PUMP_I2C=0
        ;;
esac

while :
do
    if [[ $1 == "true" ]];then
        check_cpu_temp
    else
        set-fan-speed.sh 0x7f >/dev/null
    fi
    if [[ $2 == "true" ]];then
        if [ $PUMP_I2C -ne "0" ];then
            check_pump_fan
        fi
    fi
    sleep $SLEEP_TIME
done
