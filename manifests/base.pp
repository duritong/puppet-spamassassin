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
		  ensure => absent;
    }
  }    
   
  package { 'spamassassin':
    ensure => installed,
  }
    
  case $operatingsystem {
    debian: {$spamd_servicename = "spamassassin" }
    default: {$spamd_servicename="spamd"}
  }


  service{spamd:
	  name => $spamd_servicename,
    ensure => stopped,
    enable => false,
    hasstatus => true, 
    require => Package[spamassassin],
  }
}
