SUMMARY = "AMD EPYC System Management Interface Library"
DESCRIPTION = "AMD EPYC System Management Interface Library for user space APML implementation"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://License.txt;md5=a53f186511a093774907861d15f7014c"

FILESEXTRAPATHS:prepend := "${THISDIR}:"

# TODO Remove modules dependency once driver support
#      available in kernel  
DEPENDS:append  = "apml-modules"
RRECOMMENDS:${PN}:append = "apml-modules"

RDEPENDS:${PN}:append = "bash i2c-tools"

SRC_URI = "git://github.com/amd/esmi_oob_library;protocol=https;branch=master"
SRCREV = "48d0cd98051ef7c8e97b958ce061b89dd6bbd0c8"

S = "${WORKDIR}/git"

SRC_URI += "file://set-apml.sh"

inherit cmake

do_install:append () {
        install -d ${D}${bindir}
        install -m 0755 ${WORKDIR}/set-apml.sh ${D}${bindir}
}
