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

  it 'work without errors' do
    result = apply_manifest(manifest, acceptable_exit_codes: [0, 2], catch_failures: true)
    expect(result.exit_code).not_to eq 4
    expect(result.exit_code).not_to eq 6
  end

  it 'run a second time without changes' do
    result = apply_manifest(manifest)
    expect(result.exit_code).to eq 0
  end

  describe file('/etc/pki/rpm-gpg/RPM-GPG-KEY-MariaDB') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode 644 }
  end

  ['MariaDB55', 'MariaDB100', 'MariaDB101', 'MariaDB102', 'MariaDB103', 'MariaDB104'].each do |repo|
    describe yumrepo(repo) do
      it { is_expected.to exist }
      it { is_expected.not_to be_enabled }
    end
  end

  describe package('MariaDB-client') do
    it { is_expected.to be_installed }
  end

  describe command('mysql -V') do
    its(:stdout) { is_expected.to match %r{^Distrib 10.1.\d+-MariaDB} }
  end
end
