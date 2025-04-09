FILESEXTRAPATHS:prepend := "${THISDIR}/linux-aspeed:"
LINUX_VERSION:amd ?= "6.6.36"

KSRC:amd ?= "git://git@github.com:/AMDESE/linux-aspeed.git;branch=dev-a1;protocol=ssh"
SRCREV = "9ad03cd1d52653e392b5029cd5fa21c3af86578e"
SRC_URI:append = "file://amd-bmc-baseline.cfg \
                  "
