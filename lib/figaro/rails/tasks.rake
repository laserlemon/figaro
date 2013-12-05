namespace :figaro do
  desc "Configure Heroku according to application.yml"
  task :heroku, [:app] => :environment do |_, args|
    Figaro::Tasks::Heroku.new(args[:app]).invoke
  end

  namespace :heroku do
    desc "Show the changes that will be made to Heroku according to application.yml"
    task :show, [:app] => :environment do |_, args|
      Figaro::Tasks::Heroku.new(args[:app]).show
    end

    desc "Compare Heroku config to that from application.yml"
    task :diff, [:app] => :environment do |_, args|
      Figaro::Tasks::Heroku.new(args[:app]).diff
    end
  end
end
