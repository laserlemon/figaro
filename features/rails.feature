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

      task :nena => :environment do
        puts [ENV["LUFTBALLOONS"], "Luftballoons"].compact.join(" ")
      end

      task :greet => :environment do
        puts ([Figaro.env.greeting] * 3).join(", ") << "!"
      end
      """

  Scenario: Has no application.yml
    When I run "rake hello"
    Then the output should be "Hello!"

  Scenario: Has application.yml without requested key
    Given I create "config/application.yml" with:
      """
      GOODBYE: Ruby Tuesday
      """
    When I run "rake hello"
    Then the output should be "Hello!"

  Scenario: Has blank application.yml
    Given I create "config/application.yml" with:
      """
      """
    When I run "rake hello"
    Then the output should be "Hello!"

  Scenario: Has commented application.yml
    Given I create "config/application.yml" with:
      """
      # Comment
      """
    When I run "rake hello"
    Then the output should be "Hello!"

  Scenario: Has ERB in application.yml
    Given I create "config/application.yml" with:
      """
      HELLO: <%= 'world' %>
      """
    When I run "rake hello"
    Then the output should be "Hello, world!"

  Scenario: Has application.yml with requested key
    Given I create "config/application.yml" with:
      """
      HELLO: world
      """
    When I run "rake hello"
    Then the output should be "Hello, world!"

  Scenario: Has application.yml with RAILS_ENV defaulting to "development"
    Given I create "config/application.yml" with:
      """
      HELLO: world
      development:
        HELLO: developers
      """
    When I run "rake hello"
    Then the output should be "Hello, developers!"

  Scenario: Has application.yml with RAILS_ENV set
    Given I create "config/application.yml" with:
      """
      HELLO: world
      development:
        HELLO: developers
      production:
        HELLO: users
      """
    When I run "rake hello RAILS_ENV=test"
    Then the output should be "Hello, world!"
    When I run "rake hello RAILS_ENV=development"
    Then the output should be "Hello, developers!"
    When I run "rake hello RAILS_ENV=production"
    Then the output should be "Hello, users!"

  Scenario: Has application.yml with non-string values
    Given I create "config/application.yml" with:
      """
      LUFTBALLOONS: 99
      """
    When I run "rake nena"
    Then the output should be "99 Luftballoons"

  Scenario: Generator creates and ignores application.yml file
    When I run "rails generate figaro:install"
    Then "config/application.yml" should exist
    And ".gitignore" should contain "/config/application.yml"

  Scenario: Generator only creates application.yml if not using Git
    Given I run "rm .gitignore"
    When I run "rails generate figaro:install"
    Then "config/application.yml" should exist
    But ".gitignore" should not exist

  Scenario: Includes Heroku Rake task
    When I run "rake --tasks figaro:heroku"
    Then the output should be "rake figaro:heroku[app]  # Configure Heroku according to application.yml"

  Scenario: Accessing values through the Figaro.env proxy
    Given I create "config/application.yml" with:
      """
      GREETING: Figaro
      """
    When I run "rake greet"
    Then the output should be "Figaro, Figaro, Figaro!"
