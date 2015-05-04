def verify_exact_contents(subject, title, expected_lines)
  content = subject.resource('file', title).send(:parameters)[:content]
  expect(content.split(/\n/).reject { |l| l =~ /(^#|^$|^\s+#)/ }).to eq(expected_lines)
end
