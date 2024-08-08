# Class: mariadb_repo::apt
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
class mariadb_repo::apt (
  $ensure                                = present,
  $key                                   = 'https://mariadb.org/mariadb_release_signing_key.asc',
  $mirror                                = 'https://mirror.mva-n.net/mariadb',
  $version                               = '1011',
) {
  if $facts['os']['family'] == 'Debian' {
    case $version {
      '105': {
        $release = '10.5'
      }
      '106': {
        $release = '10.6'
      }
      '1011': {
        $release = '10.11'
      }
      '111': {
        $release = '11.1'
      }
      '112': {
        $release = '11.2'
      }
      '114': {
        $release = '11.4'
      }
      default: {
        fail("MariaDB is not supported on version ${version}")
      }
    }

    $distribution = downcase($facts['os']['name'])

    apt::source { "MariaDB-${release}":
      location => "${mirror}/repo/${release}/${distribution}",
      key      => {
        id     => '177F4010FE56CA3336300305F1656F24C74CD1D8',
        source => $key,
      },
      repos    => 'main',
      release  => $facts['os']['distro']['codename'],
    }
  } else {
    notice("mariadb_repo::apt does not support ${facts['os']['name']}.")
  }
}
