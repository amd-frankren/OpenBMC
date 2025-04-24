EXTRA_OEMESON:append = " \
    -Dhttp-body-limit=128 \
    -Dredfish-dbus-log=enabled \
    "
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI = "git://github.com/AMDESE/bmcweb;branch=integ_sp7;protocol=https"
SRCREV = "ccf23ad3bb4f740f5b388e46eef8e16f95193c8d"

SRC_URI += "file://uboot_defenv"

do_install:append() {
  install -d ${D}/${sysconfdir}
  install -m 0644 ${WORKDIR}/uboot_defenv ${D}/${sysconfdir}/
}
