FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://bios-update.sh \
            file://hpm-fpga-update.sh \
           "
