# puppet-mariadb-repo

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with mariadb_repo](#setup)
    * [Beginning with mariadb_repo](#beginning-with-mariadb_repo)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)
1. [Thanks](#thanks)

## Description

This module configure [MariaDB's RPM repository](http://downloads.mariadb.org/mariadb/repositories/) Rhel/Centos and import RPM-GPG-KEY-MariaDB.

## Setup

### Beginning with mariadb_repo

To configure the MariaDB repository with default parameters, declare the `mariadb_repo` class.

```puppet
include mariadb_repo
```

## Usage

### Configuring mariadb_repo

```puppet
class { 'mariadb_repo':
  mariadb101_enabled  => 1,
}
```

### Configuring modules from Hiera

```yaml
---
mariadb_repo::mariadb101_enabled: 1
```

## Reference

### Classes

#### Public Classes

- [`mariadb_repo`](#mariadb_repo):  Configure the MariaDB repository and import the GPG keys.

#### Private Classes

- `mariadb_repo::rpm_gpg_key`: Import the RPM GPG key for the MariaDB.

### Parameters

#### mariadb_repo

- `ensure`: Whether the RPM-GPG-KEY-MariaDB file should exist. Default to present.
- `path`: The path to the RPM-GPG-KEY-MariaDB file to manage. Must be an absolute path. Default to '/etc/pki/rpm-gpg/RPM-GPG-KEY-MariaDB'.

## Limitations

This module has been tested on:

- RedHat Enterprise Linux 5, 6, 7
- CentOS 5, 6, 7
- Scientific Linux 5, 6, 7

## Development

### Running tests

The STNS puppet module contains tests for both [rspec-puppet](http://rspec-puppet.com/) (unit tests) and [beaker-rspec](https://github.com/puppetlabs/beaker-rspec) (acceptance tests) to verify functionality. For detailed information on using these tools, please see their respective documentation.

#### Testing quickstart

- Unit tests:

```console
$ bundle install
$ bundle exec rake lint
$ bundle exec rake validate
$ bundle exec rake spec
```

- Acceptance tests:

```console
# Set your DOCKER_HOST variable
$ eval "$(docker-machine env default)"

# Run beaker acceptance tests
$ BEAKER_set=centos7 bundle exec rake beaker
```

## Thanks

This module is based on [hfm/puppet-remi](https://github.com/hfm/puppet-remi)
