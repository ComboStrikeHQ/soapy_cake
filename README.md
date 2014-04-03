# SoapyCake

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'soapy_cake'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install soapy_cake

## Dependencies

SoapyCake depends on the current devopment version of savon (i.e. savon 3). You
can either download the savon source from github build it and install it
locally with the following commands.

```sh
git clone git@github.com:savonrb/savon.git
cd savon
gem build savon.gemspec
sed -i 's/3.0.0/3.0.0.pre.1/' lib/savon/version.rb
gem install savon-*.gem
```

or if you have our own gemserver with a pre version of savon 3 on it you
can override the bundler config to use your gemserver instead of
rubygems with the following command.

```sh
bundle config mirror.https://rubygems.org 'https://your-gemserver.com/'
```

after that you should be able to `bundle` as usual.

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/[my-github-username]/soapy_cake/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
