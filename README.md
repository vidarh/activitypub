# ActivityPub

*Very* early start on a set of classes to serialize/deserialize
ActivityPub/ActivityStream objects.

## Goals

 * To provide a fairly *minimalist*, *barebones* set of classes to
   work with ActivityPub objects *as used* by major Fediverse apps.
 * Matching real-world use will be prioritized over strict adherence
   to the specs - my use-cases require me to be able to handle documents
   even if they have errors. But I want to be able to *produce* output
   that prefers standards compliance where it doesn't sacrifice interop.
 * Support extensions and namespace used by e.g. Mastodon and others.
 * Be easy to extend/layer new functionality on top of for anything
   that doesn't fit in this core.


## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add activitypub

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install activitypub

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/vidarh/activitypub.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
