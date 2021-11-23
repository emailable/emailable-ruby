# Emailable Ruby Library

[![Build Status](https://app.travis-ci.com/emailable/emailable-ruby.svg)](https://app.travis-ci.com/emailable/emailable-ruby)
[![Maintainability](https://api.codeclimate.com/v1/badges/e7eef54e491adec95e6d/maintainability)](https://codeclimate.com/github/emailable/emailable-ruby/maintainability)

This is the official ruby wrapper for the Emailable API.

It also includes an Active Record (Rails) validator to verify email attributes.

## Documentation

See the [Ruby API docs](https://emailable.com/docs/api/?ruby).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'emailable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install emailable

## Usage

The library needs to be configured with your account's API key which is available in your [Emailable Dashboard](https://app.emailable.com/api). Set `Emailable.api_key` to its value:

### Setup

```ruby
require 'emailable'

# set api key
Emailable.api_key = 'live_...'
```

### Verification

```ruby
# verify an email address
Emailable.verify('jarrett@emailable.com')
```

#### Slow Email Server Handling

Some email servers are slow to respond. As a result, the timeout may be reached
before we are able to complete the verification process. If this happens, the
verification will continue in the background on our servers, and a
`Emailable::TimeoutError` will be raised. We recommend sleeping for at least
one second and trying your request again. Re-requesting the same verification
with the same options will not impact your credit allocation within a 5 minute
window. You can test this behavior using a test key and the special
email `slow@example.com`.

### Batch Verification

#### Start a batch

```ruby
emails = ['jarrett@emailable.com', 'support@emailable.com', ...]
batch = Emailable::Batch.new(emails)

# you can optionally pass in a callback url that we'll POST to when the
# batch is complete.
batch = Emailable::Batch.new(emails, callback: 'https://emailable.com/')

# start verifying the batch
batch.verify
```

#### Get the status / results of a batch

Calling `status` on a batch will return the status. It will contain the results as well once complete. You can also `results` to get just the results.

```ruby
id = '5cfcbfdeede34200693c4319'
batch = Emailable::Batch.new(id)

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

### Active Record Validator

Define a validator on an Active Record model for your email attribute(s).
It'll validate the attribute only when it's present and has changed.

#### Options

* `smtp`, `timeout`: Passed directly to API as options.
* `states`: An array of states you'd like to be considered valid.
* `free`, `role`, `disposable`, `accept_all`: If you'd like any of these to be valid.

```ruby
validates :email, email: {
  smtp: true, states: %i[deliverable risky unknown],
  free: true, role: true, disposable: false, accept_all: true, timeout: 3
}
```

#### Access Verification Result

You can define an `attr_accessor` with the following format to gain
access to the verification result.

```ruby
# [attribute_name]_verification_result
attr_accessor :email_verification_result
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/emailable/emailable-ruby.
