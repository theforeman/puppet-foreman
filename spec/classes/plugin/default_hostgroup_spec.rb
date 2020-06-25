require 'spec_helper'

describe 'foreman::plugin::default_hostgroup' do
  include_examples 'basic foreman plugin tests', 'default_hostgroup'

  context 'with user provided config hash' do
    let(:params) do
      {
        :hostgroups => [
          'Redhat' => {
            'osfamily'=> 'RedHat',
            'lsbdistcodename' => 'Santiago',
          },
          'Osx/common' => {
            'osfamily' => 'Darwin',
          },
          'Base' => {
            'hostname' => '.*'
          }
        ]
      }
    end

hostgroups = <<EOF
---
:default_hostgroup:
  :facts_map:
    'Redhat':
      'lsbdistcodename': 'Santiago'
      'osfamily': 'RedHat'
    'Osx/common':
      'osfamily': 'Darwin'
    'Base':
      'hostname': '.*'
EOF

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_file('/etc/foreman/plugins/default_hostgroup.yaml').with_content(hostgroups) }
  end

  context 'no config hash' do
    it { is_expected.not_to contain_file('/etc/foreman/plugins/default_hostgroup.yaml') }
  end
end

