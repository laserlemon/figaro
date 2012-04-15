When "I add figaro as a dependency" do
  append_to_file("Gemfile", %(gem "figaro", path: "#{ROOT}"))
end

When "I add heroku as a dependency" do
  append_to_file("Gemfile", %(source "https://rubygems.org"))
  append_to_file("Gemfile", %(gem "heroku"))
end

When "I bundle" do
  run_simple("bundle install")
end
