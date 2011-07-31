# manage spamassassin stuff
# Copyright (C) 2007 admin@immerda.ch
# GPLv3
# this module requires the amavisd-new module, as well the razor and the dcc module
# this module is part of a whole bunch of modules, please have a look at the exim module
#

class spamassassin(
  $dcc_enable = false,
  $razor2_enabled = false,
  $pyzor_enabled = false,
  $fuzzyocr_enabled = false
) {
  case $operatingsystem {
    gentoo: { include spamassassin::gentoo }
    debian,ubuntu: { include spamassassin::debian }
    centos: { include spamassassin::centos }
    default: { include spamassassin::base }
  }
}
