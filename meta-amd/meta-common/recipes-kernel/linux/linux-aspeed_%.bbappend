FILESEXTRAPATHS:prepend := "${THISDIR}/linux-aspeed:"
LINUX_VERSION:amd ?= "6.6.36"

KSRC:amd ?= "git://git@github.com:/AMDESE/linux-aspeed.git;branch=dev-a1;protocol=ssh"
SRCREV = "d76093fe54145199a77a335b3f847392479ec922"
SRC_URI:append = "file://amd-bmc-baseline.cfg \
                  "
