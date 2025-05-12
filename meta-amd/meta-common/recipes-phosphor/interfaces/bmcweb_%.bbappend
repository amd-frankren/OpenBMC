EXTRA_OEMESON:append = " \
    -Dhttp-body-limit=128 \
    -Dredfish-dbus-log=enabled \
    "
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI = "git://github.com/AMDESE/bmcweb;branch=integ_sp7;protocol=https"
SRCREV = "bd4027d5cb21144c5412639756a50150d2854f40"

SRC_URI += "file://uboot_defenv"

do_install:append() {
  install -d ${D}/${sysconfdir}
  install -m 0644 ${WORKDIR}/uboot_defenv ${D}/${sysconfdir}/
}
