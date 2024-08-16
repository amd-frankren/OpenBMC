SUMMARY = "IPMItool frugen"
DESCRIPTION = "FRU generation tool for AMD SCM and HPM"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

FILESEXTRAPATHS:prepend := "${THISDIR}:"

SRC_URI = "git://github.com/ipmitool/frugen;protocol=https;branch=master"
SRCREV = "679d8dd9ad8511d3d22888a3b568f2eafceeaa11"

SRC_URI += " \
           file://SCM_v1.json \
           file://scm-fru-edit.sh \
           file://0001-Support-for-AMD-Internal-use-area.patch \
           "

inherit pkgconfig cmake
EXTRA_OECMAKE = "JSON_LIB AMD_IA"

DEPENDS:append = " json-c"
RDEPENDS:${PN}:append = " bash i2c-tools json-c"

S = "${WORKDIR}/git"


do_install() {
    install -d ${D}/${sbindir}
    install -m 0755 frugen-static ${D}/${sbindir}/
    cp -r ${WORKDIR}/scm-fru-edit.sh ${D}/${sbindir}/
    install -d ${D}/etc/
    cp -r ${WORKDIR}/SCM_v1.json  ${D}/etc/
}
