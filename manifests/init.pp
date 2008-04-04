# modules/spamassassin/manifests/init.pp - manage spamassassin stuff
# Copyright (C) 2007 admin@immerda.ch
# GPLv3
# this module requires the amavisd-new module, as well the razor and the dcc module
# this module is part of a whole bunch of modules, please have a look at the exim module
#

# modules_dir { "spamassassin": }

class spamassassin {
    case $operatingsystem {
        gentoo: { include spamassassin::gentoo }
        default: { include spamassassin::base }
    }
}

class spamassassin::base {
    package{'spamassassin':
        ensure => installed,
        require => [ 
            Class[razor], 
            Class[dcc] 
        ],
    }

    service{spamd:
        ensure => stopped,
        enable => false,
        hasstatus => true, 
        require => Package[spamassassin],
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
