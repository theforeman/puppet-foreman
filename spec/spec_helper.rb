# This file is managed centrally by modulesync
#   https://github.com/theforeman/foreman-installer-modulesync

require 'voxpupuli/test/spec_helper'

def get_content(subject, title)
  is_expected.to contain_file(title)
  content = subject.resource('file', title).send(:parameters)[:content]
  content.split(/\n/).reject { |line| line =~ /(^#|^$|^\s+#)/ }
end

def verify_exact_contents(subject, title, expected_lines)
  expect(get_content(subject, title)).to match_array(expected_lines)
end

def verify_concat_fragment_contents(subject, title, expected_lines)
  is_expected.to contain_concat__fragment(title)
  content = subject.resource('concat::fragment', title).send(:parameters)[:content]
  expect(content.split("\n") & expected_lines).to match_array(expected_lines)
end

def verify_concat_fragment_exact_contents(subject, title, expected_lines)
  is_expected.to contain_concat__fragment(title)
  content = subject.resource('concat::fragment', title).send(:parameters)[:content]
  expect(content.split(/\n/).reject { |line| line =~ /(^#|^$|^\s+#)/ }).to match_array(expected_lines)
end

Dir["./spec/support/**/*.rb"].sort.each { |f| require f }
