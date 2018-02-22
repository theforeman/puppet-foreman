require 'spec_helper_acceptance'

describe 'remote_file works' do
  let(:pp) do
    <<-EOS
    foreman::remote_file {"/var/tmp/test":
       remote_location => "https://codeload.github.com/theforeman/puppet-foreman/tar.gz/9.0.0",
    }
    EOS
  end

  it_behaves_like 'a idempotent resource'

  describe file('/var/tmp/test') do
    its(:md5sum) { should eq '5ef89571e3775b4bc17e4f5a55d1c146' }
  end
end
