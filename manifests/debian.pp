class spamassassin::debian inherits spamassassin::base {
  file {"/etc/default/spamassassin":
    source => "puppet:///spamassassin/debian/spamassassin",
    require => Package[spamassassin],
    notify => Service[spamassassin],
    owner => root, group => 0, mode => 0644;
  }

  file {"/etc/spamassassin/local.cf":
    source => "puppet:///spamassassin/debian/local.cf",
    require => Package[spamassassin],
    notify => Service[spamassassin],
    owner => root, group => 0, mode => 0644;
  }

  file {"/etc/spamassassin/v310.pre":
    content  => template ("spamassassin/debian/v310.pre"),
    require => Package[spamassassin],
    notify => Service[spamassassin],
    owner => root, group => 0, mode => 0644;
  }
}
