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
#      version => 107,
#    }
#
class mariadb_repo (
  $ensure                                = present,
  $path                                  = '/etc/pki/rpm-gpg/RPM-GPG-KEY-MariaDB',
  $baseurl                               = 'http://yum.mariadb.org',
  $mirrorlist                            = absent,
  $includepkgs                           = undef,
  $exclude                               = undef,
  $key                                   = 'https://mariadb.org/mariadb_release_signing_key.asc',
  $mirror                                = 'https://mirror.mva-n.net/mariadb',
  $version                               = '107',
) {
  if ($facts['os']['family'] == 'RedHat' and $facts['os']['name'] !~ /Fedora|Amazon/) {
    class { 'mariadb_repo::rpm':
      ensure      => $ensure,
      path        => $path,
      baseurl     => $baseurl,
      mirrorlist  => $mirrorlist,
      includepkgs => $includepkgs,
      exclude     => $exclude,
      version     => $version,
    }
  } elsif $facts['os']['family'] == 'Debian' {
    class { 'mariadb_repo::apt':
      ensure  => $ensure,
      key     => $key,
      mirror  => $mirror,
      version => $version,
    }
  } else {
    notice("This MariaDB module does not support ${facts['os']['name']}.")
  }
}
