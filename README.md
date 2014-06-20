# SoapyCake

Simple client library for [cake](http://getcake.com).

## Installation

Add this line to your application's Gemfile:

    gem 'soapy_cake'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install soapy_cake

## Usage Examples

First we assume that you set the `CAKE_DOMAIN` and `CAKE_API_KEY`
environment variables.

Export all advertisers:

```ruby
SoapyCake::Client.export.advertisers(opts)
```

Get report for specific date range:

```ruby
SoapyCake::Client.reports.affiliate_summary(
  start_date: Date.beginning_of_month,
  end_date: Date.today
)
```

If you are interested in how we map methods to api endpoints take a look
at [api_versions.yml](/ad2games/soapy_cake/blob/master/api_versions.yml).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/soapy_cake/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
