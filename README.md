# SoapyCake
[![Maintainability](https://api.codeclimate.com/v1/badges/506ccd1a270e86f6b2bb/maintainability)](https://codeclimate.com/github/ad2games/soapy_cake/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/506ccd1a270e86f6b2bb/test_coverage)](https://codeclimate.com/github/ad2games/soapy_cake/test_coverage)
[![Gem Version](http://img.shields.io/gem/v/soapy_cake.svg)](http://rubygems.org/gems/soapy_cake)
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

First we assume that you set the `CAKE_DOMAIN`, `CAKE_API_KEY` and
`CAKE_TIME_ZONE` environment variables. To enable the ADD, EDIT and ADDEDIT API
endpoints, `CAKE_WRITE_ENABLED=yes` should also be set.

Export all advertisers:

```ruby
SoapyCake::Admin.new.advertisers(opts)
```

Get report for specific date range:

```ruby
SoapyCake::Admin.new.affiliate_summary(
  start_date: Date.beginning_of_month,
  end_date: Date.current
)
```

If you are interested in how we map methods to api endpoints take a look at
[api.yml](api.yml).

## Time/Date Handling
- Define `CAKE_TIME_ZONE`
- Specify dates with any timezone in requests (will be converted to the correct CAKE timezone)
- `Date` objects in requests will be treated as UTC (just like `.to_datetime` would do)
- Responses contain UTC dates which can be converted however you like

## Contributing

1. Fork it (https://github.com/ad2games/soapy_cake/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
