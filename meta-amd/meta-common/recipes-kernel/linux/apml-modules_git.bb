SUMMARY = "APML interface drivers for BMC"
DESCRIPTION = "${SUMMARY}"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

FILESEXTRAPATHS:prepend := "${THISDIR}/linux-aspeed:"

SRC_URI = "git://github.com/amd/apml_modules;protocol=https;branch=master"

SRCREV = "812ed5c1b6d6a883a51b88b5964604190ca22d09"

S = "${WORKDIR}/git"

inherit module

do_install:append() {
    install -d ${D}${includedir}/linux
    install -m 0755 ${S}/amd-apml.h ${D}${includedir}/linux/amd-apml.h
}

# autoload if installed
KERNEL_MODULE_AUTOLOAD += "apml_sbrmi apml_sbtsi"
KERNEL_MODULE_PROBECONF += "apml_sbrmi apml_sbtsi"

PACKAGES += "kernel-module-apml_sbrmi kernel-module-apml_sbtsi"
RRECOMMENDS:${PN} += "kernel-module-apml_sbrmi kernel-module-apml_sbtsi"

EXTRA_OEMAKE += " \
     KDIR=${STAGING_KERNEL_DIR} \
"
