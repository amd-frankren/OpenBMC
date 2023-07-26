FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRCREV = "44a8c618c1215e0faac0f335f0afd56ed4240e76"

SRC_URI += "file://amd-ast2600-u-boot.cfg \
            file://0001-meta-common-recipes-bsp-u-boot-Override-u-boot-recip.patch \
            file://0002-Added-spi-nor-changes-to-support-BMC-Image-boot.patch \
            "
