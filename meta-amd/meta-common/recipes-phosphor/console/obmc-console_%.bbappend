FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:remove = "file://${BPN}.conf"

SRC_URI:append = "\
        file://server.ttyVUART0.conf \
        file://client.2200.conf \
        file://client.2201.conf \
"

do_install:append() {
        # Remove upstream-provided configuration
        rm -rf ${D}${sysconfdir}/${BPN}

        # Install the server configuration
        install -m 0755 -d ${D}${sysconfdir}/${BPN}
        install -m 0644 ${WORKDIR}/*.conf ${D}${sysconfdir}/${BPN}/

        # install dropbear environment file from upstream
        if ${@bb.utils.contains('PACKAGECONFIG', 'ssh', 'true', 'false', d)} ; then
                install -m 0644 ${WORKDIR}/dropbear.env ${D}${sysconfdir}/${BPN}/
        fi
}

PACKAGECONFIG:append = " concurrent-servers"

EXTRA_OECONF:append = " --enable-concurrent-servers"

SYSTEMD_SERVICE:${PN}:remove = "obmc-console-ssh.socket"

SYSTEMD_SERVICE:${PN}:append = " obmc-console-ssh@2200.service \
        obmc-console-ssh@2201.service \
"

REGISTERED_SERVICES:${PN}:append = " obmc_console_host0:tcp:2200: \
        obmc_console_host1:tcp:2201: \
"

FILES_${PN}:remove = "${systemd_system_unitdir}/obmc-console-ssh@.service.d/use-socket.conf"
