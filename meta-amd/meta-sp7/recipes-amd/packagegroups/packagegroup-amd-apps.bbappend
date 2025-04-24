#TODO Remove this once recipes support is in.
RDEPENDS_PN_SYSTEM_EXTRAS:remove:sp7:amd-withhost = "amd-fpga"
RDEPENDS_PN_SYSTEM_EXTRAS:append:sp7:amd-withhost = " \
    amd-host-manager \
    cpu-info \
    fpga-tools \
    i3chub-init \
    mtd-utils \
    phosphor-inventory-manager \
    phosphor-ipmi-fru \
    tcpdump \
    "
RDEPENDS_PN_SYSTEM_EXTRAS:append:sp7:amd-configmgr = " \
    multi-host-config \
    "
