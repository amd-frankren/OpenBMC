SUMMARY = "VR config files for Venice"

SRC_URI = "git://git@github.com:/AMDESE/vr-firmware-update.git;branch=integ_sp7;protocol=ssh"
SRCREV = "3690b84ee758d2de52235656929890f47e9c3b0a"

do_install:append() {
    install -m 0755 ${S}/config/congo-vr.json ${D}/${sbindir}/
    install -m 0755 ${S}/config/morocco-vr.json ${D}/${sbindir}/
    install -m 0755 ${S}/config/kenya-vr.json ${D}/${sbindir}/
	install -m 0755 ${S}/config/nigeria-vr.json ${D}/${sbindir}/
}
