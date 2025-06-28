SRC_URI:amd = "git://github.com/AMDESE/pldm;branch=integ_sp7;protocol=https"
SRCREV:amd = "9bae8c483778d8a62a56cd103e5cfc56629f05e8"

DEPENDS += "libbej"

EXTRA_OEMESON:append = " -Doem-ibm=disabled -Doem-ampere=disabled"
