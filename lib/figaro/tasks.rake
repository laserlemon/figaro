namespace :figaro do
  desc "Configure Heroku according to application.yml"
  task :heroku, [:app] => :environment do |_, args|
    heroku_env = `heroku config:get RAILS_ENV`.chomp
    Figaro.environment = heroku_env
    vars = Figaro.env.map{|k,v| "#{k}=#{v}" }.sort.join(" ")
    command = "heroku config:add #{vars}"
    command << " --app #{args[:app]}" if args[:app]
    Kernel.system(command)
  end
end
