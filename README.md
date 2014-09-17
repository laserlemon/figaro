# ![Figaro](https://raw.githubusercontent.com/laserlemon/figaro/1f6e709/doc/title.png)

Simple, Heroku-friendly Rails app configuration using `ENV` and a single YAML file

[![Gem Version](https://img.shields.io/gem/v/figaro.svg?style=flat-square)](http://badge.fury.io/rb/figaro)
[![Build Status](https://img.shields.io/travis/laserlemon/figaro/master.svg?style=flat-square)](https://travis-ci.org/laserlemon/figaro)
[![Code Climate](https://img.shields.io/codeclimate/github/laserlemon/figaro.svg?style=flat-square)](https://codeclimate.com/github/laserlemon/figaro)
[![Coverage Status](https://img.shields.io/codeclimate/coverage/github/laserlemon/figaro.svg?style=flat-square)](https://codeclimate.com/github/laserlemon/figaro)
[![Dependency Status](https://img.shields.io/gemnasium/laserlemon/figaro.svg?style=flat-square)](https://gemnasium.com/laserlemon/figaro)

**NOTE:** If you're using Figaro 0.7 or prior, please refer to the [appropriate documentation](https://github.com/laserlemon/figaro/tree/0-stable#readme) or [upgrade](#how-do-i-upgrade-to-figaro-10) to Figaro 1.0.

## Why does Figaro exist?

Figaro was written to make it easy to securely configure Rails applications.

Configuration values often include sensitive information. Figaro strives to be secure by default by encouraging a convention that keeps configuration out of Git.

## How does Figaro work?

Figaro is inspired by the [Twelve-Factor App](http://12factor.net) methodology, which states:

> The twelve-factor app stores config in environment variables (often shortened to env vars or env). Env vars are easy to change between deploys without changing any code; unlike config files, there is little chance of them being checked into the code repo accidentally; and unlike custom config files, or other config mechanisms such as Java System Properties, they are a language- and OS-agnostic standard.

This is straightforward in production environments but local development environments are often shared between multiple applications, requiring multiple configurations.

Figaro parses a Git-ignored YAML file in your application and loads its values into `ENV`.

### Getting Started

Add Figaro to your Gemfile and `bundle install`:

```ruby
gem "figaro"
```

Figaro installation is easy:


```bash
$ figaro install
```

This creates a commented `config/application.yml` file and adds it to your `.gitignore`. Add your own configuration to this file and you're done!

### Example

Given the following configuration file:

```yaml
# config/application.yml

pusher_app_id: "2954"
pusher_key: "7381a978f7dd7f9a1117"
pusher_secret: "abdc3b896a0ffb85d373"
```

You can configure [Pusher](http://pusher.com) in an initializer:

```ruby
# config/initializers/pusher.rb

Pusher.app_id = ENV["pusher_app_id"]
Pusher.key    = ENV["pusher_key"]
Pusher.secret = ENV["pusher_secret"]
```

**Please note:** `ENV` is a simple key/value store. All values will be converted to strings. Deeply nested configuration structures are not possible.

### Environment-Specific Configuration

Oftentimes, local configuration values change depending on Rails environment. In such cases, you can add environment-specific values to your configuration file:

```yaml
# config/application.yml

pusher_app_id: "2954"
pusher_key: "7381a978f7dd7f9a1117"
pusher_secret: "abdc3b896a0ffb85d373"

test:
  pusher_app_id: "5112"
  pusher_key: "ad69caf9a44dcac1fb28"
  pusher_secret: "83ca7aa160fedaf3b350"
```

You can also nullify configuration values for a specific environment:

```yaml
# config/application.yml

google_analytics_key: "UA-35722661-5"

test:
  google_analytics_key: ~
```

### Using `Figaro.env`

`Figaro.env` is a convenience that acts as a proxy to `ENV`.

In testing, it is sometimes more convenient to stub and unstub `Figaro.env` than to set and reset `ENV`. Whether your application uses `ENV` or `Figaro.env` is entirely a matter of personal preference.

```yaml
# config/application.yml

stripe_api_key: "sk_live_dSqzdUq80sw9GWmuoI0qJ9rL"
```

```ruby
ENV["stripe_api_key"] # => "sk_live_dSqzdUq80sw9GWmuoI0qJ9rL"
ENV.key?("stripe_api_key") # => true
ENV["google_analytics_key"] # => nil
ENV.key?("google_analytics_key") # => false

Figaro.env.stripe_api_key # => "sk_live_dSqzdUq80sw9GWmuoI0qJ9rL"
Figaro.env.stripe_api_key? # => true
Figaro.env.google_analytics_key # => nil
Figaro.env.google_analytics_key? # => false
```

### Required Keys

If a particular configuration value is required but not set, it's appropriate to raise an error. With Figaro, you can either raise these errors proactively or lazily.

To proactively require configuration keys:

```ruby
# config/initializers/figaro.rb

Figaro.require_keys("pusher_app_id", "pusher_key", "pusher_secret")
```

If any of the configuration keys above are not set, your application will raise an error during initialization. This method is preferred because it prevents runtime errors in a production application due to improper configuration.

To require configuration keys lazily, reference the variables via "bang" methods on `Figaro.env`:

```ruby
# config/initializers/pusher.rb

Pusher.app_id = Figaro.env.pusher_app_id!
Pusher.key    = Figaro.env.pusher_key!
Pusher.secret = Figaro.env.pusher_secret!
```

### Deployment

Figaro is written with deployment in mind. In fact, [Heroku](https://www.heroku.com)'s use of `ENV` for application configuration was the original inspiration for Figaro.

#### Heroku

Heroku already makes setting application configuration easy:

```bash
$ heroku config:set google_analytics_key=UA-35722661-5
```

Using the `figaro` command, you can set values from your configuration file all at once:

```bash
$ figaro heroku:set -e production
```

For more information:

```bash
$ figaro help heroku:set
```

#### Other Hosts

If you're not deploying to Heroku, you have two options:

* Generate a remote configuration file
* Set `ENV` variables directly

Generating a remote configuration file is preferred because of:

* familiarity – Management of `config/application.yml` is like that of `config/database.yml`.
* isolation – Multiple applications on the same server will not produce configuration key collisions.

## Is Figaro like [dotenv](https://github.com/bkeepers/dotenv)?

Yes. Kind of.

Figaro and dotenv were written around the same time to solve similar problems.

### Similarities

* Both libraries are useful for Ruby application configuration.
* Both are popular and well maintained.
* Both are inspired by Twelve-Factor App's concept of proper [configuration](http://12factor.net/config).
* Both store configuration values in `ENV`.

### Differences

* Configuration File
  * Figaro expects a single file.
  * Dotenv supports separate files for each environment.
* Configuration File Format
  * Figaro expects YAML containing key/value pairs.
  * Dotenv convention is a collection of `KEY=VALUE` pairs.
* Security vs. Convenience
  * Figaro convention is to never commit configuration files.
  * Dotenv encourages committing configuration files containing development values.
* Framework Focus
  * Figaro was written with a focus on Rails development and conventions.
  * Dotenv was written to accommodate any type of Ruby application.

Either library may suit your configuration needs. It often boils down to personal preference.

## Is application.yml like [secrets.yml](https://github.com/rails/rails/blob/v4.1.0/railties/lib/rails/generators/rails/app/templates/config/secrets.yml)?

Yes. Kind of.

Rails 4.1 introduced the `secrets.yml` convention for Rails application configuration. Figaro predated the Rails 4.1 release by two years.

### Similarities

* Both are useful for Rails application configuration.
* Both are popular and well maintained.
* Both expect a single YAML file.

### Differences

* Configuration Access
  * Figaro stores configuration values in `ENV`.
  * Rails stores configuration values in `Rails.application.secrets`.
* Configuration File Structure
  * Figaro expects YAML containing key/value string pairs.
  * Secrets may contain nested structures with rich objects.
* Security vs. Convenience
  * Figaro convention is to never commit configuration files.
  * Secrets are committed by default.
* Consistency
  * Figaro uses `ENV` for configuration in every environment.
  * Secrets encourage using `ENV` for production only.
* Approach
  * Figaro is inspired by Twelve-Factor App's concept of proper [configuration](http://12factor.net/config).
  * Secrets are… not.

The emergence of a configuration convention for Rails is an important step, but as long as the last three differences above exist, Figaro will continue to be developed as a more secure, more consistent, and more standards-compliant alternative to `secrets.yml`.

For more information, read the original [The Marriage of Figaro… and Rails](http://www.collectiveidea.com/blog/archives/2013/12/18/the-marriage-of-figaro-and-rails/) blog post.

## How do I upgrade to Figaro 1.0?

In most cases, upgrading from Figaro 0.7 to 1.0 is painless. The format
expectations for `application.yml` are the same in 1.0 and values from
`application.yml` are loaded into `ENV` as they were in 0.7.

However, there are breaking changes:

### `Figaro.env`

In Figaro 0.7, calling a method on the `Figaro.env` proxy would raise an error
if a corresponding key were not set in `ENV`.

In Figaro 1.0, calling a method on `Figaro.env` corresponding to an unset key
will return `nil`. To emulate the behavior of Figaro 0.7, use "bang" methods as
described in the [Required Keys](#required-keys) section.

**NOTE:** In Figaro 0.7, `Figaro.env` inherited from `Hash` but in Figaro 1.0,
hash access has been removed.

### Heroku Configuration

In Figaro 0.7, a Rake task existed to set remote Heroku configuration according
to values in `application.yml`.

In Figaro 1.0, the Rake task was replaced by a command for the `figaro`
executable:

```bash
$ figaro heroku:set -e production
```

For more information:

```bash
$ figaro help heroku:set
```

**NOTE:** The environment option is required for the `heroku:set` command. The
Rake task in Figaro 0.7 used the default of "development" if unspecified.

## Who wrote Figaro?

My name is Steve Richert and I wrote Figaro in March, 2012 with overwhelming encouragement from my employer, [Collective Idea](http://www.collectiveidea.com). Figaro has improved very much since then, thanks entirely to [inspiration](https://github.com/laserlemon/figaro/issues) and [contribution](https://github.com/laserlemon/figaro/graphs/contributors) from developers everywhere.

**Thank you!**

## How can I help?

Figaro is open source and contributions from the community are encouraged! No contribution is too small.

See Figaro's [contribution guidelines](CONTRIBUTING.md) for more information.
