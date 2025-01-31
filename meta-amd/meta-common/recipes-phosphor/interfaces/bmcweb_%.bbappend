EXTRA_OEMESON:append = " \
    -Dhttp-body-limit=128 \
    -Dredfish-dbus-log=enabled \
    "
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-bmcweb-changes-to-support-vrbundle-update.patch \
            file://0002-fix-redfish-lib-call-to-clear-cmos.patch \
            file://0003-clear-uboot-on-bmc-factory-reset.patch \
            file://uboot_defenv \
           "

do_install:append() {
  install -d ${D}/${sysconfdir}
  install -m 0644 ${S}/../uboot_defenv ${D}/${sysconfdir}/
}
