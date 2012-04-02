Given "a new Rails app" do
  run_simple("bundle exec rails new example --skip-bundle --skip-git --skip-active-record --skip-sprockets --skip-javascript --skip-test-unit")
  cd("example")
end
