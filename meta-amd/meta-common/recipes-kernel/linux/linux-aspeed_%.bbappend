FILESEXTRAPATHS:prepend := "${THISDIR}/linux-aspeed:"
LINUX_VERSION:amd ?= "6.6.36"

KSRC:amd ?= "git://git@github.com:/AMDESE/linux-aspeed.git;branch=integ_sp7;protocol=ssh"
SRCREV = "c637f63c5ca5cf83d69c7e14bfa02fd1635355a3"

SRC_URI:append = "file://amd-bmc-baseline.cfg \
                  "
