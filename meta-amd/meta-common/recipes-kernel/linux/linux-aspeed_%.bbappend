FILESEXTRAPATHS:prepend := "${THISDIR}/linux-aspeed:"
LINUX_VERSION:amd ?= "6.6.36"

KSRC:amd ?= "git://git@github.com:/AMDESE/linux-aspeed.git;branch=integ_sp7;protocol=ssh"
SRCREV = "187687eac7fa208fb2926acacb2fdcd432a40c89"

SRC_URI:append = "file://amd-bmc-baseline.cfg \
                  "
