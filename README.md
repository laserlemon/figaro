# Figaro
[![Gem Version](https://badge.fury.io/rb/figaro.png)](http://badge.fury.io/rb/figaro)
[![Build Status](https://travis-ci.org/laserlemon/figaro.png?branch=master)](https://travis-ci.org/laserlemon/figaro)
[![Code Climate](https://codeclimate.com/github/laserlemon/figaro.png)](https://codeclimate.com/github/laserlemon/figaro)
[![Coverage Status](https://coveralls.io/repos/laserlemon/figaro/badge.png?branch=master)](https://coveralls.io/r/laserlemon/figaro)
[![Dependency Status](https://gemnasium.com/laserlemon/figaro.png)](https://gemnasium.com/laserlemon/figaro)

Simple Rails app configuration

## What is this for?

Figaro is for configuring Rails (3 and 4) apps, especially open source Rails apps.

Open sourcing a Rails app can be a little tricky when it comes to sensitive configuration information like [Pusher](http://pusher.com/) or [Stripe](https://stripe.com/) credentials. You don't want to check private credentials into the repo but what other choice is there?

Figaro provides a clean and simple way to configure your app and keep the private stuff… private.

## How does it work?

There are a few similar solutions out there, and a lot of homegrown attempts. Most namespace your configuration under a `Config` (or similar) namespace. That's fine, but there's already a place to describe the application environment… `ENV`!

`ENV` is a collection of simple string key/value pairs and it works just great for application configuration.

As an added bonus, this is exactly how apps on [Heroku](http://www.heroku.com/) are configured. So if you configure your Rails app using `ENV`, you're already set to deploy to Heroku.

## Give me an example.

Okay. Add Figaro to your Gemfile and run the `bundle` command to install it:

```ruby
gem "figaro"
```

Next up, use the generator provided by Figaro:

```bash
rails generate figaro:install
```

This creates a commented `config/application.yml` file and ignores it in your `.gitignore`. Add your own configuration to this file and you're done!

Your configuration will be available as key/value pairs in `ENV`. For example, here's `config/initializers/pusher.rb`:

```ruby
Pusher.app_id = ENV["PUSHER_APP_ID"]
Pusher.key    = ENV["PUSHER_KEY"]
Pusher.secret = ENV["PUSHER_SECRET"]
```

In addition, you can access these same configuration values through Figaro itself:

```ruby
Pusher.app_id = Figaro.env.pusher_app_id
Pusher.key    = Figaro.env.pusher_key
Pusher.secret = Figaro.env.pusher_secret
```

But wait… I thought configuration via constant was bad! Well, this is different. Rather than storing a _copy_ of `ENV` internally, `Figaro.env` passes directly through to `ENV`, making it just like using `ENV` itself. So why two approaches? Having your configurations available via method calls makes it easy to stub them out in tests. Either way is fine. The choice is yours!

If your app requires Rails-environment-specific configuration, you can also namespace your configuration under a key for `Rails.env`.

```yaml
HELLO: world
development:
  HELLO: developers
production:
  HELLO: users
```

In this case, `ENV["HELLO"]` will produce `"developers"` in development, `"users"` in production and `"world"` otherwise.

## How does it work with Heroku?

Heroku's beautifully simple application configuration was the [inspiration](http://laserlemon.com/blog/2011/03/08/heroku-friendly-application-configuration/) for Figaro.

Typically, to configure your application `ENV` on Heroku, you would do the following from the command line using the `heroku` gem:

```bash
heroku config:add PUSHER_APP_ID=8926
heroku config:add PUSHER_KEY=0463644d89a340ff1132
heroku config:add PUSHER_SECRET=0eadfd9847769f94367b
heroku config:add STRIPE_API_KEY=jHXKPPE0dUW84xJNYzn6CdWM2JfrCbPE
heroku config:add STRIPE_PUBLIC_KEY=pk_HHtUKJwlN7USCT6nE5jiXgoduiNl3
```

But Figaro provides a rake task to do just that! Just run:

```bash
rake figaro:heroku
```

Optionally, you can pass in the name of the Heroku app:

```bash
rake figaro:heroku[my-awesome-app]
```

Additionally, if `RAILS_ENV` is configured on your Heroku server, Figaro will use that environment automatically in determining your proper configuration.

## What if I'm not using Heroku?

No problem. Just add `config/application.yml` to your production app on the server.

## This sucks. How can I make it better?

1. Fork it.
2. Make it better.
3. Send me a pull request.

## Does Figaro have a mascot?

Yes.

[![Figaro](http://images2.wikia.nocookie.net/__cb20100628192722/disney/images/5/53/Pinocchio-pinocchio-4947890-960-720.jpg "Figaro's mascot: Figaro")](http://en.wikipedia.org/wiki/Figaro_(Disney\))
