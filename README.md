# has_secure_password_argon2

Drop-in replacement for Ruby on Rails' `has_secure_password`, but this one uses [argon2](https://en.wikipedia.org/wiki/Argon2) to hash the password.

*No code changes necessary.*  Just install this gem and your users will be using `argon2`

## Installation

Add this line to your application's Gemfile:

```sh
bundle add has_secure_password_argon2
```

Or

```ruby
gem 'has_secure_password_argon2'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install has_secure_password_argon2

## Usage

Just add this gem to your Gemfile and `has_secure_password` will start to use `argon2` for password hashing.

If you already have users authenticating with Rails' version of `has_secure_password`, this gem will automatically upgrade users to `argon2` during their next login.  In this case, please leave `bcrypt` installed to support he upgrade process.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/venables/has_secure_password_argon2. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the HasSecurePasswordArgon2 project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/has_secure_password_argon2/blob/master/CODE_OF_CONDUCT.md).
