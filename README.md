# Figaro [![Build Status](https://secure.travis-ci.org/laserlemon/figaro.png)](http://travis-ci.org/laserlemon/figaro) [![Dependency Status](https://gemnasium.com/laserlemon/figaro.png)](https://gemnasium.com/laserlemon/figaro)

Simple Rails app configuration

## What is this for?

Figaro is for configuring Rails 3 apps, especially open source Rails apps.

Open sourcing a Rails app can be a little tricky when it comes to sensitive configuration information like [Pusher](http://pusher.com/) or [Stripe](https://stripe.com/) credentials. You don't want to check private credentials into the repo but what other choice is there?

Figaro provides a clean and simple way to configure your app and keep the private stuff… private.

## How does it work?

It works really well.

There are a few similar solutions out there, and a lot of homegrown attempts. Most namespace your configuration under a `Config` (or similar) namespace. That's fine, but there's already a place to describe the application environment… `ENV`!

`ENV` is a collection of simple string key/value pairs and it works just great for application configuration.

As an added bonus, this is exactly how apps on [Heroku](http://www.heroku.com/) are configured. So if you configure your Rails app using `ENV`, you're already set to deploy to Heroku.

## Give me an example.

Okay. Add Figaro to your bundle:

```ruby
gem "figaro"
```

Next up, install Figaro:

```bash
rails generate figaro:install
```

This generates a commented `config/application.yml` file and ignores it in your `.gitignore`. Add your own configuration to this file and you're done!

Your configuration will be available as key/value pairs in `ENV`. For example, here's `config/initializers/pusher.rb`:

```ruby
Pusher.app_id = ENV["PUSHER_APP_ID"]
Pusher.key    = ENV["PUSHER_KEY"]
Pusher.secret = ENV["PUSHER_SECRET"]
```

## How does it work with Heroku?

Heroku's beautifully simple application configuration was the [inspiration](http://laserlemon.com/blog/2011/03/08/heroku-friendly-application-configuration/) for Figaro.

To configure your application `ENV` on Heroku, you can do the following from the command line using the `heroku` gem and your production configuration information.

```bash
heroku config:add PUSHER_APP_ID=8926
heroku config:add PUSHER_KEY=0463644d89a340ff1132
heroku config:add PUSHER_SECRET=0eadfd9847769f94367b
heroku config:add STRIPE_API_KEY=jHXKPPE0dUW84xJNYzn6CdWM2JfrCbPE
heroku config:add STRIPE_PUBLIC_KEY=pk_HHtUKJwlN7USCT6nE5jiXgoduiNl3
```

## What if I'm not using Heroku?

No problem. Just add `config/application.yml` to your production app on the server.

## This sucks. How can I make it better?

1. Fork it.
2. Make it better.
3. Send me a pull request.

## Does Figaro have a mascot?

Yes.

[![Figaro](http://images2.wikia.nocookie.net/__cb20100628192722/disney/images/5/53/Pinocchio-pinocchio-4947890-960-720.jpg "Figaro's mascot: Figaro")](http://en.wikipedia.org/wiki/Figaro_(Disney\))
