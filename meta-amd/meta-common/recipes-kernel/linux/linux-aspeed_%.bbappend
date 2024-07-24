FILESEXTRAPATHS:prepend := "${THISDIR}/linux-aspeed:"
LINUX_VERSION:amd ?= "6.6.36"

KSRC:amd ?= "git://git@github.com:/AMDESE/linux-aspeed.git;branch=integ_sp7;protocol=ssh"
SRCREV = "3f3944032be109c92d2b7eb0259c5ae6d43f6a73"

SRC_URI:append = "file://amd-bmc-baseline.cfg \
                  "
