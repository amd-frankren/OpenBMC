FILESEXTRAPATHS:prepend := "${THISDIR}/linux-aspeed:"
LINUX_VERSION:amd ?= "6.6.36"

KSRC:amd ?= "git://git@github.com:/AMDESE/linux-aspeed.git;branch=integ_sp7;protocol=ssh"
SRCREV = "7f652807c41aa50d04b86542d1739efdddb45b07"

SRC_URI:append = "file://amd-bmc-baseline.cfg \
                  "
