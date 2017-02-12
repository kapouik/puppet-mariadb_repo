# Class: mariadb_repo
# ===========================
#
# Configure the MariaDB repository for RHel and import the GPG keys.
#
# Parameters
# ----------
#
# * `ensure`
# Whether MariaDB's repositories and the RPM-GPG-KEY-MariaDB file should exist.
#
# * `path`
# The path to the RPM-GPG-KEY-MariaDB file to manage. Must be an absolute path.
#
# Examples
# --------
#
# @example
#    class { 'mariadb_repo':
#      mariadb101_enabled  => 1,
#    }
#
class mariadb_repo (
  $ensure                                = present,
  $path                                  = '/etc/pki/rpm-gpg/RPM-GPG-KEY-MariaDB',
  $use_epel                              = true,

  $mariadb55_baseurl                     = 'http://yum.mariadb.org/5.5',
  $mariadb55_mirrorlist                  = absent,
  $mariadb55_enabled                     = 0,
  $mariadb55_includepkgs                 = undef,
  $mariadb55_exclude                     = undef,

  $mariadb10_baseurl                     = 'http://yum.mariadb.org/10.0',
  $mariadb10_mirrorlist                  = absent,
  $mariadb10_enabled                     = 0,
  $mariadb10_includepkgs                 = undef,
  $mariadb10_exclude                     = undef,

  $mariadb101_baseurl                    = 'http://yum.mariadb.org/10.1',
  $mariadb101_mirrorlist                 = absent,
  $mariadb101_enabled                    = 0,
  $mariadb101_includepkgs                = undef,
  $mariadb101_exclude                    = undef,

  $mariadb102_baseurl                    = 'http://yum.mariadb.org/10.2',
  $mariadb102_mirrorlist                 = absent,
  $mariadb102_enabled                    = 0,
  $mariadb102_includepkgs                = undef,
  $mariadb102_exclude                    = undef,
){

  if ($::osfamily == 'RedHat' and $::operatingsystem !~ /Fedora|Amazon/) {
    class { 'mariadb_repo::rpm_gpg_key':
      ensure => $ensure,
      path   => $path,
    }
    $os = $::operatingsystem ? {
      'RedHat'     => 'rhel',
      'CentOS'     => 'centos',
      'Scientific' => 'scientific',
      'Fedora'     => 'fedora',
    }

    $arch = $::architecture ? {
      'i386'   => 'x86',
      'i686'   => 'x86',
      'x86_64' => 'amd64',
      default  => $::architecture,
    }

    Yumrepo {
      gpgcheck => 1,
      gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-MariaDB',
      require  => Class['mariadb_repo::rpm_gpg_key'],
    }

    yumrepo {
      'mariadb55':
        descr       => "MariaDB 5.5 RPM repository for Enterprise Linux ${::operatingsystemmajrelease} - \$basearch",
        baseurl     => "${mariadb55_baseurl}/${os}${::operatingsystemmajrelease}-${arch}",
        mirrorlist  => $mariadb55_mirrorlist,
        enabled     => $mariadb55_enabled,
        includepkgs => $mariadb55_includepkgs,
        exclude     => $mariadb55_exclude;

      'mariadb10':
        descr       => "MariaDB 10.0 RPM repository for Enterprise Linux ${::operatingsystemmajrelease} - \$basearch",
        baseurl     => "${mariadb10_baseurl}/${os}${::operatingsystemmajrelease}-${arch}",
        mirrorlist  => $mariadb10_mirrorlist,
        enabled     => $mariadb10_enabled,
        includepkgs => $mariadb10_includepkgs,
        exclude     => $mariadb10_exclude;

      'mariadb101':
        descr       => "MariaDB 10.1 RPM repository for Enterprise Linux ${::operatingsystemmajrelease} - \$basearch",
        baseurl     => "${mariadb101_baseurl}/${os}${::operatingsystemmajrelease}-${arch}",
        mirrorlist  => $mariadb101_mirrorlist,
        enabled     => $mariadb101_enabled,
        includepkgs => $mariadb101_includepkgs,
        exclude     => $mariadb101_exclude;

      'mariadb102':
        descr       => "MariaDB 10.2 RPM repository for Enterprise Linux ${::operatingsystemmajrelease} - \$basearch",
        baseurl     => "${mariadb102_baseurl}/${os}${::operatingsystemmajrelease}-${arch}",
        mirrorlist  => $mariadb102_mirrorlist,
        enabled     => $mariadb102_enabled,
        includepkgs => $mariadb102_includepkgs,
        exclude     => $mariadb102_exclude;
    }
  } else {
    notice("This MariaDB module does not support ${::operatingsystem}.")
  }

}
