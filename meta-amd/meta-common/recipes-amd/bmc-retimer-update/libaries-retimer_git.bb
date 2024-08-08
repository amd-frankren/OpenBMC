SUMMARY = "Aries retimer update"
DESCRIPTION = "Update application to program Aries PCIe retimer firmware"
LICENSE = "CLOSED"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# Include aries sdk as-is with retimer-updater
SRC_URI="git://git@github.com:/AMDESE/bmc-retimer-update.git;branch=integ_sp7;protocol=ssh"
SRCREV = "72f6d2f539e4d70953da9455106d6797cfc197e6"
S="${WORKDIR}/git/libaries"

DEPENDS += "i2c-tools"

inherit meson
