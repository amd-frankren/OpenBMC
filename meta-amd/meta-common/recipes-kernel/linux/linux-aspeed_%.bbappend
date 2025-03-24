FILESEXTRAPATHS:prepend := "${THISDIR}/linux-aspeed:"
LINUX_VERSION:amd ?= "6.6.36"

KSRC:amd ?= "git://git@github.com:/AMDESE/linux-aspeed.git;branch=usb3_vhub_driver_update;protocol=ssh"
SRCREV = "b1e28ac6f02788cf48bf87d215b91ff63dd673d2"

SRC_URI:append = "file://amd-bmc-baseline.cfg \
                  "
