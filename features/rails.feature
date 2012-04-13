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

  Scenario: Has blank application.yml
    When I create "config/application.yml" with:
      """
      """
    And I run "bundle exec rake hello"
    Then the output should be "Hello!"

  Scenario: Has commented application.yml
    When I create "config/application.yml" with:
      """
      # Comment
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

  Scenario: Has application.yml with a RAILS_ENV
    When I create "config/application.yml" with:
    """
    HELLO: world
    development:
      HELLO: party
    """
    And I run "bundle exec rake hello RAILS_ENV=development"
    Then the output should be "Hello, party!"

  Scenario: Has application.yml without a RAILS_ENV, but has env variables set
    When I create "config/application.yml" with:
    """
    HELLO: world
    development:
      HELLO: party
    """
    And I run "bundle exec rake hello"
    Then the output should be "Hello, world!"

  Scenario: Has application.yml with a RAILS_ENV, with multiple envs configured.
    When I create "config/application.yml" with:
    """
    HELLO: world
    development:
      HELLO: party
    production:
      HELLO: mom
    """
    And I run "bundle exec rake hello RAILS_ENV=development"
    Then the output should be "Hello, party!"

  Scenario: Generator creates and ignores application.yml file
    When I run "bundle exec rails generate figaro:install"
    Then "config/application.yml" should exist
    And ".gitignore" should contain "/config/application.yml"

  Scenario: Generator only creates application.yml if not using Git
    Given I run "rm .gitignore"
    When I run "bundle exec rails generate figaro:install"
    Then "config/application.yml" should exist
    But ".gitignore" should not exist
