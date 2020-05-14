require 'spec_helper'

describe 'foreman_dynflow', type: :fact do
  subject { Facter.fact(:foreman_dynflow) }

  before { Facter.clear }
  after { Facter.clear }

  it { is_expected.not_to be_nil }

  describe 'without directory' do
    before do
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with('/etc/foreman/dynflow').and_return(false)
    end

    it { expect(subject.value).to be_nil }
  end

  describe 'with directory' do
    before do
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with('/etc/foreman/dynflow').and_return(true)
      allow(Dir).to receive(:[]).with('/etc/foreman/dynflow/*.yml').and_return(files)
    end

    context 'without files' do
      let(:files) { [] }

      it { expect(subject.value).to eq([]) }
    end

    context 'with single file' do
      let(:files) { ['/etc/foreman/dynflow/worker.yml'] }

      it { expect(subject.value).to eq(['worker']) }
    end

    context 'with multiple files' do
      let(:files) { ['/etc/foreman/dynflow/orchestrator.yml', '/etc/foreman/dynflow/worker.yml'] }

      it { expect(subject.value).to eq(['orchestrator', 'worker']) }
    end
  end
end
