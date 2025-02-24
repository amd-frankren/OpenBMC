FILESEXTRAPATHS:prepend := "${THISDIR}/linux-aspeed:"
LINUX_VERSION:amd ?= "6.6.36"

KSRC:amd ?= "git://git@github.com:/AMDESE/linux-aspeed.git;branch=dev-a1;protocol=ssh"
SRCREV = "a0c1f6f455c700921557e805f504b464cabbc626"

SRC_URI:append = "file://amd-bmc-baseline.cfg \
                  "
