FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

S = "${WORKDIR}/git"

SRC_URI += "file://0001-Support-HPM-FPGA-firmware-update.patch \
       "
