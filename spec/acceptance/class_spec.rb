require 'spec_helper_acceptance'

describe 'mariadb_repo class' do
  let(:manifest) do
    <<-EOS
    require 'mariadb_repo'

    package { 'MariaDB-client':
      ensure          => installed,
      install_options => ['--enablerepo=MariaDB101'],
    }
    EOS
  end

  it 'should work without errors' do
    result = apply_manifest(manifest, :acceptable_exit_codes => [0, 2], :catch_failures => true)
    expect(result.exit_code).not_to eq 4
    expect(result.exit_code).not_to eq 6
  end

  it 'should run a second time without changes' do
    result = apply_manifest(manifest)
    expect(result.exit_code).to eq 0
  end

  describe file('/etc/pki/rpm-gpg/RPM-GPG-KEY-MariaDB') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
  end

  %w(
    MariaDB55
    MariaDB100
    MariaDB101
    MariaDB102
  ).each do |repo|
    describe yumrepo(repo) do
      it { should exist }
      it { should_not be_enabled }
    end
  end

  describe package('MariaDB-client') do
    it { should be_installed }
  end

  describe command('mysql -V') do
    its(:stdout) { should match /Distrib 10.1.\d+-MariaDB/ }
  end
end
