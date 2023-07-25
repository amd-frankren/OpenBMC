SUMMARY = "OpenBMC for AMD - Applications"
PR = "r1"

inherit packagegroup

PROVIDES = "${PACKAGES}"
PACKAGES = " \
        ${PN}-chassis \
        ${PN}-fans \
        ${PN}-flash \
        ${PN}-system \
        "

PROVIDES += "virtual/obmc-chassis-mgmt"
PROVIDES += "virtual/obmc-flash-mgmt"
PROVIDES += "virtual/obmc-fan-mgmt"
PROVIDES += "virtual/obmc-system-mgmt"

RPROVIDES:${PN}-chassis += "virtual-obmc-chassis-mgmt"
RPROVIDES:${PN}-fans += "virtual-obmc-fan-mgmt"
RPROVIDES:${PN}-flash += "virtual-obmc-flash-mgmt"
RPROVIDES:${PN}-system += "virtual-obmc-system-mgmt"

SUMMARY_${PN}-chassis = "AMD Chassis"
RDEPENDS_${PN}-chassis = " \
        x86-power-control \
        phosphor-sel-logger \
        phosphor-logging \
        "

SUMMARY_${PN}-fans = "AMD Fans"
RDEPENDS_${PN}-fans = "phosphor-pid-control"

SUMMARY_${PN}-flash = "AMD Flash"
RDEPENDS_${PN}-flash = " \
        phosphor-software-manager \
        "

SUMMARY_${PN}-system = "AMD System"
RDEPENDS_${PN}-system = " \
        bmcweb \
        ipmitool \
        phosphor-hostlogger \
        phosphor-pid-control \
        phosphor-host-postd \
        phosphor-post-code-manager \
        phosphor-misc-usb-ctrl \
        usb-network \
        webui-vue \
        "
