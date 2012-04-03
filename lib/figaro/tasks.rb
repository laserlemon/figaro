namespace :figaro do
  namespace :heroku do
    task :config, :app  do |t, args|
      desc "Add values in application.yml to heroku ENV. Takes an optional app name as [someapp]"

      path = Rails.root.join("config/application.yml")
      Rake::Task['figaro:heroku:add_config_vars_to_heroku'].invoke(args[:app], path)
    end

    task :add_config_vars_to_heroku, :app, :path do |t, args|
      config = YAML.load_file(args[:path]) if File.exist?(args[:path])
      config_vars = []

      config.each do |key, value|
        config_vars << "#{key.upcase}=#{value}"
      end

      puts "Adding #{config_vars.join(" ")} to heroku app"

      if args[:app]
        system "heroku config:add #{config_vars.join(" ")} --app #{args[:app]}"
      else
        system "heroku config:add #{config_vars.join(" ")}"
      end

      puts "Configuration Complete"
    end
  end
end

