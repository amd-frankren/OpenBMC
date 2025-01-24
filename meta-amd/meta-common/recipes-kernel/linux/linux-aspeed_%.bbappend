FILESEXTRAPATHS:prepend := "${THISDIR}/linux-aspeed:"
LINUX_VERSION:amd ?= "6.6.36"

KSRC:amd ?= "git://git@github.com:/AMDESE/linux-aspeed.git;branch=dev-a1;protocol=ssh"
SRCREV = "2e4df60f6b115b4660f5e1c5985bf7eccc2d370b"

SRC_URI:append = "file://amd-bmc-baseline.cfg \
                  "
