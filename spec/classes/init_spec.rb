require 'spec_helper'
describe 'mariadb_repo' do
  on_supported_os.each do |os, facts|
    context "with default values for all parameters on #{os}" do
      let(:facts) do
        facts
      end

      it { should compile }
      it { should compile.with_all_deps }
      it { should contain_class('mariadb_repo') }
    end
  end
end
