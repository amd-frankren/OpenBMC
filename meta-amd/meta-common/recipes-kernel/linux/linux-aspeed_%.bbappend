FILESEXTRAPATHS:prepend := "${THISDIR}/linux-aspeed:"
LINUX_VERSION:amd ?= "6.6.36"

KSRC:amd ?= "git://git@github.com:/AMDESE/linux-aspeed.git;branch=integ_sp7;protocol=ssh"
SRCREV = "d46525b9d795d9856a8207a277fc02f8ebb24a5e"

SRC_URI:append = "file://amd-bmc-baseline.cfg \
                  "
