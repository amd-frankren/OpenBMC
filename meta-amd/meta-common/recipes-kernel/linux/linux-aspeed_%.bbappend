FILESEXTRAPATHS:prepend := "${THISDIR}/linux-aspeed:"
LINUX_VERSION:amd ?= "6.6.36"

KSRC:amd ?= "git://git@github.com:/AMDESE/linux-aspeed.git;branch=integ_sp7;protocol=ssh"
SRCREV = "f0ee13bcc1f4fa8581b513d6b0ea11a488a7902d"

SRC_URI:append = "file://amd-bmc-baseline.cfg \
                  "
