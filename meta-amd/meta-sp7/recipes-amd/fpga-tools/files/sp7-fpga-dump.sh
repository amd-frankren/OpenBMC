#!/bin/bash

I2CBUS=12
FPGAADDR=0x50

SCRIPT_REG_MAP_VER=1

#---------------------------------------------------

function read_reg()
{
    local FPGA_REG=$1
    local DATA=$(i2cget -y $I2CBUS $FPGAADDR $(printf "0x%x" $FPGA_REG))
    echo -ne $((DATA))
}

function switch_status()
{
    local data=$1
    local bitmask=$2
    local bitshift=$3
    [[ $((((data & bitmask)) >> bitshift)) -eq 0 ]] && echo -ne "Off" || echo -ne "On"
}

function signal_status()
{
    local name=$1
    local data=$2
    local bitmask=$3
    local bitshift=$4
    local default_val=$5
    local curr_val=$((((data & bitmask)) >> bitshift))
    printf "%-30s %-8s %-8s\n" $1 $default_val $curr_val
}

function all_register_dump(){
    data=$(read_reg 0x06)
    printf 'Reg 0x06 (LTPI SIGNALS)=\t 0x%x \n' $data
    echo  "   LTPI SIGNALS            Default  Current "
    echo  "------------------------------------------- "

    signal_status LTPI_P0_MGMT_ASSERT_WARM_RST_BTN_L     $data 0x80 7 0
    signal_status LTPI_P0_MGMT_ASSERT_THERMTRIP         $data 0x40 6 0
    signal_status LTPI_P0_MGMT_ASSERT_RSMRST            $data 0x20 5 0
    signal_status LTPI_P0_MGMT_ASSERT_PROCHOT           $data 0x10 4 0
    signal_status LTPI_P0_MGMT_ASSERT_CLR_CMOS          $data 0x08 3 0
    signal_status LTPI_BMC_READY                        $data 0x04 2 0
    signal_status LTPI_P0_MGMT_ASSERT_PWR_BTN_L         $data 0x02 1 0
    signal_status LTPI_P0_MGMT_ASSERT_RST_BTN_L         $data 0x01 0 0
    printf "\n"

    data=$(read_reg 0x07)
    printf 'Reg 0x07 (LTPI SIGNALS)=\t 0x%x \n' $data
    echo  "   LTPI SIGNALS            Default  Current "
    echo  "------------------------------------------- "

    signal_status JTAG_TRST_N                       $data 0x80 7 0
    signal_status SCM_JTAG_DBREQ_L                  $data 0x40 6 0
    signal_status MGMT_HDT_SEL                      $data 0x20 5 0
    signal_status LTPI_P0_MGMT_SOC_RESET_L          $data 0x10 4 0
    signal_status LTPI_P0_MGMT_ASSERT_NMI_BTN_L     $data 0x08 3 0
    signal_status LTPI_MGMT_UPDATE_FLASH[2]         $data 0x04 2 0
    signal_status LTPI_MGMT_UPDATE_FLASH[1]         $data 0x02 1 0
    signal_status LTPI_MGMT_UPDATE_FLASH[0]         $data 0x01 0 0
    printf "\n"

    data=$(read_reg 0x08)
    printf 'Reg 0x08 (LTPI CSR)=\t 0x%x \n' $data
    echo  "   LTPI CSR            Default  Current "
    echo  "------------------------------------------- "

    signal_status local_link_state[3]        $data 0x80 7 0
    signal_status local_link_state[2]        $data 0x40 6 0
    signal_status local_link_state[1]        $data 0x20 5 0
    signal_status local_link_state[0]        $data 0x10 4 0
    signal_status remote_link_state[3]       $data 0x08 3 0
    signal_status remote_link_state[2]       $data 0x04 2 0
    signal_status remote_link_state[1]       $data 0x02 1 0
    signal_status remote_link_state[0]       $data 0x01 0 0
    printf "\n"

    data=$(read_reg 0x09)
    printf 'Reg 0x09 (LTPI CSR)=\t 0x%x \n' $data
    echo  "   LTPI CSR            Default  Current "
    echo  "------------------------------------------- "

    signal_status frame_crc_error       $data 0x80 7 0
    signal_status link_lost_err         $data 0x40 6 0
    signal_status link_aligned          $data 0x20 5 0
    signal_status RSVD                  $data 0x10 4 0
    signal_status RSVD                  $data 0x08 3 0
    signal_status RSVD                  $data 0x04 2 0
    signal_status RSVD                  $data 0x02 1 0
    signal_status RSVD                  $data 0x01 0 0
    printf "\n"

    data=$(read_reg 0x10)
    printf 'Reg 0x10 (P0 SIGNALS)=\t 0x%x \n' $data
    echo  "   P0 SIGNALS            Default  Current "
    echo  "------------------------------------------- "

    signal_status P0_THERMTRIP_L        $data 0x80 7 1
    signal_status P0_SLP_S5_L           $data 0x40 6 1
    signal_status P0_SLP_S3_L           $data 0x20 5 1
    signal_status P0_PRSNT_L            $data 0x10 4 0
    signal_status P0_RESET_L            $data 0x08 3 1
    signal_status P0_PWRGD_OUT          $data 0x04 2 1
    signal_status P0_PWROK              $data 0x02 1 1
    signal_status P0_SMERR_L            $data 0x01 0 1
    printf "\n"

    data=$(read_reg 0x11)
    printf 'Reg 0x11 (P0 SIGNALS)=\t 0x%x \n' $data
    echo  "    P0 SIGNALS              Default  Current "
    echo  "------------------------------------------- "

    signal_status P0_PWR_BTN_L              $data 0x80 7 1
    signal_status P0_SYS_RESET_L            $data 0x40 6 1
    signal_status P0_RSMRST_L               $data 0x20 5 1
    signal_status P0_PWR_GOOD               $data 0x10 4 1
    signal_status P0_PROCHOT_L              $data 0x08 3 1
    signal_status P0_NMI_SYNC_FLOOD_L       $data 0x04 2 1
    signal_status P0_FORCE_SELFREFRESH      $data 0x02 1 0
    signal_status P0_KBRST_L                $data 0x01 0 1
    printf "\n"

    data=$(read_reg 0x12)
    printf 'Reg 0x12 (P0 SIGNALS)=\t 0x%x \n' $data
    echo  "    P0 SIGNALS              Default  Current "
    echo  "------------------------------------------- "

    signal_status P0_SA1                    $data 0x80 7 0
    signal_status P0_SA0                    $data 0x40 6 0
    signal_status P0_BOOT_STRAP_SEL1        $data 0x20 5 0
    signal_status P0_BOOT_STRAP_SEL0        $data 0x10 4 0
    signal_status P0_CLK_STRAP_SEL1         $data 0x08 3 0
    signal_status P0_CLK_STRAP_SEL0         $data 0x04 2 1
    signal_status P0_WAFL_STRAP_SEL         $data 0x02 1 0
    signal_status P0_IMAGE_STRAP_SEL        $data 0x01 0 0
    printf "\n"

    data=$(read_reg 0x13)
    printf 'Reg 0x13 (P0 SIGNALS)=\t 0x%x \n' $data
    echo  "    P0 SIGNALS              Default  Current "
    echo  "------------------------------------------- "

    signal_status P0_ALERT_STRAP_SEL                $data 0x80 7 0
    signal_status P0_BOOT_STRAP_SEL0_AGPIO385       $data 0x40 6 0
    signal_status RSVD                              $data 0x20 5 0
    signal_status RSVD                              $data 0x10 4 0
    signal_status RSVD                              $data 0x08 3 0
    signal_status RSVD                              $data 0x04 2 0
    signal_status RSVD                              $data 0x02 1 0
    signal_status RSVD                              $data 0x01 0 0
    printf "\n"

    data=$(read_reg 0x14)
    printf 'Reg 0x14 (Reserved Section)=\t 0x%x \n' $data
    echo  "    Reserved Section         Default  Current "
    echo  "------------------------------------------- "

    signal_status RSVD                   $data 0x80 7 0
    signal_status RSVD                   $data 0x40 6 0
    signal_status RSVD                   $data 0x20 5 0
    signal_status RSVD                   $data 0x10 4 0
    signal_status RSVD                   $data 0x08 3 0
    signal_status RSVD                   $data 0x04 2 0
    signal_status RSVD                   $data 0x02 1 0
    signal_status RSVD                   $data 0x01 0 0
    printf "\n"

    data=$(read_reg 0x15)
    printf 'Reg 0x15 (P1 SIGNALS)=\t 0x%x \n' $data
    echo  "    P1 Signals           Default  Current "
    echo  "------------------------------------------- "

    signal_status P1_THERMTRIP_L            $data 0x80 7 1
    signal_status P1_SLP_S5_L               $data 0x40 6 1
    signal_status P1_SLP_S3_L               $data 0x20 5 1
    signal_status P1_PRSNT_L                $data 0x10 4 1
    signal_status P1_RESET_L                $data 0x08 3 1
    signal_status P1_PWRGD_OUT              $data 0x04 2 1
    signal_status P1_PWROK                  $data 0x02 1 0
    signal_status P1_SMERR_L                $data 0x01 0 1
    printf "\n"

    data=$(read_reg 0x16)
    printf 'Reg 0x16 (P1 SIGNALS)=\t 0x%x \n' $data
    echo  "   P1 Signals            Default  Current "
    echo  "------------------------------------------- "

    signal_status P1_PWR_BTN_L             $data 0x80 7 1
    signal_status P1_SYS_RESET_L           $data 0x40 6 0
    signal_status P1_RSMRST_L              $data 0x20 5 0
    signal_status P1_PWR_GOOD              $data 0x10 4 0
    signal_status P1_PROCHOT_L             $data 0x08 3 0
    signal_status P1_NMI_SYNC_FLOOD_L      $data 0x04 2 1
    signal_status P1_FORCE_SELFREFRESH     $data 0x02 1 0
    signal_status P1_KBRST_L               $data 0x01 0 0
    printf "\n"

    data=$(read_reg 0x17)
    printf 'Reg 0x17 (P1 SIGNALS)=\t 0x%x \n' $data
    echo  "    P1 Signals           Default  Current "
    echo  "------------------------------------------- "

    signal_status P1_SA1                    $data 0x80 7 1
    signal_status P1_SA0                    $data 0x40 6 0
    signal_status P1_BOOT_STRAP_SEL1        $data 0x20 5 0
    signal_status P1_BOOT_STRAP_SEL0        $data 0x10 4 0
    signal_status P1_CLK_STRAP_SEL1         $data 0x08 3 0
    signal_status P1_CLK_STRAP_SEL0         $data 0x04 2 1
    signal_status P1_WAFL_STRAP_SEL         $data 0x02 1 0
    signal_status P1_IMAGE_STRAP_SEL        $data 0x01 0 0
    printf "\n"

    data=$(read_reg 0x18)
    printf 'Reg 0x18 (P1 Signals )=\t 0x%x \n' $data
    echo  "     P1 Signals            Default  Current "
    echo  "------------------------------------------- "

    signal_status P1_ALERT_STRAP_SEL            $data 0x80 7 0
    signal_status P1_BOOT_STRAP_SEL0_AGPIO385   $data 0x40 6 0
    signal_status RSVD                          $data 0x20 5 0
    signal_status RSVD                          $data 0x10 4 0
    signal_status RSVD                          $data 0x08 3 0
    signal_status RSVD                          $data 0x04 2 0
    signal_status RSVD                          $data 0x02 1 0
    signal_status RSVD                          $data 0x01 0 0
    printf "\n"

    data=$(read_reg 0x19)
    printf 'Reg 0x19 (Reserved Section)=\t 0x%x \n' $data
    echo  "    Reserved Section          Default  Current "
    echo  "------------------------------------------- "

    signal_status RSVD                  $data 0x80 7 0
    signal_status RSVD                  $data 0x40 6 0
    signal_status RSVD                  $data 0x20 5 0
    signal_status RSVD                  $data 0x10 4 0
    signal_status RSVD                  $data 0x08 3 0
    signal_status RSVD                  $data 0x04 2 0
    signal_status RSVD                  $data 0x02 1 0
    signal_status RSVD                  $data 0x01 0 0
    printf "\n"
}

# main
amd-plat-info get_board_info name
echo "Rev: "
amd-plat-info get_board_info rev
echo "FPGA Ver: "
amd-plat-info get_hpm_fpga_ver
echo " "
echo "Register Dumps:  "
all_register_dump
