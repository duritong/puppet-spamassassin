class spamassassin::centos inherits spamassassin::base {
  require gpg
  Service['spamd']{
    name => 'spamassassin'
  }

  File['/etc/spamassassin/local.cf']{
    path => '/etc/mail/spamassassin/local.cf'
  }
  File['/etc/spamassassin/v310.pre']{
    path => '/etc/mail/spamassassin/v310.pre'
  }

  File['/etc/spamassassin/FuzzyOcr.cf']{
    path => '/etc/mail/spamassassin/FuzzyOcr.cf'
  }
  File['/etc/spamassassin/FuzzyOcr.cf.real']{
    path => '/etc/mail/spamassassin/FuzzyOcr.cf.real'
  }

  file{'/etc/sysconfig/sa-update':
    source => [ "puppet:///modules/site-spamassassin/sysconfig/${fqdn}/sa-update", 
                "puppet:///modules/site-spamassassin/sysconfig/sa-update", 
                "puppet:///modules/spamassassin/sysconfig/sa-update" ], 
    require => Package['spamassassin'],
    owner => root, group => 0, mode => 0644;
  }

  file{'/etc/cron.d/sa-update':
    source => "puppet:///modules/spamassassin/${operatingsystem}/sa-update.cron",
    require => Package['spamassassin'],
    owner => root, group => 0, mode => 0644;
  }
}
