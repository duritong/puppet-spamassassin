# manage the basic installation parts
class spamassassin::base {
  class{'pyzor':
    use_shorewall => $spamassassin::use_shorewall,
  }

  package { 'spamassassin':
    ensure => installed,
  }

  concat {'/etc/spamassassin/local.cf':
    require => Package['spamassassin'],
    owner   => root,
    group   => 0,
    mode    => '0644';
  }
  concat_fragment{
    'spamassassin-main-config':
      target => '/etc/spamassassin/local.cf',
      order  => 50,
  }
  if $spamassassin::config_content {
    Concat_file['spamassassin-main-config']{
      content => $spamassassin::config_content
    }
  } else {
    Concat_file['spamassassin-main-config']{
      source  => [ "puppet:///modules/${spamassassin::site_config}/${::fqdn}/local.cf",
                    "puppet:///modules/${spamassassin::site_config}/local.cf",
                    "puppet:///modules/spamassassin/${::operatingsystem}/local.cf" ],
    }
  }
}
