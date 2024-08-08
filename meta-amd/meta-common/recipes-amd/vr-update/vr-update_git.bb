SUMMARY = "VR Update application"
DESCRIPTION = "Used for performing VR updates through BMC"

FILESEXTRAPATHS:prepend := "${THISDIR}:"

LICENSE = "CLOSED"

inherit cmake pkgconfig systemd

DEPENDS += " \
    i2c-tools \
    phosphor-dbus-interfaces \
    phosphor-logging \
    sdbusplus \
    boost \
    nlohmann-json \
    "

S = "${WORKDIR}/git"

INSANE_SKIP_${PN} += "ldflags"
RDEPENDS:${PN} += "bash"

do_install() {
        install -d ${D}${sbindir}
        install -m 0755 vr-update ${D}${sbindir}
        install -m 0755 ${S}/config/vr-config-info ${D}/${sbindir}/
}
