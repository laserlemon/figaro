namespace :figaro do
  desc "Configure Heroku according to application.yml"
  task :heroku, [:app] => :environment do |_, args|
    Figaro::Tasks::Heroku.new(args[:app]).invoke
  end

  desc "Pull config vars from Heroku into application.yml"
  task :pull, [:app] => :environment do |_, args|
    Figaro::Tasks::Heroku.new(args[:app]).pull
  end
end