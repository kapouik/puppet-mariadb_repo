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
  $version                               = '102',
){

  if ($::osfamily == 'RedHat' and $::operatingsystem !~ /Fedora|Amazon/) {
    class { 'mariadb_repo::rpm_gpg_key':
      ensure => $ensure,
      path   => $path,
    }
    $os = $::operatingsystem ? {
      'RedHat'     => 'rhel',
      'CentOS'     => 'centos',
      'Rocky'      => 'centos',
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
      '102': {
        $mariadb102_enabled = 1
        $mariadb103_enabled = 0
        $mariadb104_enabled = 0
        $mariadb105_enabled = 0
        $mariadb106_enabled = 0
      }
      '103': {
        $mariadb102_enabled = 0
        $mariadb103_enabled = 1
        $mariadb104_enabled = 0
        $mariadb105_enabled = 0
        $mariadb106_enabled = 0
      }
      '104': {
        $mariadb102_enabled = 0
        $mariadb103_enabled = 0
        $mariadb104_enabled = 1
        $mariadb105_enabled = 0
        $mariadb106_enabled = 0
      }
      '105': {
        $mariadb102_enabled = 0
        $mariadb103_enabled = 0
        $mariadb104_enabled = 0
        $mariadb105_enabled = 1
        $mariadb106_enabled = 0
      }
      '106': {
        $mariadb102_enabled = 0
        $mariadb103_enabled = 0
        $mariadb104_enabled = 0
        $mariadb105_enabled = 0
        $mariadb106_enabled = 1
      }
      default: {
        fail("MariaDB is not supported on version ${version}")
      }
    }

    if $mariadb102_enabled == unset { $mariadb102_enabled = 0 }
    if $mariadb103_enabled == unset { $mariadb103_enabled = 0 }
    if $mariadb104_enabled == unset { $mariadb104_enabled = 0 }
    if $mariadb105_enabled == unset { $mariadb105_enabled = 0 }

    yumrepo {
      default:
        gpgcheck => 1,
        gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-MariaDB',
        require  => Class['mariadb_repo::rpm_gpg_key'];

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

      'mariadb104':
        descr       => "MariaDB 10.4 RPM repository for Enterprise Linux ${::operatingsystemmajrelease} - \$basearch",
        baseurl     => "${baseurl}/10.4/${os}${::operatingsystemmajrelease}-${arch}",
        mirrorlist  => $mirrorlist,
        enabled     => $mariadb104_enabled,
        includepkgs => $includepkgs,
        exclude     => $exclude;

      'mariadb105':
        descr       => "MariaDB 10.5 RPM repository for Enterprise Linux ${::operatingsystemmajrelease} - \$basearch",
        baseurl     => "${baseurl}/10.5/${os}${::operatingsystemmajrelease}-${arch}",
        mirrorlist  => $mirrorlist,
        enabled     => $mariadb105_enabled,
        includepkgs => $includepkgs,
        exclude     => $exclude;

      'mariadb106':
        descr       => "MariaDB 10.6 RPM repository for Enterprise Linux ${::operatingsystemmajrelease} - \$basearch",
        baseurl     => "${baseurl}/10.6/${os}${::operatingsystemmajrelease}-${arch}",
        mirrorlist  => $mirrorlist,
        enabled     => $mariadb106_enabled,
        includepkgs => $includepkgs,
        exclude     => $exclude;
    }
  } else {
    notice("This MariaDB module does not support ${::operatingsystem}.")
  }

}
