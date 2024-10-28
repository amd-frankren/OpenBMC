FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

PACKAGECONFIG:append = " boot_type"
SRC_URI:append = " file://applyTime.override.yml file://sol-default.override.yml"
