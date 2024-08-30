FILESEXTRAPATHS:prepend := "${THISDIR}/linux-aspeed:"
LINUX_VERSION:amd ?= "6.6.36"

KSRC:amd ?= "git://git@github.com:/AMDESE/linux-aspeed.git;branch=integ_sp7;protocol=ssh"
SRCREV = "6a421f95d698dfbaba0202125e4ee8272aeccde2"

SRC_URI:append = "file://amd-bmc-baseline.cfg \
                  "
