FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

PACKAGECONFIG:append = " flash_bios"
RDEPENDS:${PN} += "bash"

SRC_URI += "file://bios-update.sh \
            "

do_install:append() {
    install -d ${D}/${sbindir}
    install -m 0755 ${WORKDIR}/bios-update.sh ${D}/${sbindir}/
}
