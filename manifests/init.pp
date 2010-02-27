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

class spamassassin::debian inherits spamassassin::base {
    # fuzzyocr and pyzor are included here by default as well as they increase 
    # the hit-rate 
    
    case $spamassassin_pyzor_enabled { "true": { include pyzor } }    
    case $spamassassin_fuzzyocr_enabled { 
	"true": { include fuzzyocr } 
	default: { file { ["/etc/spamassassin/FuzzyOcr.cf", 
			    "/etc/spamassassin/FuzzyOcr.cf.real"] : 
		    ensure => absent;}
		    }
    }    

    file {"/etc/default/spamassassin":
      source => "puppet:///spamassassin/debian/spamassassin",
      mode => 0644, owner => root, group => root,
      require => Package[spamassassin],
      notify => Service[spamassassin];
    }

    file {"/etc/spamassassin/local.cf":
      source => "puppet:///spamassassin/debian/local.cf",
      mode => 0644, owner => root, group => root,
      require => Package[spamassassin],
      notify => Service[spamassassin];
    }

    file {"/etc/spamassassin/v310.pre":
      content  => template ("spamassassin/debian/v310.pre"),
      mode => 0644, owner => root, group => root,
      require => Package[spamassassin],
      notify => Service[spamassassin];
    }


}

class spamassassin::gentoo inherits spamassassin::base {
    Package[spamassassin]{
        category => 'mail-filter',
    }

    #conf.d file if needed
    Service[spamassassin]{
        require +> File["/etc/conf.d/spamd"],
    }
    gentoo::etcconfd{ spamd: }
}






class fuzzyocr {
    case $operatingsystem {
        debian,ubuntu: { include fuzzyocr::debian }
        default: {  }
    }
}

class fuzzyocr::debian {
    # FuzzyOCR currently only tested on debian

    # currently there is no fuzzyocr package for lenny, but the squeeze package 
    # works as well. You need to add it to your local repository
    # http://packages.debian.org/squeeze/fuzzyocr

    package { [ # required by fuzzyocr
		"giflib-tools", "gifsicle", "libstring-approx-perl", "libmldbm-sync-perl", 
		"libtie-cache-perl", "libgif4", "libmldbm-perl", "fuzzyocr", "gocr",
		# additional ocr prgs
		"tesseract-ocr", "tesseract-ocr-deu", "tesseract-ocr-eng",
		"ocrad", 
		]:
		ensure => installed;
    }
    file {"/etc/spamassassin/FuzzyOcr.cf":
      source => "puppet:///spamassassin/debian/FuzzyOcr.cf",
      mode => 0644, owner => root, group => root,
      require => Package[spamassassin],
      notify => Service[spamassassin];
    }

}

class pyzor {
    case $operatingsystem {
        debian,ubuntu: { include pyzor::debian }
        default: {  }
    }

}
class pyzor::debian {
    #also just tested in debian
    
   package { "pyzor": 
        ensure => installed,
    }
}

