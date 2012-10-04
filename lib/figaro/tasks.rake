namespace :figaro do
  desc "Configure Heroku according to application.yml"
  task :heroku, [:app] => :environment do |_, args|
    vars = Figaro.env.map{|k,v| "#{k}=#{v}" }.sort.join(" ")
    command = "heroku config:add #{vars}"
    command << " --app #{args[:app]}" if args[:app]
    Kernel.system(command)
  end

  desc "Configure Cloudbees according to application.yml"
  task :cloudbees, [:app] => :environment do |_, args|
    vars = Figaro.env.map{|k,v| "#{k}=#{v}" }.sort.join(" ")
    command = "bees config:set #{vars}"
    command << " -a #{args[:app]}" if args[:app]
    Kernel.system(command)
  end

end
