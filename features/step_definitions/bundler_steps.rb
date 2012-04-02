When "I add figaro as a dependency" do
  append_to_file("Gemfile", %(gem "figaro", path: "#{ROOT}"))
end

When "I bundle" do
  run_simple("bundle install")
end
