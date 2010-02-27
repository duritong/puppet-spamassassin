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

  service{'spamd':
    ensure => stopped,
    enable => false,
    hasstatus => true,
    require => Package[spamassassin],
  }
}
