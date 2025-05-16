SUMMARY = "AMD Platform Initialization service"
DESCRIPTION = "Script for setting platform init values"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

LICENSE = "CLOSED"

inherit obmc-phosphor-systemd

RDEPENDS:${PN} += "libsystemd bash"
DEPENDS += " systemd"

S="${WORKDIR}"

SRC_URI += " \
        file://platform-init.service \
        file://platform-init.sh \
        "
do_install() {
  install -d ${D}/${sbindir}
  install -m 0755 ${S}/platform-init.sh ${D}/${sbindir}/
}

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE:${PN} += "platform-init.service"
