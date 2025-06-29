SRC_URI:amd = "git://github.com/AMDESE/pldm;branch=integ_sp7;protocol=https"
SRCREV:amd = "a372f7e21a7cfe41781058e3348c346fb62e7c88"

DEPENDS += "libbej"

EXTRA_OEMESON:append = " -Doem-ibm=disabled -Doem-ampere=disabled"
