# centos specific things
class spamassassin::centos inherits spamassassin::base {
  require gpg

  Concat['/etc/spamassassin/local.cf'] {
    path => '/etc/mail/spamassassin/local.cf'
  }
  Concat['/etc/spamassassin/local.pre'] {
    path => '/etc/mail/spamassassin/local.pre'
  }

  # https://bugzilla.redhat.com/show_bug.cgi?id=1938575
  if versioncmp($facts['os']['release']['major'],'8') < 0 {
    file { '/etc/mail/spamassassin/channel.d/sought.conf':
      ensure  => absent,
      require => Package['spamassassin'],
    }

    file {
      '/etc/cron.d/sa-update':
        source  => "puppet:///modules/spamassassin/${facts['os']['name']}/sa-update.cron",
        require => Package['spamassassin'],
        owner   => root,
        group   => 0,
        mode    => '0644';
    }
  } else {
    service { 'sa-update.timer':
      ensure  => true,
      enable  => true,
      require => Package['spamassassin'],
    }
  }
}
