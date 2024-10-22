FILESEXTRAPATHS:prepend := "${THISDIR}/linux-aspeed:"
LINUX_VERSION:amd ?= "6.6.36"

KSRC:amd ?= "git://git@github.com:/AMDESE/linux-aspeed.git;branch=integ_sp7;protocol=ssh"
SRCREV = "4a017b473f854300d6774ed408db2f3f1142e0c7"

SRC_URI:append = "file://amd-bmc-baseline.cfg \
                  "
