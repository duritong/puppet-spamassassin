class spamassassin::base {
  case $spamassassin_dcc_enabled { "true": { include dcc } }    
  case $spamassassin_razor2_enabled { "true": { include razor } }    
    
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
