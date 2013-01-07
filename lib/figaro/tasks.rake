namespace :figaro do
  desc "Configure Heroku according to application.yml"
  task :heroku, [:app] => :environment do |_, args|
    Figaro::Tasks.heroku(args[:app])
  end
end
