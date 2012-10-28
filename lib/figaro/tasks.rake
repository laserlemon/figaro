namespace :figaro do
  desc "Configure Heroku according to application.yml"
  task :heroku, [:app] => :environment do |_, args|
    app = args[:app] ? " --app #{args[:app]}" : ""
    rails_env = Kernel.system("heroku config:get RAILS_ENV#{app}").presence
    Rails.env = rails_env if rails_env
    Kernel.system("heroku config:add #{Figaro.vars}#{app}")
  end
end
