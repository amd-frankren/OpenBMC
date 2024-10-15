SUMMARY = "VR config files for Venice"

SRC_URI = "git://git@github.com:/AMDESE/vr-firmware-update.git;branch=integ_sp7;protocol=ssh"
SRCREV = "c84e291f550e199baee22c0d6fc1caa4d86072bf"

do_install:append() {
    install -m 0755 ${S}/config/congo-vr.json ${D}/${sbindir}/
    install -m 0755 ${S}/config/morocco-vr.json ${D}/${sbindir}/
    install -m 0755 ${S}/config/kenya-vr.json ${D}/${sbindir}/
}
