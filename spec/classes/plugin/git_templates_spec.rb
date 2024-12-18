require 'spec_helper'

describe 'foreman::plugin::git_templates' do
  let(:params) { {} }
  include_examples 'basic foreman plugin tests', 'git_templates'
end
