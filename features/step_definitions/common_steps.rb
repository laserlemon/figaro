When /^I create "([^"]+)" with:$/ do |path, content|
  write_file(path, content)
end

When /^I run "([^"]+)"$/ do |command|
  run_simple(command)
end

Then /^the output should be "([^"]*)"$/ do |output|
  assert_exact_output(output, output_from(@commands.last).strip)
end

Then /^"([^"]+)" should ?(not)? exist$/ do |path, negative|
  check_file_presence([path], !negative)
end

Then /^"([^"]+)" should contain "([^"]*)"$/ do |path, content|
  check_file_content(path, content, true)
end
