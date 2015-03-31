# manage the basic installation parts
class spamassassin::base {
  class{'pyzor':
    use_shorewall => $spamassassin::use_shorewall
  }

  package { 'spamassassin':
    ensure => installed,
  }

  file {"/etc/spamassassin/local.cf":
    require => Package['spamassassin'],
    owner   => root,
    group   => 0,
    mode    => '0644';
  }
  if $spamassassin::config_content {
    File['/etc/spamassassin/local.cf']{
      content => $spamassassin::config_content
    }
  } else {
    File['/etc/spamassassin/local.cf']{
      source  => [ "puppet:///modules/${spamassassin::site_config}/${::fqdn}/local.cf",
                   "puppet:///modules/${spamassassin::site_config}/local.cf",
                   "puppet:///modules/spamassassin/${::operatingsystem}/local.cf" ],
    }
  }
}
