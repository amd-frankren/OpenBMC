FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

PACKAGECONFIG[flash_hpm_fpga] = "-Dhpm-fpga-upgrade=enabled, -Dhpm-fpga-upgrade=disabled "
PACKAGECONFIG[flash_retimer_bundle] = "-Dretimer-bundle-upgrade=enabled, -Dretimer-bundle-upgrade=disabled"

SYSTEMD_SERVICE:${PN}-updater += "${@bb.utils.contains('PACKAGECONFIG', 'flash_retimer_bundle', 'obmc-flash-retimer-bundle@.service', '', d)}"
SYSTEMD_SERVICE:${PN}-updater += "${@bb.utils.contains('PACKAGECONFIG', 'flash_hpm_fpga', 'obmc-flash-hpm-fpga@.service', '', d)}"

PACKAGECONFIG:append = " flash_bios flash_hpm_fpga flash_retimer_bundle"
RDEPENDS:${PN} += "bash"

SRC_URI += "file://bios-update.sh \
            file://hpm-fpga-update.sh \
            file://0001-Add-support-for-HPM-FPGA-firmware-update.patch \
            file://0002-meta-amd-flash-Save-version-info-to-persistent-stora.patch \
            file://0003-phosphor-software-manager-Enable-Retimer-framework.patch \
           "

do_install:append() {
    install -d ${D}/${sbindir}
    install -m 0755 ${WORKDIR}/bios-update.sh ${D}/${sbindir}/
    install -m 0755 ${WORKDIR}/hpm-fpga-update.sh ${D}/${sbindir}/
}
