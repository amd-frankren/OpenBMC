FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
           file://set-fan-speed.sh \
           file://manage-fan-speed.sh \
           "

do_install() {
  install -d ${D}/${sbindir}
  install -m 0755 ${S}/*.sh ${D}/${sbindir}/
}
