FILESEXTRAPATHS:prepend := "${THISDIR}/linux-aspeed:"
LINUX_VERSION:amd ?= "6.6.36"

KSRC:amd ?= "git://git@github.com:/AMDESE/linux-aspeed.git;branch=integ_sp7;protocol=ssh"
SRCREV = "c415b2a009890ed0535e99dac6224eb975655c9e"

SRC_URI:append = "file://amd-bmc-baseline.cfg \
                  "
