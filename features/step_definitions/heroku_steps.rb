Then /^the output should contain "([^"]*)"$/ do |output|
  assert_partial_output(output, output_from(@commands.last).strip)
end

Given /^I create a new heroku app$/ do
  run_simple("bundle exec heroku create --stack cedar #{@herokuapp}")
end

When "I add figaro/tasks" do
  append_to_file("Rakefile", %(require 'figaro/tasks'))
end

When "I execute the config task" do
  run_simple("bundle exec rake figaro:heroku:config[#{@herokuapp}]")
end
