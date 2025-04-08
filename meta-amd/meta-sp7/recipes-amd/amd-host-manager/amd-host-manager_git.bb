SUMMARY = "Additional functions for managing host state transitions"
DESCRIPTION = "This service provides enhanced functionalities for managing \
               host state transitions, including handling BMC reboots during \
               system runtime and monitoring host state changes to initiate \
               necessary actions."

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

LICENSE = "CLOSED"

RDEPENDS:${PN} += "bash"

S="${WORKDIR}"

SRC_URI += " \
        file://amd-utils \
        "

do_install() {
    install -d ${D}/${datadir}/amd-host-manager
    install -m 0755 ${S}/amd-utils ${D}/${datadir}/amd-host-manager/

}
