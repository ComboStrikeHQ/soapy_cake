# SoapyCake
[![Code Climate](https://codeclimate.com/github/ad2games/soapy_cake.png)](https://codeclimate.com/github/ad2games/soapy_cake)
[![Test Coverage](https://codeclimate.com/github/ad2games/soapy_cake/coverage.png)](https://codeclimate.com/github/ad2games/soapy_cake)
[![Gem Version](http://img.shields.io/gem/v/soapy_cake.svg)](http://rubygems.org/gems/soapy_cake)
[![Dependency Status](http://img.shields.io/gemnasium/ad2games/soapy_cake.svg)](https://gemnasium.com/ad2games/soapy_cake)
[![Circle CI](https://circleci.com/gh/ad2games/soapy_cake.png?style=shield&circle-token=aac691804f58acd8e96db632f8133e3c6155f123)](https://circleci.com/gh/ad2games/soapy_cake)

Simple client library for [cake](http://getcake.com).

## Installation

Add this line to your application's Gemfile:

    gem 'soapy_cake'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install soapy_cake

## Usage Examples

First we assume that you set the `CAKE_DOMAIN`, `CAKE_API_KEY` and `CAKE_TIME_ZONE`
environment variables.

Export all advertisers:

```ruby
SoapyCake::Admin.new.advertisers(opts)
```

Get report for specific date range:

```ruby
SoapyCake::Admin.new.affiliate_summary(
  start_date: Date.beginning_of_month,
  end_date: Date.today
)
```

If you are interested in how we map methods to api endpoints take a look
at [api_versions.yml](api_versions.yml).

## Contributing

1. Fork it (https://github.com/ad2games/soapy_cake/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
