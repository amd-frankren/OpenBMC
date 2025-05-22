FILESEXTRAPATHS:prepend := "${THISDIR}/linux-aspeed:"
LINUX_VERSION:amd ?= "6.6.36"

KSRC:amd ?= "git://git@github.com:/AMDESE/linux-aspeed.git;branch=dev-a1;protocol=ssh"
SRCREV = "604911ab41205da6d08ec793f77f23cddf6ba865"
SRC_URI:append = "file://amd-bmc-baseline.cfg \
                  "
