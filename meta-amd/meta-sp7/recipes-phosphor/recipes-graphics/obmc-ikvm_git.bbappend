FILESEXTRAPATHS:append := "${THISDIR}/${PN}:"
SRC_URI += " file://start-ipkvm.service "

FILES:${PN} += " \
    ${systemd_system_unitdir}/start-ipkvm.service \
"

do_install:append () {
    install -D -m 0644 ${WORKDIR}/start-ipkvm.service ${D}${systemd_system_unitdir}
}
