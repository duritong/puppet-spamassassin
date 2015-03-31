# centos specific things
class spamassassin::centos inherits spamassassin::base {
  require gpg

  File['/etc/spamassassin/local.cf']{
    path => '/etc/mail/spamassassin/local.cf'
  }

  file{
    '/etc/cron.d/sa-update':
      source  => "puppet:///modules/spamassassin/${::operatingsystem}/sa-update.cron",
      require => Package['spamassassin'],
      owner   => root,
      group   => 0,
      mode    => '0644';
  }
}
