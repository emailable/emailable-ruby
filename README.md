# Blaze Verify Ruby Library

[![Build Status](https://travis-ci.com/blazeverify/blazeverify-ruby.svg)](https://travis-ci.com/blazeverify/blazeverify-ruby)
[![Maintainability](https://api.codeclimate.com/v1/badges/2d74c69a9155109058a7/maintainability)](https://codeclimate.com/github/blazeverify/blazeverify-ruby/maintainability)

This is the official ruby wrapper for the Blaze Verify API.

## Documentation

See the [Ruby API docs](https://blazeverify.com/docs/api#ruby).

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

### Setup

```ruby
require 'blazeverify'

# set api key
BlazeVerify.api_key = 'live_...'
```

### Verification

```ruby
# verify an email address
BlazeVerify.verify('jarrett@blazeverify.com')
```

#### Slow Email Server Handling

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

### Batch Verification

#### Start a batch

```ruby
emails = ['jarrett@blazeverify.com', 'support@blazeverify.com', ...]
batch = BlazeVerify::Batch.new(emails)

# you can optionally pass in a callback url that we'll POST to when the
# batch is complete.
batch = BlazeVerify::Batch.new(emails, callback: 'https://blazeverify.com/')

# start verifying the batch
batch.verify
```

#### Get the status / results of a batch

Calling `status` on a batch will return the status. It will contain the results as well once complete. You can also `results` to get just the results.

```ruby
id = '5cfcbfdeede34200693c4319'
batch = BlazeVerify::Batch.new(id)

# get status of batch
batch.status

# gets the results
batch.status.emails

# get the counts
batch.status.total_counts
batch.status.reason_counts

# returns true / false
batch.complete?
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/blazeverify/blazeverify-ruby.
