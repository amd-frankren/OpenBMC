SUMMARY = "VR config files for SP5"

SRC_URI = "git://git@github.com:/AMDESE/vr-firmware-update.git;branch=integ_sp7;protocol=ssh"
SRCREV = "7888ef33a6a819a3aab20f621935868450e09b09"

do_install:append() {
    install -m 0755 ${S}/config/onyx-vr.json ${D}/${sbindir}/
}
