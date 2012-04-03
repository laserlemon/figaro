When /^I create "([^"]+)" with:$/ do |path, content|
  write_file(path, content)
end

When /^I run "([^"]+)"$/ do |command|
  run_simple(command)
end

Then /^the output should be "([^"]*)"$/ do |output|
  assert_exact_output(output, output_from(@commands.last).strip)
end

Then /^the "([^"]*)" file should exist$/ do |filename|
  File.should exist(File.join(current_dir, filename))
end
