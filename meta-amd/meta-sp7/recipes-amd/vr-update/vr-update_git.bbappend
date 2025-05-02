SUMMARY = "VR config files for Venice"

SRC_URI = "git://git@github.com:/AMDESE/vr-firmware-update.git;branch=integ_sp7;protocol=ssh"
SRCREV = "f11af28815314c819f77f7d7383f2d2703d3109a"

do_install:append() {
    install -m 0755 ${S}/config/congo-vr.json ${D}/${sbindir}/
    install -m 0755 ${S}/config/morocco-vr.json ${D}/${sbindir}/
    install -m 0755 ${S}/config/kenya-vr.json ${D}/${sbindir}/
    install -m 0755 ${S}/config/nigeria-vr.json ${D}/${sbindir}/
}
