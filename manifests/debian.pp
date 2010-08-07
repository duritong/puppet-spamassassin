class spamassassin::debian inherits spamassassin::base {
  Service['spamd']{
    name => 'spamassassin',
  }
  file {"/etc/default/spamassassin":
    source => "puppet:///spamassassin/${operatingsystem}/spamassassin",
    require => Package['spamassassin'],
    notify => Service['spamd'],
    owner => root, group => 0, mode => 0644;
  }
}
