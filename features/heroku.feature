@heroku_config
Feature: Heroku
  Background:
    Given a new Rails app
    And I add figaro as a dependency
    And I add heroku as a dependency
    And I add figaro/tasks
    And I bundle
    And I create a new heroku app
    And I create "config/application.yml" with:
      """
      HELLO: world
      """
  Scenario: Add Config Vars
    When I execute the config task
    Then the output should contain "Adding HELLO=world to heroku app"
    And the output should contain "HELLO => world"
