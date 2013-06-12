require 'spec_helper'

describe 'foreman' do
  let(:facts) { { 'hardwaremodel' => 'x86_64'} }
  let(:node) { 'test.example.com' }
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  pending "due to Puppet #4549 on 2.6", :if => Facter.puppetversion =~ /^2\.6/ do
    it 'should exist' do
      Puppet::Parser::Functions.function('foreman').should == 'function_foreman'
    end

    it 'should throw an error with no arguments' do
      lambda {
        scope.function_foreman([])
      }.should(raise_error(Puppet::ParseError))
    end
  end

  # TODO: Test functionality of the actual function.

end
