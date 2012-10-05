namespace :figaro do
  def run_it(config_cmd, app_option, test, app_name=nil)
    vars = Figaro.env.map{|k,v| "#{k}=#{v}" }.sort.join(" ")
    command = "#{config_cmd} #{vars}"
    command << " #{app_option} #{app_name}" unless app_name.nil?
    command = "echo " + command if test
    Kernel.system(command)
  end

  desc "Configure Heroku according to application.yml"
  task :heroku, [:app] => :environment do |_, args|
    run_it("heroku config:add", "--app", false, args[:app])
  end

  desc "Echo configuration commands for heroku but dont run them"
  task :heroku_test, [:app] => :environment do |_, args|
    run_it("heroku config:add", "--app", true, args[:app])
  end

  desc "Configure Cloudbees according to application.yml"
  task :cloudbees, [:app] => :environment do |_, args|
    run_it("bees config:set", "-a", false, args[:app])
  end

  desc "Echo configuration commands for Cloudbees but dont run them"
  task :cloudbees_test, [:app] =>:environment do |_, args|
    run_it("bees config:set", "-a", true, args[:app])
  end

end
