FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

require u-boot-common-sp7_2023.10.inc

SRC_URI:append = " file://fw_env_ast2700_nor.config \
                 "

ENV_CONFIG_FILE = "fw_env_ast2700_nor.config"
