FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " file://power-ctl-gpio.sh"

do_install() {
  install -d ${D}/${sbindir}
  install -m 0755 ${S}/power-ctl-gpio.sh ${D}/${sbindir}/
}
