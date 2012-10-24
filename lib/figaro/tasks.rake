namespace :figaro do
  def run_it(config_cmd, app_option, test, app_name=nil)
    vars = Figaro.env.map { |k,v| v=v.to_s; "#{k}=#{v[" "] ? '"'+ v +'"' : v}" }.sort.join(" ")
    command = "#{config_cmd} #{vars}"
    command << " #{app_option} #{app_name}" unless app_name.nil?
    command = "echo " + command.gsub('"','\\"') if test
    Kernel.system(command)
  end

  desc "Configure Heroku according to application.yml"
  task :heroku, [:app] => :environment do |_, args|
    run_it("heroku config:add", "--app", false, args[:app])
  end

  desc "Configure Cloudbees according to application.yml"
  task :cloudbees, [:app] => :environment do |_, args|
    run_it("bees config:set", "-a", false, args[:app])
  end

  desc "Echo configuration commands for heroku but dont run them"
  task :test_heroku, [:app] => :environment do |_, args|
    run_it("heroku config:add", "--app", true, args[:app])
  end

  desc "Echo configuration commands for Cloudbees but dont run them"
  task :test_cloudbees, [:app] =>:environment do |_, args|
    run_it("bees config:set", "-a", true, args[:app])
  end

end
