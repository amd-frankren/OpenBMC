FILESEXTRAPATHS:prepend := "${THISDIR}/linux-aspeed:"
LINUX_VERSION:amd ?= "6.6.36"

KSRC:amd ?= "git://git@github.com:/AMDESE/linux-aspeed.git;branch=integ_sp7;protocol=ssh"
SRCREV = "5632f501c6655d3b9fb66b34371efec87ab4b397"

SRC_URI:append = "file://amd-bmc-baseline.cfg \
                  "
