FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

S = "${WORKDIR}/git"

SRC_URI += "file://0001-Support-HPM-FPGA-firmware-update.patch \
            file://0002-webui-support-for-Retimer-bundle-firmware-update.patch \
            file://0003-webui-support-for-VR-bundle-update.patch \
            file://0004-Poll-for-firmware-update-progress.patch \
            file://0005-meta-amd-webui-vue-Multi-Host-Config-settings.patch \
            file://0006-Changed-reboot-async-behavior.patch \
            "
