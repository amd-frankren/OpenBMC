SUMMARY = "OpenBMC for AMD - Applications"
PR = "r1"

inherit packagegroup

PROVIDES = "${PACKAGES}"
PACKAGES = " \
        ${PN}-fans \
        ${PN}-flash \
        ${PN}-system \
        "
PACKAGES:append:amd-withhost = " \
        ${PN}-chassis \
        ${PN}-hostmgmt \
        "

PROVIDES += "virtual/obmc-chassis-mgmt"
PROVIDES += "virtual/obmc-fan-mgmt"
PROVIDES += "virtual/obmc-flash-mgmt"
PROVIDES += "virtual/obmc-system-mgmt"

RPROVIDES:${PN}-chassis += "virtual-obmc-chassis-mgmt"
RPROVIDES:${PN}-fans += "virtual-obmc-fan-mgmt"
RPROVIDES:${PN}-flash += "virtual-obmc-flash-mgmt"
RPROVIDES:${PN}-system += "virtual-obmc-system-mgmt"

SUMMARY:${PN}-chassis = "AMD Chassis"
RDEPENDS:${PN}-chassis = " \
        x86-power-control \
        obmc-host-failure-reboots \
        "

SUMMARY:${PN}-fans = "AMD Fans"
RDEPENDS:${PN}-fans = " \
        phosphor-pid-control \
        "

SUMMARY:${PN}-flash = "AMD Flash"
RDEPENDS:${PN}-flash = " \
        phosphor-software-manager \
        "

SUMMARY:${PN}-system = "AMD System"
RDEPENDS:${PN}-system = " \
        bmc-retimer-update \
        dbus-sensors \
        entity-manager \
        i3c-tools \
        ipmitool \
        phosphor-state-manager-bmc \
        set-fan-speed \
        srvcfg-manager \
        ${RDEPENDS_PN_SYSTEM_EXTRAS} \
        ${RDEPENDS_PN_SYSTEM_MFG} \
        "
RDEPENDS_PN_SYSTEM_EXTRAS = ""
RDEPENDS_PN_SYSTEM_EXTRAS:amd-withhost = " \
        amd-apml \
        amd-fpga \
        phosphor-hostlogger \
        phosphor-watchdog \
        phosphor-host-postd \
        phosphor-post-code-manager \
        vr-update \
        "

python() {
     # Instead of using BB_ENV_EXTRAWHITE, we can get info from the
     # shell environment this way.
     mfg = d.getVar("BB_ORIGENV", False).getVar("BUILD_MFG_IMG", False)

     # set recipes list if mfg env variable is set
     if mfg == '1':
         d.setVar("BUILD_FRUGEN", mfg)
         bb.warn(" Building Manufacturing Image!!! \n")
}

RDEPENDS_PN_SYSTEM_MFG:amd += "${@'frugen' if d.getVar('BUILD_FRUGEN') == '1' else ''}"
