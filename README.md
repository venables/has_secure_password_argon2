# has_secure_password_argon2

[![Build Status](https://travis-ci.org/venables/has_secure_password_argon2.svg?branch=master)](https://travis-ci.org/venables/has_secure_password_argon2)
[![Coverage Status](https://coveralls.io/repos/github/venables/has_secure_password_argon2/badge.svg?branch=master)](https://coveralls.io/github/venables/has_secure_password_argon2?branch=master)

Drop-in replacement for Ruby on Rails' `has_secure_password`, but this one uses [argon2](https://en.wikipedia.org/wiki/Argon2) to hash the password.

**No code changes necessary.**  Just add this gem to your project and your users will be using `argon2`

## Installation

Add it to your bundle:

```sh
bundle add has_secure_password_argon2
```

Or add this line to your application's Gemfile:

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

## Different Attributes

If you are using Rails 6+, you can secure an attribute other than `password`.  Simply pass the attribute name as the first argument:

```
has_secure_password :recovery_password, validations: false
```

This gem also adds a simpler alias, `has_secure`. The same code could read as:

```
has_secure :recovery_password, validations: false
```

## Configuration

Argon2 allows for several options which can be set in an initializer.

For example, in `config/initializers/has_secure_password_argon2.rb`

```
HasSecurePasswordArgon2.time_cost = 2 # Default is 2. Can be 1..10
HasSecurePasswordArgon2.memory_cost = 16 # Default is 16. Can be 1..31
HasSecurePasswordArgon2.secret = ENV['ARGON2_SECRET'] # Default nil. Set this to the output of `rails secret' for added security
```

Read more about the [Argon2 options here](https://github.com/technion/ruby-argon2).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/venables/has_secure_password_argon2. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

[MIT](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in this project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/has_secure_password_argon2/blob/master/CODE_OF_CONDUCT.md).
