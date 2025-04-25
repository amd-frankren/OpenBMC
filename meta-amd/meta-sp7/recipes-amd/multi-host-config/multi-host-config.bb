SUMMARY = "AMD Multi-Host configuration service"
DESCRIPTION = "Script for setting Multi-Host configuration"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

LICENSE = "CLOSED"

inherit obmc-phosphor-systemd

RDEPENDS:${PN} += "libsystemd bash"
DEPENDS += " systemd"

S="${WORKDIR}"

SRC_URI += " \
        file://multi-host-config.service \
        file://multi-host-config.sh \
        "

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE:${PN} += "multi-host-config.service"

do_install() {
  install -d ${D}/${sbindir}
  install -m 0755 ${S}/multi-host-config.sh ${D}/${sbindir}/
}

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
