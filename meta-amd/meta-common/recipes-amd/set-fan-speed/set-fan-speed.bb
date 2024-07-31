SUMMARY = "AMD Fan speed setting service"
DESCRIPTION = "Script for setting Fan speeds at boot time"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

LICENSE = "CLOSED"

inherit obmc-phosphor-systemd

RDEPENDS:${PN} += "libsystemd bash"
DEPENDS += " systemd"

S="${WORKDIR}"

SRC_URI += " \
        file://set-fan-speed.service \
        "

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE:${PN} += "set-fan-speed.service"

