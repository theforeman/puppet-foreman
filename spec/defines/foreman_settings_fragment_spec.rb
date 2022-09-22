require 'spec_helper'

describe 'foreman::settings_fragment' do
  let(:title) { 'myfragment' }

  context 'with string' do
    let(:params) do
      {
        content: 'mycontent',
        order: '42',
      }
    end

    it { is_expected.to compile.with_all_deps }

    it do
      is_expected.to contain_concat__fragment('foreman_settings+42-myfragment')
        .with_target('/etc/foreman/settings.yaml')
        .with_content('mycontent')
        .with_order('42')
    end
  end
end
