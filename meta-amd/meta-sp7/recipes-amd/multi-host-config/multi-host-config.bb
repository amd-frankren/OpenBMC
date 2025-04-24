SUMMARY = "AMD Multi-Host configuration service"
DESCRIPTION = "Script for setting Multi-Host configuration"

LICENSE = "CLOSED"

FILESEXTRAPATHS:prepend := "${THISDIR}:"

inherit obmc-phosphor-systemd

RDEPENDS:${PN} += "libsystemd bash"
DEPENDS += " systemd"

S="${WORKDIR}/git"

SRC_URI += " \
        file://multi-host-config \
        "



do_install:append() {
  install -d ${D}/${sbindir}
    install -m 0755 ${WORKDIR}/multi-host-config ${D}/${sbindir}/multi-host-config
}

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE:${PN} += "multi-host-config.service"

