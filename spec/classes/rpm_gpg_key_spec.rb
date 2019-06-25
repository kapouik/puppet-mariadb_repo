require 'spec_helper'
describe 'mariadb_repo::rpm_gpg_key' do
  context 'with default values for all parameters' do
    it { is_expected.to compile }
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('mariadb_repo::rpm_gpg_key') }

    it { is_expected.to contain_file('/etc/pki/rpm-gpg/RPM-GPG-KEY-MariaDB').with_ensure('present') }
    it { is_expected.to contain_exec('import-mariadb_repo').with_command('rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-MariaDB') }
  end

  context 'with absent' do
    let(:params) do
      {
        ensure: 'absent',
      }
    end

    it { is_expected.to contain_file('/etc/pki/rpm-gpg/RPM-GPG-KEY-MariaDB').with_ensure('absent') }
  end
end
