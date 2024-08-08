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
) {
  if ($facts['os']['family'] == 'RedHat' and $facts['os']['name'] !~ /Fedora|Amazon/) {
    class { 'mariadb_repo::rpm_gpg_key':
      ensure => $ensure,
      path   => $path,
    }
    $os = $facts['os']['name'] ? {
      'RedHat'     => 'rhel',
      'CentOS'     => 'centos',
      'Rocky'      => 'centos',
      'Scientific' => 'scientific',
      'Fedora'     => 'fedora',
    }

    $arch = $facts['os']['architecture'] ? {
      'i386'   => 'x86',
      'i686'   => 'x86',
      'x86_64' => 'amd64',
      default  => $facts['os']['architecture'],
    }

    case $version {
      '102': {
        $mariadb102_enabled = 1
        $mariadb103_enabled = 0
        $mariadb104_enabled = 0
        $mariadb105_enabled = 0
        $mariadb106_enabled = 0
        $mariadb1011_enabled = 0
        $mariadb111_enabled = 0
        $mariadb112_enabled = 0
        $mariadb114_enabled = 0
      }
      '103': {
        $mariadb102_enabled = 0
        $mariadb103_enabled = 1
        $mariadb104_enabled = 0
        $mariadb105_enabled = 0
        $mariadb106_enabled = 0
        $mariadb1011_enabled = 0
        $mariadb111_enabled = 0
        $mariadb112_enabled = 0
        $mariadb114_enabled = 0
      }
      '104': {
        $mariadb102_enabled = 0
        $mariadb103_enabled = 0
        $mariadb104_enabled = 1
        $mariadb105_enabled = 0
        $mariadb106_enabled = 0
        $mariadb1011_enabled = 0
        $mariadb111_enabled = 0
        $mariadb112_enabled = 0
        $mariadb114_enabled = 0
      }
      '105': {
        $mariadb102_enabled = 0
        $mariadb103_enabled = 0
        $mariadb104_enabled = 0
        $mariadb105_enabled = 1
        $mariadb106_enabled = 0
        $mariadb1011_enabled = 0
        $mariadb111_enabled = 0
        $mariadb112_enabled = 0
        $mariadb114_enabled = 0
      }
      '106': {
        $mariadb102_enabled = 0
        $mariadb103_enabled = 0
        $mariadb104_enabled = 0
        $mariadb105_enabled = 0
        $mariadb106_enabled = 1
        $mariadb1011_enabled = 0
        $mariadb111_enabled = 0
        $mariadb112_enabled = 0
        $mariadb114_enabled = 0
      }
      '1011': {
        $mariadb102_enabled = 0
        $mariadb103_enabled = 0
        $mariadb104_enabled = 0
        $mariadb105_enabled = 0
        $mariadb106_enabled = 0
        $mariadb1011_enabled = 1
        $mariadb111_enabled = 0
        $mariadb112_enabled = 0
        $mariadb114_enabled = 0
      }
      '111': {
        $mariadb102_enabled = 0
        $mariadb103_enabled = 0
        $mariadb104_enabled = 0
        $mariadb105_enabled = 0
        $mariadb106_enabled = 0
        $mariadb1011_enabled = 0
        $mariadb111_enabled = 1
        $mariadb112_enabled = 0
        $mariadb114_enabled = 0
      }
      '112': {
        $mariadb102_enabled = 0
        $mariadb103_enabled = 0
        $mariadb104_enabled = 0
        $mariadb105_enabled = 0
        $mariadb106_enabled = 0
        $mariadb1011_enabled = 0
        $mariadb111_enabled = 0
        $mariadb112_enabled = 1
        $mariadb114_enabled = 0
      }
      '114': {
        $mariadb102_enabled = 0
        $mariadb103_enabled = 0
        $mariadb104_enabled = 0
        $mariadb105_enabled = 0
        $mariadb106_enabled = 0
        $mariadb1011_enabled = 0
        $mariadb111_enabled = 0
        $mariadb112_enabled = 0
        $mariadb114_enabled = 1
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
    if $mariadb1011_enabled == unset { $mariadb1011_enabled = 0 }
    if $mariadb111_enabled == unset { $mariadb111_enabled = 0 }
    if $mariadb112_enabled == unset { $mariadb112_enabled = 0 }
    if $mariadb114_enabled == unset { $mariadb114_enabled = 0 }

    yumrepo {
      default:
        gpgcheck => 1,
        gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-MariaDB',
        require  => Class['mariadb_repo::rpm_gpg_key'];

      'mariadb102':
        descr       => "MariaDB 10.2 RPM repository for Enterprise Linux ${facts['os']['release']['major']} - \$basearch",
        baseurl     => "${baseurl}/10.2/${os}${facts['os']['release']['major']}-${arch}",
        mirrorlist  => $mirrorlist,
        enabled     => $mariadb102_enabled,
        includepkgs => $includepkgs,
        exclude     => $exclude;

      'mariadb103':
        descr       => "MariaDB 10.3 RPM repository for Enterprise Linux ${facts['os']['release']['major']} - \$basearch",
        baseurl     => "${baseurl}/10.3/${os}${facts['os']['release']['major']}-${arch}",
        mirrorlist  => $mirrorlist,
        enabled     => $mariadb103_enabled,
        includepkgs => $includepkgs,
        exclude     => $exclude;

      'mariadb104':
        descr       => "MariaDB 10.4 RPM repository for Enterprise Linux ${facts['os']['release']['major']} - \$basearch",
        baseurl     => "${baseurl}/10.4/${os}${facts['os']['release']['major']}-${arch}",
        mirrorlist  => $mirrorlist,
        enabled     => $mariadb104_enabled,
        includepkgs => $includepkgs,
        exclude     => $exclude;

      'mariadb105':
        descr       => "MariaDB 10.5 RPM repository for Enterprise Linux ${facts['os']['release']['major']} - \$basearch",
        baseurl     => "${baseurl}/10.5/${os}${facts['os']['release']['major']}-${arch}",
        mirrorlist  => $mirrorlist,
        enabled     => $mariadb105_enabled,
        includepkgs => $includepkgs,
        exclude     => $exclude;

      'mariadb106':
        descr       => "MariaDB 10.6 RPM repository for Enterprise Linux ${facts['os']['release']['major']} - \$basearch",
        baseurl     => "${baseurl}/10.6/${os}${facts['os']['release']['major']}-${arch}",
        mirrorlist  => $mirrorlist,
        enabled     => $mariadb106_enabled,
        includepkgs => $includepkgs,
        exclude     => $exclude;

      'mariadb1011':
        descr       => "MariaDB 10.11 RPM repository for Enterprise Linux ${facts['os']['release']['major']} - \$basearch",
        baseurl     => "${baseurl}/10.11/${os}${facts['os']['release']['major']}-${arch}",
        mirrorlist  => $mirrorlist,
        enabled     => $mariadb1011_enabled,
        includepkgs => $includepkgs,
        exclude     => $exclude;

      'mariadb111':
        descr       => "MariaDB 11.1 RPM repository for Enterprise Linux ${facts['os']['release']['major']} - \$basearch",
        baseurl     => "${baseurl}/11.1/${os}${facts['os']['release']['major']}-${arch}",
        mirrorlist  => $mirrorlist,
        enabled     => $mariadb111_enabled,
        includepkgs => $includepkgs,
        exclude     => $exclude;

      'mariadb112':
        descr       => "MariaDB 11.2 RPM repository for Enterprise Linux ${facts['os']['release']['major']} - \$basearch",
        baseurl     => "${baseurl}/11.2/${os}${facts['os']['release']['major']}-${arch}",
        mirrorlist  => $mirrorlist,
        enabled     => $mariadb112_enabled,
        includepkgs => $includepkgs,
        exclude     => $exclude;

      'mariadb114':
        descr       => "MariaDB 11.4 RPM repository for Enterprise Linux ${facts['os']['release']['major']} - \$basearch",
        baseurl     => "${baseurl}/11.4/${os}${facts['os']['release']['major']}-${arch}",
        mirrorlist  => $mirrorlist,
        enabled     => $mariadb114_enabled,
        includepkgs => $includepkgs,
        exclude     => $exclude;
    }
  } else {
    notice("mariadb_repo::rpm does not support ${facts['os']['name']}.")
  }
}
