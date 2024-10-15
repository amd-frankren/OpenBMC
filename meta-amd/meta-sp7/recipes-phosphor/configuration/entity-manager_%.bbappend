FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

inherit obmc-phosphor-systemd

SRC_URI += "\
    file://blacklist.json \
    file://congo.json \
    "

RDEPENDS:${PN}:append = " bash"

do_install:append() {
    install -m 0644 -D ${WORKDIR}/blacklist.json ${D}${datadir}/${PN}/blacklist.json
    install -m 0644 -D ${WORKDIR}/congo.json ${D}${datadir}/${PN}/configurations/congo.json
}
