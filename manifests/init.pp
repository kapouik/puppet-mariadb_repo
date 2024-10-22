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
# @param key
#   Where to find the GPG key.
#
# @param mirror
#   Mirror where the repo is.
#
# @param version
#   Version of MariaDB to use.
#
class mariadb_repo (
  String $path                                  = '/etc/pki/rpm-gpg/RPM-GPG-KEY-MariaDB',
  Variant[String, Enum['absent']] $baseurl      = 'http://yum.mariadb.org',
  Variant[String, Enum['absent']] $mirrorlist   = absent,
  Optional[Variant[String, Array]] $includepkgs = undef,
  Optional[Variant[String, Array]] $exclude     = undef,
  String $key                                   = 'https://mariadb.org/mariadb_release_signing_key.asc',
  String $mirror                                = 'https://mirror.mva-n.net/mariadb',
  String $version                               = '1011',
) {
  if ($facts['os']['family'] == 'RedHat' and $facts['os']['name'] !~ /Fedora|Amazon/) {
    class { 'mariadb_repo::rpm':
      path        => $path,
      baseurl     => $baseurl,
      mirrorlist  => $mirrorlist,
      includepkgs => $includepkgs,
      exclude     => $exclude,
      version     => $version,
    }
  } elsif $facts['os']['family'] == 'Debian' {
    class { 'mariadb_repo::apt':
      key     => $key,
      mirror  => $mirror,
      version => $version,
    }
  } else {
    notice("This MariaDB module does not support ${facts['os']['name']}.")
  }
}
