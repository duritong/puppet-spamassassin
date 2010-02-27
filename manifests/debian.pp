class spamassassin::debian inherits spamassassin::base {
  # fuzzyocr and pyzor are included here by default as well as they increase 
  # the hit-rate 
    
  case $spamassassin_pyzor_enabled { "true": { include pyzor } }    
  case $spamassassin_fuzzyocr_enabled { 
	  "true": { include fuzzyocr } 
	  default: { 
      file { ["/etc/spamassassin/FuzzyOcr.cf", 
			        "/etc/spamassassin/FuzzyOcr.cf.real"] : 
		    ensure => absent;}
		}
  }    

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
