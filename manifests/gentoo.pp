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
