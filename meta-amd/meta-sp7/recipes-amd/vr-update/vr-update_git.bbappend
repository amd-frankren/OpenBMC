SUMMARY = "VR config files for Venice"

SRC_URI = "git://git@github.com:/AMDESE/vr-firmware-update.git;branch=integ_sp7;protocol=ssh"
SRCREV = "8856818d19e14a109f13c690d9c4ff5d265f5596"

do_install:append() {
    install -m 0755 ${S}/config/congo-vr.json ${D}/${sbindir}/
    install -m 0755 ${S}/config/morocco-vr.json ${D}/${sbindir}/
}
