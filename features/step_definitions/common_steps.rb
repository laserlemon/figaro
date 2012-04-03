When /^I create "([^"]+)" with:$/ do |path, content|
  write_file(path, content)
end

When /^I run "([^"]+)"$/ do |command|
  run_simple(command)
end

Then /^the output should be "([^"]*)"$/ do |output|
  assert_exact_output(output, output_from(@commands.last).strip)
end

Then /^"([^"]+)" should exist$/ do |path|
  check_file_presence([path], true)
end
