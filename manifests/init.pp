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
#      version => 101,
#    }
#
class mariadb_repo (
  $ensure                                = present,
  $path                                  = '/etc/pki/rpm-gpg/RPM-GPG-KEY-MariaDB',
  $baseurl                               = 'http://yum.mariadb.org',
  $mirrorlist                            = absent,
  $includepkgs                           = undef,
  $exclude                               = undef,
  $version                               = undef,
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

    case $version {
      55: {
        $mariadb55_enabled = 1
      }
      10: {
        $mariadb10_enabled = 1
      }
      101: {
        $mariadb101_enabled = 1
      }
      102: {
        $mariadb102_enabled = 1
      }
      103: {
        $mariadb103_enabled = 1
      }
      default: {
        fail("MariaDB is not supported on version ${version}")
      }
    }

    if $mariadb55_enabled == unset { $mariadb55_enabled = 0 }
    if $mariadb10_enabled == unset { $mariadb10_enabled = 0 }
    if $mariadb101_enabled == unset { $mariadb101_enabled = 0 }
    if $mariadb102_enabled == unset { $mariadb102_enabled = 0 }
    if $mariadb103_enabled == unset { $mariadb103_enabled = 0 }

    Yumrepo {
      gpgcheck => 1,
      gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-MariaDB',
      require  => Class['mariadb_repo::rpm_gpg_key'],
    }

    yumrepo {
      'mariadb55':
        descr       => "MariaDB 5.5 RPM repository for Enterprise Linux ${::operatingsystemmajrelease} - \$basearch",
        baseurl     => "${baseurl}/5.5/${os}${::operatingsystemmajrelease}-${arch}",
        mirrorlist  => $mirrorlist,
        enabled     => $mariadb55_enabled,
        includepkgs => $includepkgs,
        exclude     => $exclude;

      'mariadb10':
        descr       => "MariaDB 10.0 RPM repository for Enterprise Linux ${::operatingsystemmajrelease} - \$basearch",
        baseurl     => "${baseurl}/10.0/${os}${::operatingsystemmajrelease}-${arch}",
        mirrorlist  => $mirrorlist,
        enabled     => $mariadb10_enabled,
        includepkgs => $includepkgs,
        exclude     => $exclude;

      'mariadb101':
        descr       => "MariaDB 10.1 RPM repository for Enterprise Linux ${::operatingsystemmajrelease} - \$basearch",
        baseurl     => "${baseurl}/10.1/${os}${::operatingsystemmajrelease}-${arch}",
        mirrorlist  => $mirrorlist,
        enabled     => $mariadb101_enabled,
        includepkgs => $includepkgs,
        exclude     => $exclude;

      'mariadb102':
        descr       => "MariaDB 10.2 RPM repository for Enterprise Linux ${::operatingsystemmajrelease} - \$basearch",
        baseurl     => "${baseurl}/10.2/${os}${::operatingsystemmajrelease}-${arch}",
        mirrorlist  => $mirrorlist,
        enabled     => $mariadb102_enabled,
        includepkgs => $includepkgs,
        exclude     => $exclude;

      'mariadb103':
        descr       => "MariaDB 10.3 RPM repository for Enterprise Linux ${::operatingsystemmajrelease} - \$basearch",
        baseurl     => "${baseurl}/10.3/${os}${::operatingsystemmajrelease}-${arch}",
        mirrorlist  => $mirrorlist,
        enabled     => $mariadb103_enabled,
        includepkgs => $includepkgs,
        exclude     => $exclude;
    }
  } else {
    notice("This MariaDB module does not support ${::operatingsystem}.")
  }

}
