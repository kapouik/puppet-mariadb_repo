# Class: mariadb_repo::rpm
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
# * `baseurl`
# Mirror where the repo is. Not compatible with mirrorlist.
#
# * `mirrorlist`
# List of mirror where the repo is. Not compatible with baseurl.
#
# * `includepkgs`
# Include packages of this repository, specified by a name
# or a glob and separated by a comma, in all operations.
#
# * `exclude`
# Exclude packages of this repository, specified by a name
# or a glob and separated by a comma, from all operations.
#
# * `version`
# Version of MariaDB to use.
#
# Examples
# --------
#
# @example
#    class { 'mariadb_repo':
#      version => 106,
#    }
#
class mariadb_repo::rpm (
  $ensure                                = present,
  $path                                  = '/etc/pki/rpm-gpg/RPM-GPG-KEY-MariaDB',
  $baseurl                               = 'http://yum.mariadb.org',
  $mirrorlist                            = absent,
  $includepkgs                           = undef,
  $exclude                               = undef,
  $version                               = '107',
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
        $mariadb107_enabled = 0
        $mariadb108_enabled = 0
        $mariadb109_enabled = 0
      }
      '103': {
        $mariadb102_enabled = 0
        $mariadb103_enabled = 1
        $mariadb104_enabled = 0
        $mariadb105_enabled = 0
        $mariadb106_enabled = 0
        $mariadb107_enabled = 0
        $mariadb108_enabled = 0
        $mariadb109_enabled = 0
      }
      '104': {
        $mariadb102_enabled = 0
        $mariadb103_enabled = 0
        $mariadb104_enabled = 1
        $mariadb105_enabled = 0
        $mariadb106_enabled = 0
        $mariadb107_enabled = 0
        $mariadb108_enabled = 0
        $mariadb109_enabled = 0
      }
      '105': {
        $mariadb102_enabled = 0
        $mariadb103_enabled = 0
        $mariadb104_enabled = 0
        $mariadb105_enabled = 1
        $mariadb106_enabled = 0
        $mariadb107_enabled = 0
        $mariadb108_enabled = 0
        $mariadb109_enabled = 0
      }
      '106': {
        $mariadb102_enabled = 0
        $mariadb103_enabled = 0
        $mariadb104_enabled = 0
        $mariadb105_enabled = 0
        $mariadb106_enabled = 1
        $mariadb107_enabled = 0
        $mariadb108_enabled = 0
        $mariadb109_enabled = 0
      }
      '107': {
        $mariadb102_enabled = 0
        $mariadb103_enabled = 0
        $mariadb104_enabled = 0
        $mariadb105_enabled = 0
        $mariadb106_enabled = 0
        $mariadb107_enabled = 1
        $mariadb108_enabled = 0
        $mariadb109_enabled = 0
      }
      '108': {
        $mariadb102_enabled = 0
        $mariadb103_enabled = 0
        $mariadb104_enabled = 0
        $mariadb105_enabled = 0
        $mariadb106_enabled = 0
        $mariadb107_enabled = 0
        $mariadb108_enabled = 1
        $mariadb109_enabled = 0
      }
      '109': {
        $mariadb102_enabled = 0
        $mariadb103_enabled = 0
        $mariadb104_enabled = 0
        $mariadb105_enabled = 0
        $mariadb106_enabled = 0
        $mariadb107_enabled = 0
        $mariadb108_enabled = 0
        $mariadb109_enabled = 1
      }
      default: {
        fail("MariaDB is not supported on version ${version}")
      }
    }

    if $mariadb102_enabled == unset { $mariadb102_enabled = 0 }
    if $mariadb103_enabled == unset { $mariadb103_enabled = 0 }
    if $mariadb104_enabled == unset { $mariadb104_enabled = 0 }
    if $mariadb105_enabled == unset { $mariadb105_enabled = 0 }
    if $mariadb106_enabled == unset { $mariadb106_enabled = 0 }
    if $mariadb107_enabled == unset { $mariadb107_enabled = 0 }
    if $mariadb108_enabled == unset { $mariadb108_enabled = 0 }


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

      'mariadb107':
        descr       => "MariaDB 10.7 RPM repository for Enterprise Linux ${::operatingsystemmajrelease} - \$basearch",
        baseurl     => "${baseurl}/10.7/${os}${::operatingsystemmajrelease}-${arch}",
        mirrorlist  => $mirrorlist,
        enabled     => $mariadb107_enabled,
        includepkgs => $includepkgs,
        exclude     => $exclude;

      'mariadb108':
        descr       => "MariaDB 10.8 RPM repository for Enterprise Linux ${::operatingsystemmajrelease} - \$basearch",
        baseurl     => "${baseurl}/10.8/${os}${::operatingsystemmajrelease}-${arch}",
        mirrorlist  => $mirrorlist,
        enabled     => $mariadb108_enabled,
        includepkgs => $includepkgs,
        exclude     => $exclude;

      'mariadb109':
        descr       => "MariaDB 10.9 RPM repository for Enterprise Linux ${::operatingsystemmajrelease} - \$basearch",
        baseurl     => "${baseurl}/10.9/${os}${::operatingsystemmajrelease}-${arch}",
        mirrorlist  => $mirrorlist,
        enabled     => $mariadb109_enabled,
        includepkgs => $includepkgs,
        exclude     => $exclude;
    }
  } else {
    notice("mariadb_repo::rpm does not support ${::operatingsystem}.")
  }
}
