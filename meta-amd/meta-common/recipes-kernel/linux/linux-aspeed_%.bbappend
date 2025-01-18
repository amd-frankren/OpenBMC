FILESEXTRAPATHS:prepend := "${THISDIR}/linux-aspeed:"
LINUX_VERSION:amd ?= "6.6.36"

KSRC:amd ?= "git://git@github.com:/AMDESE/linux-aspeed.git;branch=dev-a1;protocol=ssh"
SRCREV = "a8d4aec2e938dc521fb21aa499aadc6c974b9280"

SRC_URI:append = "file://amd-bmc-baseline.cfg \
                  "
