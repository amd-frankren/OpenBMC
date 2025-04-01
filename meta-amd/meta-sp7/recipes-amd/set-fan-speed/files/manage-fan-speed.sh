#!/bin/bash

while :
do
    # Extract the temperature value from the output using awk
    temp=$(apml_tool 0 --readregister sbtsi 0x01 |grep 0x1 | cut -c 13-14)
    temp_int=$((16#${temp}))

    # Print the extracted temperature value
    echo "Extracted Temperature: $temp_int ($temp) °C"

    # Check the temperature value and run the appropriate script

    if [ "$temp_int" -ge 90 ]; then
        echo "Temperature is above 90°C. Running set-fan-speed.sh 100%"
        set-fan-speed.sh 0xff
    elif [ "$temp_int" -ge 70 ] && [ "$temp_int" -lt 90 ]; then
        echo "Temperature is between 70°C and 90°C. Running set-fan-speed.sh 50%"
        set-fan-speed.sh 0x7f
    else
        echo "Temperature is below 70°C. Running set-fan-speed.sh 20%"
        set-fan-speed.sh 0x32
    fi
    sleep 5
done
