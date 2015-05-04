require 'thor'

module Figaro
  class CLI < Thor
    # figaro install

    desc 'install', 'Install Figaro'

    method_option 'path',
                  aliases: ['-p'],
                  default: 'config/application.yml',
                  desc: 'Specify a configuration file path'

    def install
      require 'figaro/cli/install'
      Install.start
    end

    # figaro heroku:set

    desc 'heroku:set', 'Send Figaro configuration to Heroku'

    method_option 'app',
                  aliases: ['-a'],
                  desc: 'Specify a Heroku app'
    method_option 'environment',
                  aliases: ['-e'],
                  desc: 'Specify an application environment'
    method_option 'path',
                  aliases: ['-p'],
                  default: 'config/application.yml',
                  desc: 'Specify a configuration file path'
    method_option 'remote',
                  desc: 'Specify a Heroku git remote'

    define_method 'heroku:set' do
      require 'figaro/cli/heroku_set'
      HerokuSet.run(options)
    end

    # figaro eb:set

    desc 'eb:set', 'Send Figaro configuration to Elasticbeanstalk'

    method_option 'env',
                  desc: 'Specify an Amazon Elasticbeanstalk application environment'
    method_option 'profile',
                  desc: 'Specify an AWS profile'
    method_option 'verbose',
                  aliases: ['-v'],
                  desc: 'Toggle verbose output',
                  type: :boolean,
                  default: false
    method_option 'environment',
                  aliases: ['-e'],
                  desc: 'Specify an application environment'
    method_option 'path',
                  aliases: ['-p'],
                  default: 'config/application.yml',
                  desc: 'Specify a configuration file path'

    define_method 'eb:set' do
      require 'figaro/cli/eb_set'
      EbSet.run(options)
    end
  end
end
