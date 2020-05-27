# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'has_secure_password_argon2/version'

Gem::Specification.new do |spec|
  spec.name          = 'has_secure_password_argon2'
  spec.version       = HasSecurePasswordArgon2::VERSION
  spec.authors       = ['Matt Venables']
  spec.email         = ['matt@venabl.es']

  spec.summary       = 'Drop-in replacement for has_secure_password that uses argon2'
  spec.homepage      = 'https://github.com/venables/has_secure_password_argon2'
  spec.license       = 'MIT'

  if spec.respond_to?(:metadata)
    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/venables/has_secure_password_argon2'
    spec.metadata['changelog_uri'] = 'https://github.com/venables/has_secure_password_argon2/blob/master/CHANGELOG.md'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activerecord', '>= 4.2.6'
  spec.add_runtime_dependency 'activesupport', '>= 4.2.6'
  spec.add_runtime_dependency 'argon2', '~> 2.0'

  spec.add_development_dependency 'bcrypt', '~> 3.1'
  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'simplecov', '~> 0.11.2'
  spec.add_development_dependency 'sqlite3', '~> 1.3'
end
