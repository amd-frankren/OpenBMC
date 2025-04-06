SUMMARY = "Additional functions for managing host state transitions"
DESCRIPTION = "This service provides enhanced functionalities for managing \
               host state transitions, including handling BMC reboots during \
               system runtime and monitoring host state changes to initiate \
               necessary actions."

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

LICENSE = "CLOSED"

inherit obmc-phosphor-systemd

RDEPENDS:${PN} += "libsystemd bash"
DEPENDS += " systemd"

S="${WORKDIR}"

SRC_URI += " \
        file://s0-state-mgr \
        file://s5-state-mgr \
        file://amd-utils \
        file://amd-host-mgr \
        file://amd-host-mgr.service \
        "

do_install() {
    install -d ${D}/${sbindir}
    install -m 0755 ${S}/s0-state-mgr ${D}/${sbindir}/
    install -m 0755 ${S}/s5-state-mgr ${D}/${sbindir}/
    install -m 0755 ${S}/amd-host-mgr ${D}/${sbindir}/
    install -d ${D}/${datadir}/amd-host-manager
    install -m 0755 ${S}/amd-utils ${D}/${datadir}/amd-host-manager/
}

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE:${PN} += "amd-host-mgr.service"
