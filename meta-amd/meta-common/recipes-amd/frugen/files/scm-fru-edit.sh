#!/bin/bash

# Board Info GPIOs
GPIO_Z0=$(gpioget 1 $(((25*8) + 0)))
GPIO_Z1=$(gpioget 1 $(((25*8) + 1)))
GPIO_Z4=$(gpioget 1 $(((25*8) + 4)))
GPIO_Z5=$(gpioget 1 $(((25*8) + 5)))
GPIO_Z6=$(gpioget 1 $(((25*8) + 6)))
GPIO_Z7=$(gpioget 1 $(((25*8) + 7)))

# HW fields
SCMboard=""
SCMtype=""
SOCvendor="1" # Aspeed = 1, Nuovoton = 2
SOCmodel="" # AST2600 = 1, AST2700 = 2, AST2750 = 3
SOCsilrev=""
SCMboardrev=""
SCMbuild=""

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
		# A0
		# [7:4] => 0 for Beta build release
		echo 'SCMbuild="0";SOCsilrev="0"'
	elif [ "$GPIO_Z4" == "0" ] && [ "$GPIO_Z5" == "1" ] ; then
		# A1
		# 0x10 [7:4] => 1 for RevA build release
		echo 'SCMbuild="1";SOCsilrev="1"'
	else
		echo "ÿ" # 0xFF in ASCII
	fi
}

eval "$(scm_board_info)"
SCMboardrev=$(scm_board_rev)
eval "$(soc_sil_rev)"
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
if [ "$SCMbuild" == "0" ] ; then
        SCMbuildstr="Beta"
elif [ "$SCMbuild" == "1" ] ; then
        SCMbuildstr="RevA Build"
else
        SCMbuildstr="Beta" # default
fi
echo "SCM build type:  $SCMbuildstr"
echo ""
read -p "Do you want to override HW detected fields? [y/n] : " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo ""
	read -r -p "Enter SCM name: " SCMboard
	read -r -p "Enter SCM Board Rev: " SCMboardrev
	read -r -p "Enter SCM Type: " SCMtype
	read -r -p "Enter SoC vendor: " SOCvendor
	read -r -p "Enter SoC model: " SOCmodel
	read -r -p "Enter SoC silicon rev: " SOCsilrev
	read -r -p "Enter SCM Build type (\"0\" for Beta, \"1\"  for RevA): " SCMbuild
	if [[ "$SCMbuild" != "0" && "$SCMbuild" != "1" ]] ; then
		echo "Invalid Build release type, defaulting to Beta"
		SCMbuild="0"
	fi
	echo ""
	echo "New SCM information"
	echo "------------------------"
	echo "SCM Name:        $SCMboard"
	echo "SCM Board Rev:   $SCMboardrev"
	echo "SCM Type:        $SCMtype"
	echo "SOC vendor:      $SOCvendor"
	echo "SOC model:       $SOCmodel"
	echo "SOC silicon Rev: $SOCsilrev"
	echo "SCM build:       $SCMbuild (0 - Beta, 1 - RevA)"
fi
echo ""
echo "Enter custom fields:"
echo "(default values are within [])"
echo
if frugen-static -Y "$SCMbuild" --from=/etc/SCM_v1.json -n "$SCMboard" -Q "$SCMtype" -q "$SCMboardrev" -w "$SOCvendor" -W "$SOCmodel" -y "$SOCsilrev" /tmp/scm_fru.bin ; then
	dd if=/tmp/scm_fru.bin of=/sys/bus/i2c/devices/7-0050/eeprom
	echo "FRU programming complete"
	echo ""
	echo "FRU EEPROM DUMP"
	hexdump -C /sys/bus/i2c/devices/7-0050/eeprom
fi
