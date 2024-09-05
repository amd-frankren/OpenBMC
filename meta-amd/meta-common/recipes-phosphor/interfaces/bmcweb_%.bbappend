EXTRA_OEMESON:append = " \
    -Dhttp-body-limit=128 \
    -Dredfish-dbus-log=enabled \
    "
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-bmcweb-changes-to-support-vrbundle-update.patch"

