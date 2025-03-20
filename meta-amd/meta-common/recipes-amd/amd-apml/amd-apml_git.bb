SUMMARY = "AMD EPYC System Management Interface Library"
DESCRIPTION = "AMD EPYC System Management Interface Library for user space APML implementation"

LICENSE = "CLOSED"

FILESEXTRAPATHS:prepend := "${THISDIR}:"

DEPENDS += "virtual/kernel"

RDEPENDS:${PN}:append = "bash i2c-tools i3c-tools"

SRC_URI += "git://git@github.com/amd/apml_library.git;protocol=ssh;tag=apml-3.8.4"
unset SRCREV

S = "${WORKDIR}/git"

SRC_URI += "file://set-apml.sh"

inherit cmake

EXTRA_OEMAKE += " \
    KDIR=${STAGING_KERNEL_DIR} \
"

do_configure:prepend() {
    install -d ${STAGING_DIR_HOST}${includedir}/linux
    install -m 0755 ${STAGING_KERNEL_DIR}/include/uapi/linux/amd-apml.h ${STAGING_DIR_HOST}${includedir}/linux/amd-apml.h
}

do_install:append() {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/set-apml.sh ${D}${bindir}

    install -d ${D}${includedir}
    install -m 0644 ${S}/include/esmi_oob/* ${D}${includedir}/
}

FILES_${PN} += "${includedir}/linux/amd-apml.h"
