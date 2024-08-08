SUMMARY = "VR config files for Venice"

SRC_URI = "git://git@github.com:/AMDESE/vr-firmware-update.git;branch=integ_sp7;protocol=ssh"
SRCREV = "16612809593d1f4afdc8d9edcf557c00c13c40eb"

do_install:append() {
    install -m 0755 ${S}/config/congo-vr.json ${D}/${sbindir}/
    install -m 0755 ${S}/config/morocco-vr.json ${D}/${sbindir}/
}
