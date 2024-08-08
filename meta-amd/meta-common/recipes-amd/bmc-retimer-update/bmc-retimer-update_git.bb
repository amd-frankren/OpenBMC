SUMMARY = "Retimer Update application"
DESCRIPTION = "Used for performing Retimer updates through BMC"
LICENSE = "CLOSED"

FILESEXTRAPATHS:prepend := "${THISDIR}:"

SRC_URI="git://git@github.com:/AMDESE/bmc-retimer-update.git;branch=integ_sp7;protocol=ssh"
SRCREV = "72f6d2f539e4d70953da9455106d6797cfc197e6"
S = "${WORKDIR}/git"

DEPENDS += " \
    i2c-tools \
    phosphor-dbus-interfaces \
    phosphor-logging \
    sdbusplus \
    boost \
    nlohmann-json \
    libaries-retimer \
    "

RDEPENDS:${PN} += "bash"

inherit meson pkgconfig systemd

do_install:append() {
    install -d ${D}${sysconfdir}/bmc-retimer-update
}
