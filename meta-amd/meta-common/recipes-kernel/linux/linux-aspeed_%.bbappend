FILESEXTRAPATHS:prepend := "${THISDIR}/linux-aspeed:"
LINUX_VERSION:amd ?= "6.6.36"

KSRC:amd ?= "git://git@github.com:/AMDESE/linux-aspeed.git;branch=dev-a1;protocol=ssh"
SRCREV = "50e496462d70f09f47cab7507f0199da3629661f"
SRC_URI:append = "file://amd-bmc-baseline.cfg \
                  "
