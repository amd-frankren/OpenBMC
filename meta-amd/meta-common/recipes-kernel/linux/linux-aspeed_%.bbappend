FILESEXTRAPATHS:prepend := "${THISDIR}/linux-aspeed:"
LINUX_VERSION:amd ?= "6.6.36"

KSRC:amd ?= "git://git@github.com:/AMDESE/linux-aspeed.git;branch=integ_sp7;protocol=ssh"
SRCREV = "589cbdfe3cc22db0a6fb7e0f4328f9f19ef4afbc"

SRC_URI:append = "file://amd-bmc-baseline.cfg \
                  "
