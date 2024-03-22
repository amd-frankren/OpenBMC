RDEPENDS:${PN}-system:append:ethanolx = " ip-to-fpga"

#TODO Disabled due to flash size limitation.
RDEPENDS_PN_SYSTEM_EXTRAS:remove:ethanolx:amd-withhost = "amd-fpga"
