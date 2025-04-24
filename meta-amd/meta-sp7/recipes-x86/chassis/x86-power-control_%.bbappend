FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:amd-configmgr = " file://xyz.openbmc_project.Chassis.Control.Power@.service"

do_configure:append:amd-configmgr(){
     cp ${WORKDIR}/xyz.openbmc_project.Chassis.Control.Power@.service ${S}/service_files
}
