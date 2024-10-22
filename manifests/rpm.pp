# @summary
#  Configure the MariaDB repository for RHel and import the GPG keys.
#
# @param path
#   The path to the RPM-GPG-KEY-MariaDB file to manage. Must be an absolute path.
#
# @param baseurl
#   Mirror where the repo is. Not compatible with mirrorlist.
#
# @param mirrorlist
#   List of mirror where the repo is. Not compatible with baseurl.
#
# @param includepkgs
#   Include packages of this repository, specified by a name
#   or a glob and separated by a comma, in all operations.
#
# @param exclude
#   Exclude packages of this repository, specified by a name
#   or a glob and separated by a comma, from all operations.
#
# @param version
#   Version of MariaDB to use.
#
class mariadb_repo::rpm (
  String $path                                  = '/etc/pki/rpm-gpg/RPM-GPG-KEY-MariaDB',
  Variant[String, Enum['absent']] $baseurl      = 'http://yum.mariadb.org',
  Variant[String, Enum['absent']] $mirrorlist   = absent,
  Optional[Variant[String, Array]] $includepkgs = undef,
  Optional[Variant[String, Array]] $exclude     = undef,
  String $version                               = '1011',
) {
  if ($facts['os']['family'] == 'RedHat' and $facts['os']['name'] !~ /Fedora|Amazon/) {
    class { 'mariadb_repo::rpm_gpg_key':
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
        $mariadb113_enabled = 0
        $mariadb114_enabled = 0
        $mariadb115_enabled = 0
      }
      '103': {
        $mariadb102_enabled = 0
        $mariadb103_enabled = 1
        $mariadb104_enabled = 0
        $mariadb105_enabled = 0
        $mariadb106_enabled = 0
        $mariadb1011_enabled = 0
        $mariadb113_enabled = 0
        $mariadb114_enabled = 0
        $mariadb115_enabled = 0
      }
      '104': {
        $mariadb102_enabled = 0
        $mariadb103_enabled = 0
        $mariadb104_enabled = 1
        $mariadb105_enabled = 0
        $mariadb106_enabled = 0
        $mariadb1011_enabled = 0
        $mariadb113_enabled = 0
        $mariadb114_enabled = 0
        $mariadb115_enabled = 0
      }
      '105': {
        $mariadb102_enabled = 0
        $mariadb103_enabled = 0
        $mariadb104_enabled = 0
        $mariadb105_enabled = 1
        $mariadb106_enabled = 0
        $mariadb1011_enabled = 0
        $mariadb113_enabled = 0
        $mariadb114_enabled = 0
        $mariadb115_enabled = 0
      }
      '106': {
        $mariadb102_enabled = 0
        $mariadb103_enabled = 0
        $mariadb104_enabled = 0
        $mariadb105_enabled = 0
        $mariadb106_enabled = 1
        $mariadb1011_enabled = 0
        $mariadb113_enabled = 0
        $mariadb114_enabled = 0
        $mariadb115_enabled = 0
      }
      '1011': {
        $mariadb102_enabled = 0
        $mariadb103_enabled = 0
        $mariadb104_enabled = 0
        $mariadb105_enabled = 0
        $mariadb106_enabled = 0
        $mariadb1011_enabled = 1
        $mariadb113_enabled = 0
        $mariadb114_enabled = 0
        $mariadb115_enabled = 0
      }
      '113': {
        $mariadb102_enabled = 0
        $mariadb103_enabled = 0
        $mariadb104_enabled = 0
        $mariadb105_enabled = 0
        $mariadb106_enabled = 0
        $mariadb1011_enabled = 0
        $mariadb113_enabled = 1
        $mariadb114_enabled = 0
        $mariadb115_enabled = 0
      }
      '114': {
        $mariadb102_enabled = 0
        $mariadb103_enabled = 0
        $mariadb104_enabled = 0
        $mariadb105_enabled = 0
        $mariadb106_enabled = 0
        $mariadb1011_enabled = 0
        $mariadb113_enabled = 0
        $mariadb114_enabled = 1
        $mariadb115_enabled = 0
      }
      '115': {
        $mariadb102_enabled = 0
        $mariadb103_enabled = 0
        $mariadb104_enabled = 0
        $mariadb105_enabled = 0
        $mariadb106_enabled = 0
        $mariadb1011_enabled = 0
        $mariadb113_enabled = 0
        $mariadb114_enabled = 0
        $mariadb115_enabled = 1
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
    if $mariadb113_enabled == unset { $mariadb113_enabled = 0 }
    if $mariadb114_enabled == unset { $mariadb114_enabled = 0 }
    if $mariadb115_enabled == unset { $mariadb115_enabled = 0 }

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

      'mariadb113':
        descr       => "MariaDB 11.3 RPM repository for Enterprise Linux ${facts['os']['release']['major']} - \$basearch",
        baseurl     => "${baseurl}/11.3/${os}${facts['os']['release']['major']}-${arch}",
        mirrorlist  => $mirrorlist,
        enabled     => $mariadb113_enabled,
        includepkgs => $includepkgs,
        exclude     => $exclude;

      'mariadb114':
        descr       => "MariaDB 11.4 RPM repository for Enterprise Linux ${facts['os']['release']['major']} - \$basearch",
        baseurl     => "${baseurl}/11.4/${os}${facts['os']['release']['major']}-${arch}",
        mirrorlist  => $mirrorlist,
        enabled     => $mariadb114_enabled,
        includepkgs => $includepkgs,
        exclude     => $exclude;

      'mariadb115':
        descr       => "MariaDB 11.5 RPM repository for Enterprise Linux ${facts['os']['release']['major']} - \$basearch",
        baseurl     => "${baseurl}/11.5/${os}${facts['os']['release']['major']}-${arch}",
        mirrorlist  => $mirrorlist,
        enabled     => $mariadb115_enabled,
        includepkgs => $includepkgs,
        exclude     => $exclude;
    }
  } else {
    notice("mariadb_repo::rpm does not support ${facts['os']['name']}.")
  }
}
