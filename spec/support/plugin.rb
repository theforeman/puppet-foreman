DEFAULT_OS_FACTS = on_supported_os['redhat-9-x86_64']

shared_examples 'basic foreman plugin tests' do |name|
  let(:facts) { DEFAULT_OS_FACTS }
  let(:pre_condition) { 'include foreman' }
  it { should compile.with_all_deps }
  it { should contain_foreman__plugin(name) }
end
