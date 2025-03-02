# @summary
#  Import the RPM GPG key for the MariaDB repository.
#
# @param path
#   The path to the RPM-GPG-KEY-MariaDB file to manage. Must be an absolute path.
#
class mariadb_repo::rpm_gpg_key (
  String $path = '/etc/pki/rpm-gpg/RPM-GPG-KEY-MariaDB',
) {
  file { $path:
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/mariadb_repo/RPM-GPG-KEY-MariaDB',
    before => Exec['import-mariadb_repo'],
  }

  exec { 'import-mariadb_repo':
    command => "rpm --import ${path}",
    path    => ['/bin', '/usr/bin'],
    unless  => "rpm -q gpg-pubkey-$(gpg --throw-keyids ${path} | grep pub | cut -c 12-19 | tr '[A-Z]' '[a-z]' | tail -n1)",
  }
}
