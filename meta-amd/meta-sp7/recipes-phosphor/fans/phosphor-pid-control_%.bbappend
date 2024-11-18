FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

inherit obmc-phosphor-systemd

SYSTEMD_SERVICE:${PN} = "phosphor-pid-control.service"

EXTRA_OECONF:append = " --enable-configure-dbus=yes"

SRC_URI += " \
             file://morocco-stepwise-config.json \
             file://set-platform-json-config.sh \
             file://phosphor-pid-control.service \
           "

FILES:${PN}:append = " ${datadir}/swampd/morocco-stepwise-config.json \
                       ${bindir}/set-platform-json-config.sh \
                     "

RDEPENDS:${PN}:append = "bash"

do_configure:append() {
  cp  ${WORKDIR}/phosphor-pid-control.service ${S}/service_files
}

do_install:append() {
    install -d ${D}/${bindir}
    install -m 0755 ${WORKDIR}/set-platform-json-config.sh ${D}/${bindir}
    install -d ${D}${datadir}/swampd
    install -m 0644 -D ${WORKDIR}/morocco-stepwise-config.json \
        ${D}${datadir}/swampd/morocco-stepwise-config.json
}
