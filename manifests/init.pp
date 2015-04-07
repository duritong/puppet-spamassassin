# manage spamassassin stuff
# Copyright (C) 2007 admin@immerda.ch
# GPLv3
# this module requires the amavisd-new module, as well the dcc module
# this module is part of a whole bunch of modules,
# please have a look at the exim module
#
# manages shorewall with a few extras
class spamassassin(
  $config_content = false,
  $site_config    = 'site_spamassassin',
  $use_shorewall  = false,
) {
  case $::operatingsystem {
    'Debian','Ubuntu': { include ::spamassassin::debian }
    'CentOS': { include ::spamassassin::centos }
    default: { include ::spamassassin::base }
  }
  if $use_shorewall {
    include ::shorewall::rules::out::razor
  }
}
