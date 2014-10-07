require 'spec_helper'
require 'yaml'

describe 'foreman_report_processor' do
  yaml_text = <<-EOF
---
:url: "http://localhost:3000"
:facts: true
:puppet_home: "/var/lib/puppet"
  EOF
  yaml = YAML.load(yaml_text)
  YAML.stubs(:load_file).with("/etc/puppet/foreman.yaml").returns(yaml)
  eval File.read(File.join(File.dirname(__FILE__), '../..', 'files', 'foreman-report_v2.rb'))
  let(:processor) { Puppet::Reports.report(:foreman) }

  describe "making a connection" do
    subject { YAML.load_file("#{static_fixture_path}/report-format-0.yaml").extend(processor) }
    it "should connect to the URL in the processor" do
      stub = stub_request(:post, "http://localhost:3000/api/reports")
      subject.process
      stub.should have_been_requested
    end
  end

  describe "Puppet Report Format 0" do
    subject { YAML.load_file("#{static_fixture_path}/report-format-0.yaml").extend(processor) }
    it {
      subject.generate_report.
      should eql(JSON.parse(File.read("#{static_fixture_path}/report-format-0.json")))
    }
  end

  describe "Puppet Report Format 1" do
    subject { YAML.load_file("#{static_fixture_path}/report-format-1.yaml").extend(processor) }
    it {
      subject.generate_report.
        should eql(JSON.parse(File.read("#{static_fixture_path}/report-format-1.json")))
    }
  end

  describe "Puppet Report Format 2" do
    subject { YAML.load_file("#{static_fixture_path}/report-format-2.yaml").extend(processor) }
    it {
      subject.generate_report.
        should eql(JSON.parse(File.read("#{static_fixture_path}/report-format-2.json")))
    }
  end

  describe "Puppet Report Format 3" do
    subject { YAML.load_file("#{static_fixture_path}/report-format-3.yaml").extend(processor) }
    it {
      subject.generate_report.
        should eql(JSON.parse(File.read("#{static_fixture_path}/report-format-3.json")))
    }
  end

  describe "report should support failure metrics" do
    subject { YAML.load_file("#{static_fixture_path}/report-2.6.5-errors.yaml").extend(processor) }
    it {
      subject.generate_report['status']['failed'].should eql(3)
    }
  end

  describe "report should not support noops" do
    subject { YAML.load_file("#{static_fixture_path}/report-2.6.12-noops.yaml").extend(processor) }
    it {
      subject.generate_report['status']['pending'].should eql(10)
    }
  end

  describe "empty reports have the correct format" do
    subject { YAML.load_file("#{static_fixture_path}/report-empty.yaml").extend(processor) }
    it {
      subject.generate_report.
        should eql(JSON.parse(File.read("#{static_fixture_path}/report-empty.json")))
    }
  end

  describe "report should not include finished_catalog_run messages" do
    subject { YAML.load_file("#{static_fixture_path}/report-2.6.12-noops.yaml").extend(processor) }
    it {
      subject.generate_report['logs'].map { |l| l['log']['messages']['message']}.to_s.
      should_not match /Finished catalog run in/
    }
  end

  describe "report should not include debug level messages" do
    subject { YAML.load_file("#{static_fixture_path}/report-2.6.2-debug.yaml").extend(processor) }
    it {
      subject.generate_report['logs'].map { |l| l['log']['level']}.to_s.
      should_not match /debug/
    }
  end

  describe "report should show failure metrics for failed catalog fetches" do
    subject { YAML.load_file("#{static_fixture_path}/report-3.5.1-catalog-errors.yaml").extend(processor) }
    it {
      subject.generate_report['status']['failed'].should eql(1)
    }
  end

  describe "report should properly bypass log processor changes" do
    subject { YAML.load_file("#{static_fixture_path}/report-log-preprocessed.yaml").extend(processor) }
    it {
      subject.generate_report['status']['failed'].should eql(1)
    }
  end

  # TODO: check debug logs are filtered

  # Normally we wouldn't include commented code, but this is a handy way
  # of seeing what the report processor generates for a given YAML input
  #
  #describe "foo" do
  #  subject { YAML.load_file("#{yamldir}/report-format-1.yaml").extend(processor) }
  #  it { puts JSON.pretty_generate(subject.generate_report) }
  #end

end
