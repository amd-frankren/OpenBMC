SRC_URI:amd = "git://github.com/AMDESE/pldm;branch=integ_sp7;protocol=https"
SRCREV:amd = "56fc23cd3823f2c7f1a47461615e336989a378d7"

DEPENDS += "libbej"

EXTRA_OEMESON:append = " -Doem-ibm=disabled -Doem-ampere=disabled"
