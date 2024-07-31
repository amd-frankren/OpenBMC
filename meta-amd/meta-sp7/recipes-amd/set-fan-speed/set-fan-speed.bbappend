FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " file://set-fan-speed.sh"

do_install() {
  install -d ${D}/${sbindir}
  install -m 0755 ${S}/set-fan-speed.sh ${D}/${sbindir}/
}
