FILESEXTRAPATHS:prepend := "${THISDIR}/linux-aspeed:"
LINUX_VERSION:amd ?= "6.6.36"

KSRC:amd ?= "git://git@github.com:/AMDESE/linux-aspeed.git;branch=integ_sp7;protocol=ssh"
SRCREV = "a67a9c91b552c5d3b201b532cca68fdbe65d2987"

SRC_URI:append = "file://amd-bmc-baseline.cfg \
                  "
