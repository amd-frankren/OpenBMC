FILESEXTRAPATHS:prepend := "${THISDIR}/linux-aspeed:"
LINUX_VERSION:amd ?= "6.6.36"

KSRC:amd ?= "git://git@github.com:/AMDESE/linux-aspeed.git;branch=integ_sp7;protocol=ssh"
SRCREV = "20b483ea5568e55de41dca8eeb0b1f9d2f8b1037"

SRC_URI:append = "file://amd-bmc-baseline.cfg \
                  "
