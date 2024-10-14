DEFAULT_OS_FACTS = on_supported_os['redhat-8-x86_64']

shared_examples 'basic foreman plugin tests' do |name|
  let(:facts) { DEFAULT_OS_FACTS }
  let(:pre_condition) { 'include foreman' }
  it { should compile.with_all_deps }
  it { should contain_foreman__plugin(name) }

  context 'with ensure = 1.2.3-4' do
    let(:params) do
      super().merge(ensure: '1.2.3-4')
    end

    it do
      should contain_foreman__plugin(name)
        .with_version('1.2.3-4')
    end
  end
end
