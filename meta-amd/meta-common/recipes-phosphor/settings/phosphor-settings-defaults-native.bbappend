FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://amd-host-settings.override.yml"
SETTINGS_HOST_TEMPLATES:append = " amd-host-settings.override.yml"
