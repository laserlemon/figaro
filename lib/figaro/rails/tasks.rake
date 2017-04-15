namespace :figaro do
  desc "Configure Heroku according to application.yml"
  task :heroku, [:app] => :environment do |_, args|
    Figaro::Tasks::Heroku.new(args[:app]).invoke
  end

  desc "Configure .travis.yml according to application.yml"
  task :travis do
      system %{cat config/application.yml| grep -v \# | sed 's/:./=/' | travis encrypt --split --add}
  end
end
