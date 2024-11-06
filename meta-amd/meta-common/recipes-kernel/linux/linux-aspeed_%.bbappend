FILESEXTRAPATHS:prepend := "${THISDIR}/linux-aspeed:"
LINUX_VERSION:amd ?= "6.6.36"

KSRC:amd ?= "git://git@github.com:/AMDESE/linux-aspeed.git;branch=integ_sp7;protocol=ssh"
SRCREV = "2cc93de13083636b41028642b49cd75a672fa6f9"

SRC_URI:append = "file://amd-bmc-baseline.cfg \
                  "
