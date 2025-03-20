SUMMARY = "AMD FPGA Diagnostic Scripts"
DESCRIPTION = "Scripts for dumping HPM FPGA data"

LICENSE = "CLOSED"

FILESEXTRAPATHS:prepend := "${THISDIR}:"

RDEPENDS:${PN}:append = " bash"

SRC_URI += " \
           file://hpm-fpga-dump.sh \
           file://sp7-fpga-dump.sh \
           file://amd-plat-info \
           "


do_install() {
  install -d ${D}/${sbindir}
  install -m 0755 ${WORKDIR}/*.sh ${D}/${sbindir}/
  install -m 0755 ${WORKDIR}/amd-plat-info ${D}/${sbindir}/
}
