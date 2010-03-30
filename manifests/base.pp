class spamassassin::base {
  # fuzzyocr and pyzor are included here by default as well as they increase
  # the hit-rate
  if $spamassassin_dcc_enabled { require dcc }
  if $spamassassin_razor2_enabled { require razor }
  if $spamassassin_pyzor_enabled { require pyzor }
  if $spamassassin_fuzzyocr_enabled {
    include fuzzyocr
  } else {
    file { ["/etc/spamassassin/FuzzyOcr.cf",
            "/etc/spamassassin/FuzzyOcr.cf.real"] :
      notify => Service['spamd'],
      ensure => absent;
    }
  }

  package { 'spamassassin':
    ensure => installed,
  }

  file {"/etc/spamassassin/local.cf":
    source => [ "puppet://$server/site-spamassassin/${fqdn}/local.cf"
                "puppet://$server/site-spamassassin/local.cf"
                "puppet://$server/spamassassin/${operatingsystem}/local.cf" ],
    require => Package['spamassassin'],
    notify => Service['spamd'],
    owner => root, group => 0, mode => 0644;
  }

  file {"/etc/spamassassin/v310.pre":
    content  => template ("spamassassin/v310.pre"),
    require => Package['spamassassin'],
    notify => Service['spamd'],
    owner => root, group => 0, mode => 0644;
  }


  service{'spamd':
    ensure => stopped,
    enable => false,
    hasstatus => true,
    require => Package[spamassassin],
  }
}
