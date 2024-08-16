#!/bin/bash

# Board Info GPIOs
GPIO_Z0=$(gpioget 0 $(((25*8) + 0)))
GPIO_Z1=$(gpioget 0 $(((25*8) + 1)))
GPIO_Z4=$(gpioget 0 $(((25*8) + 4)))
GPIO_Z5=$(gpioget 0 $(((25*8) + 5)))
GPIO_Z6=$(gpioget 0 $(((25*8) + 6)))
GPIO_Z7=$(gpioget 0 $(((25*8) + 7)))

# HW fields
SCMboard=""
SCMtype=""
SOCvendor="1" # Aspeed = 1, Nuovoton = 2
SOCmodel="" # AST2600 = 1, AST2700 = 2, AST2750 = 3
SOCsilrev=""
SCMboardrev=""

# Board Name
#  0  0 - Malta-V
#  0  1 - Malta-H
#  1  0 - Bahama-V
#  1  1 - Bahama-H
function scm_board_info() {
	if [ "$GPIO_Z0" == "0" ] && [ "$GPIO_Z1" == "0" ] ; then
		echo 'SCMtype="1";SOCmodel="2";SCMboard="Malta-V"'
	elif [ "$GPIO_Z0" == "0" ] && [ "$GPIO_Z1" == "1" ] ; then
		echo 'SCMtype="1";SOCmodel="2";SCMboard="Malta-H"'
	elif [ "$GPIO_Z0" == "1" ] && [ "$GPIO_Z1" == "0" ] ; then
		echo 'SCMtype="2";SOCmodel="3";SCMboard="Bahama-V"'
 	elif [ "$GPIO_Z0" == "1" ] && [ "$GPIO_Z1" == "1" ] ; then
		echo 'SCMtype="2";SOCmodel="3";SCMboard="Bahama-H"'
	else
		echo ""
	fi
}

# Board Rev
# 0 0 -> Rev A
function scm_board_rev() {
	if [ "$GPIO_Z6" == "0" ] && [ "$GPIO_Z7" == "0" ] ; then
		echo "A"
	else
		echo "ÿ" # 0xFF in ASCII
	fi
}

# SoC silicon Rev
# 0 0 -> A0
# 0 1 -> A1
function soc_sil_rev() {
	if [ "$GPIO_Z4" == "0" ] && [ "$GPIO_Z5" == "0" ] ; then
		echo "0" # A0
	else
		echo "ÿ" # 0xFF in ASCII
	fi
}

eval "$(scm_board_info)"
SCMboardrev=$(scm_board_rev)
SOCsilrev=$(soc_sil_rev)
clear
echo "SCM FRU EDITOR"
echo ""
echo "Detected SCM information"
echo "------------------------"
echo "SCM Name:        $SCMboard"
echo "SCM Board Rev:   $SCMboardrev"
echo "SCM Type:        $SCMtype"
echo "SOC vendor:      $SOCvendor"
echo "SOC model:       $SOCmodel"
echo "SOC silicon Rev: $SOCsilrev"
echo ""
echo "Enter custom fields:"
echo "(default values are within [])"
echo
if frugen-static --from=/etc/SCM_v1.json -n "$SCMboard" -Q "$SCMtype" -q "$SCMboardrev" -w "$SOCvendor" -W "$SOCmodel" -y "$SOCsilrev"  /tmp/scm_fru.bin ; then
	dd if=/tmp/scm_fru.bin of=/sys/bus/i2c/devices/7-0050/eeprom
	echo "FRU programming complete"
	echo ""
	echo "FRU EEPROM DUMP"
	hexdump -C /sys/bus/i2c/devices/7-0050/eeprom
fi
