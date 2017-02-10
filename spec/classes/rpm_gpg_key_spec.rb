require 'spec_helper'
describe 'mariadb-repo::rpm_gpg_key' do

  context 'with default values for all parameters' do
    it { should compile }
    it { should compile.with_all_deps }
    it { should contain_class('mariadb-repo::rpm_gpg_key') }

    it { should contain_file('/etc/pki/rpm-gpg/RPM-GPG-KEY-MariaDB').with_ensure('present') }
    it { should contain_exec('import-mariadb-repo').with_command('rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-MariaDB') }
  end

  context 'with absent' do
    let(:params) do
      {
        ensure: 'absent',
      }
    end

    it { should contain_file('/etc/pki/rpm-gpg/RPM-GPG-KEY-MariaDB').with_ensure('absent') }
  end
end
