i3chub-init_git.bbSUMMARY = "I3CHub initialization script"
DESCRIPTION = "To initialize Renesas I3C hub"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

FILESEXTRAPATHS:prepend := "${THISDIR}:"

RDEPENDS:${PN}:append = " bash"

SRC_URI += " file://i3chub-init"

do_install() {
  install -d ${D}/${sbindir}
  install -m 0755 ${WORKDIR}/i3chub-init ${D}/${sbindir}/
}
