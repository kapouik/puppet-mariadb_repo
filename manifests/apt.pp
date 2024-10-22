# @summary
#  Configure the MariaDB repository for RHel and import the GPG keys.
#
# @param key
#   Where to find the GPG key.
#
# @param mirror
#   Mirror where the repo is.
#
# @param version
#   Version of MariaDB to use.
#
class mariadb_repo::apt (
  String $key     = 'https://mariadb.org/mariadb_release_signing_key.asc',
  String $mirror  = 'https://mirror.mva-n.net/mariadb',
  String $version = '1011',
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
      '113': {
        $release = '11.3'
      }
      '114': {
        $release = '11.4'
      }
      '115': {
        $release = '11.5'
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
