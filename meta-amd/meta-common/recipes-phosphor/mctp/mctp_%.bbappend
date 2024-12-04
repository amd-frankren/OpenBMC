FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

inherit obmc-phosphor-systemd

RDEPENDS:${PN} += "libsystemd bash"
DEPENDS += " systemd"

S="${WORKDIR}"

SRC_URI += "file://amd-mctp-config \
            file://amd-mctp-config.service \
           "

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE:${PN} += "amd-mctp-config.service"

do_install:append() {
    install -d ${D}/${sbindir}
    install -m 0755 ${WORKDIR}/amd-mctp-config ${D}/${sbindir}/
}
