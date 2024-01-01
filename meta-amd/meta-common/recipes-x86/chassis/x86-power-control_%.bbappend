FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}/${MACHINE}:"

SRC_URI:append = " file://power-config-host0.json"

do_install:append() {
        install -m 0755 -d ${D}/${datadir}/${PN}
        install -m 0644 -D ${WORKDIR}/power-config-host0.json \
                  ${D}/${datadir}/${PN}/
}
