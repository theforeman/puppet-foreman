require 'spec_helper'

describe 'foreman::plugin::column_view' do
  include_examples 'basic foreman plugin tests', 'column_view'

  context 'with columns hash architecture' do
    let(:params) do
      {
        'columns' => {
          'architecture' => {
            'title' => 'Architecture',
            'after' => 'last_report',
            'content' => 'facts_hash["architecture"]',
          }
        }
      }
    end

    it { is_expected.to contain_file('/etc/foreman/plugins/foreman_column_view.yaml').with_content(/.*:title: Architecture.*/) }

    it { is_expected.to compile.with_all_deps }
  end

  context 'with columns hash architecture and console' do
    let(:params) do
      {
        'columns' => {
          'architecture' => {
            'title' => 'Architecture',
            'after' => 'last_report',
            'content' => 'facts_hash["architecture"]',
          },
          'console' => {
            'title' => 'Console',
            'after' => '0',
            'content' => 'link_to(_("Console"), "https://#{host.interfaces.first.name}.domainname", { :class => "btn btn-info" } )',
	    'conditional' => ':bmc_available?',
	    'eval_content' => 'true',
	    'view' => ':hosts_properties',
          }
        }
      }
    end

    it { is_expected.to contain_file('/etc/foreman/plugins/foreman_column_view.yaml').with_content(/.*:title: Console.*/) }

    it { is_expected.to compile.with_all_deps }
  end

  context 'with columns hash broken' do
    let(:params) do
      {
        'columns' => {
          'broken' => {
            'title' => 'Broken',
          }
        }
      }
    end

    it { is_expected.to compile.and_raise_error(%r{broken}) }
  end
end
