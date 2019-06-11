# Blaze Verify Ruby Library

This is the official ruby wrapper for the Blaze Verify API.

## Documentation

See the [Ruby API docs](https://blazeverify.com/docs/api).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'blazeverify'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install blazeverify

## Usage

The library needs to be configured with your account's API key which is available in your [Blaze Verify Dashboard](https://app.blazeverify.com/api). Set `BlazeVerify.api_key` to its value:

```ruby
require 'blazeverify'
BlazeVerify.api_key = 'live_...'

# verify an email address
BlazeVerify.verify('jarrett@blazeverify.com')
```

### Slow Email Server Handling

Some email servers are slow to respond. As a result the timeout may be reached
before we are able to complete the verification process. If this happens, the
verification will continue in the background on our servers. We recommend
sleeping for at least one second and trying your request again. Re-requesting
the same verification with the same options will not impact your credit
allocation within a 5 minute window.

```ruby
{
    "message" => "Your request is taking longer than normal. Please send your request again."
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/blazeverify/blazeverify-ruby.
