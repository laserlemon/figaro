## 1.1.1 / 2015-04-30

* [BUGFIX] Fix crash when environment-specific configuration is `nil`

## 1.1.0 / 2015-01-27

* [FEATURE] Support --remote when setting Heroku configuration
* [ENHANCEMENT] Test against Rails 4.2 (stable)

## 1.0.0 / 2014-09-17

* [BUGFIX] Make calls to Heroku with a clean Bundler environment
* [ENHANCEMENT] Remove Rails as a runtime dependency
* [FEATURE] Replace the Rails generator with the `figaro install` task
* [ENHANCEMENT] Rename the `Figaro.require` method to `Figaro.require_keys`
* [ENHANCEMENT] Begin to test against Rails 4.2 (beta)

## 1.0.0.rc1 / 2014-04-17

* [FEATURE] Add bang and boolean methods to `Figaro.env`
* [ENHANCEMENT] Detach `Figaro.env` from the configuration file hash
* [FEATURE] Add the ability to swap Figaro's application adapter
* [FEATURE] Warn when configuration keys or values are not strings
* [FEATURE] Enable Figaro to load multiple times, overwriting previous values
* [FEATURE] Load Figaro configuration prior to database configuration
* [ENHANCEMENT] Test against Ruby 2.1
* [ENHANCEMENT] Test against Rails 4.1
* [FEATURE] Replace Rake task with `figaro` executable
* [BUGFIX] Fix character escaping for `figaro heroku:set` on Windows
* [FEATURE] Warn when a preexisting configuration key is skipped during load
* [FEATURE] Add the ability to fail fast in the absence of required keys
* [FEATURE] Tie into Rails' earliest possible `before_configuration` hook

## 0.7.0 / 2013-06-27

* [FEATURE] Allow configuration values to be overridden on the system level
* [FEATURE] Enable ERB evaluation of the configuration file

## 0.6.4 / 2013-05-01

* [BUGFIX] Make the configuration file path platform-independent
* [FEATURE] Make `Figaro.env` proxy method calls case-insensitive

## 0.6.3 / 2013-03-10

* [BUGFIX] Run Heroku commands with a clean Bundler environment

## 0.6.2 / 2013-03-07

* [ENHANCEMENT] Refactor `figaro:heroku` task into a unit-tested class
* [ENHANCEMENT] Relax development gem dependency version requirements
* [ENHANCEMENT] Track test coverage

## 0.6.1 / 2013-02-27

* [ENHANCEMENT] Declare development gem dependencies in gemfiles
* [BUGFIX] Cast boolean configuration values to strings
* [ENHANCEMENT] Use RSpec `expect` syntax

## 0.6.0 / 2013-02-26

* [ENHANCEMENT] Test against Ruby 2.0.0
* [ENHANCEMENT] Test against Rails 4.0

## 0.5.4 / 2013-02-22

* [ENHANCEMENT] GitHub Ruby Styleguide conventions
* [ENHANCEMENT] Remove unnecessary development dependencies
* [FEATURE] Allow `nil` values in `Figaro.env`

## 0.5.3 / 2013-01-12

* [BUGFIX] Fix `figaro:heroku` to properly capture standard output... again

## 0.5.2 / 2013-01-07

* [BUGFIX] Escape special characters in the `figaro:heroku` task

## 0.5.1 / 2013-01-07

* [BUGFIX] Fix `figaro:heroku` to properly capture standard output

## 0.5.0 / 2012-10-28

* [BUGFIX] Automatically cast configuration keys and values to strings
* [FEATURE] Allow the `figaro:heroku` task to respect remote Rails environment
* [FEATURE] Enable `Figaro.env` to act as a proxy to `ENV`

## 0.4.1 / 2012-04-25

* [BUGFIX] Fix `figaro:heroku` Rake task failures

## 0.4.0 / 2012-04-20

* [FEATURE] Allow environment-specific configuration

## 0.3.0 / 2012-04-20

* [ENHANCEMENT] Refactor the loading configuration into `ENV`
* [FEATURE] Add `figaro:heroku` Rake task

## 0.2.0 / 2012-04-03

* [ENHANCEMENT] Test against multiple Rails versions (3.0, 3.1, 3.2)
* [FEATURE] Add `figaro:install` Rails generator
* [BUGFIX] Gracefully parse YAML files containing only comments

## 0.1.1 / 2012-04-02

* [ENHANCEMENT] Remove RSpec development gem dependency
* [ENHANCEMENT] Introduce Figaro, the mascot

## 0.1.0 / 2012-04-02

* Initial release!
