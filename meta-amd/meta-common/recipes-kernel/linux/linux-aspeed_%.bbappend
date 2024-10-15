FILESEXTRAPATHS:prepend := "${THISDIR}/linux-aspeed:"
LINUX_VERSION:amd ?= "6.6.36"

KSRC:amd ?= "git://git@github.com:/AMDESE/linux-aspeed.git;branch=integ_sp7;protocol=ssh"
SRCREV = "0befccc3b54bbc64bf44691549e597690d3e36e4"

SRC_URI:append = "file://amd-bmc-baseline.cfg \
                  "
