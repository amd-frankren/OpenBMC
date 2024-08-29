FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

S = "${WORKDIR}/git"

SRC_URI += "file://0001-Support-HPM-FPGA-firmware-update.patch \
            file://0002-webui-support-for-Retimer-bundle-firmware-update.patch \
           "
