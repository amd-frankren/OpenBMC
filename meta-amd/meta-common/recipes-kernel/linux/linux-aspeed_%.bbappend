FILESEXTRAPATHS:prepend := "${THISDIR}/linux-aspeed:"
LINUX_VERSION:amd ?= "6.6.36"

KSRC:amd ?= "git://git@github.com:/AMDESE/linux-aspeed.git;branch=dev-a1;protocol=ssh"
SRCREV = "debbff0782345052478e88082bc2b90639b9d685"
SRC_URI:append = "file://amd-bmc-baseline.cfg \
                  "
