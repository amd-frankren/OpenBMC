SUMMARY = "AMD Power Control GPIO setting service"
DESCRIPTION = "Script for setting Power Control GPIO"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

LICENSE = "CLOSED"

inherit obmc-phosphor-systemd

RDEPENDS:${PN} += "libsystemd bash"
DEPENDS += " systemd"

S="${WORKDIR}"

SRC_URI += " \
        file://power-ctl-gpio.service \
        "

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE:${PN} += "power-ctl-gpio.service"

