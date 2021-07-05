# debian specific files
class spamassassin::debian inherits spamassassin::base {
  file { '/etc/default/spamassassin':
    source  => "puppet:///modules/spamassassin/${facts['os']['name']}/spamassassin",
    require => Package['spamassassin'],
    owner   => root,
    group   => 0,
    mode    => '0644';
  }
}
