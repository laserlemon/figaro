Feature: Rails
  Background:
    Given a new Rails app
    And I add figaro as a dependency
    And I bundle
    And I create "lib/tasks/hello.rake" with:
      """
      task :hello => :environment do
        puts ["Hello", ENV["HELLO"]].compact.join(", ") << "!"
      end
      """

  Scenario: Has no application.yml
    When I run "bundle exec rake hello"
    Then the output should be "Hello!"

  Scenario: Has application.yml without requested key
    When I create "config/application.yml" with:
      """
      GOODBYE: Ruby Tuesday
      """
    And I run "bundle exec rake hello"
    Then the output should be "Hello!"

  Scenario: Has application.yml with requested key
    When I create "config/application.yml" with:
      """
      HELLO: world
      """
    And I run "bundle exec rake hello"
    Then the output should be "Hello, world!"

  @no-clobber
  Scenario: Generator creates application.yml file
    When I run "bundle exec rails g figaro:install"
    Then the "config/application.yml" file should exist
    
