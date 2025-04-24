FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}/${MACHINE}:"

SRC_URI:append = " file://power-config-host0.json"
SRC_URI:append:amd-configmgr = " \
    file://power-config-host1.json \
    file://power-config-host2.json \
    "

do_install:append() {
        install -m 0755 -d ${D}/${datadir}/${PN}
        install -m 0644 -D ${WORKDIR}/*.json \
                  ${D}/${datadir}/${PN}
}
