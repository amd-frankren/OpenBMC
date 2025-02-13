FILESEXTRAPATHS:prepend := "${THISDIR}/linux-aspeed:"
LINUX_VERSION:amd ?= "6.6.36"

KSRC:amd ?= "git://git@github.com:/AMDESE/linux-aspeed.git;branch=integ_sp7;protocol=ssh"
SRCREV = "7dc656b66fdb2f8742ad2fc53300fe2fd057b453"

SRC_URI:append = "file://amd-bmc-baseline.cfg \
                  "
