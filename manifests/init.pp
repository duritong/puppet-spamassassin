# manage spamassassin stuff
# Copyright (C) 2007 admin@immerda.ch
# GPLv3
# this module requires the amavisd-new module, as well the razor and the dcc module
# this module is part of a whole bunch of modules, please have a look at the exim module
#

class spamassassin {
  case $spamassassin_dcc_enabled {
    "": { $spamassassin_dcc_enabled = "false" }
  }

  case $spamassassin_pyzor_enabled {
    "": { $spamassassin_pyzor_enabled = "false" }
  }

  case $spamassassin_razor2_enabled {
    "": { $spamassassin_razor2_enabled = "false" }
  }

  case $spamassassin_fuzzyocr_enabled {
    "": { $spamassassin_fuzzyocr_enabled = "false" }
  }

  case $operatingsystem {
    gentoo: { include spamassassin::gentoo }
    debian,ubuntu: { include spamassassin::debian }
    default: { include spamassassin::base }
  }
}
