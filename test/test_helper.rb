# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'has_secure_password_argon2'
require 'active_support/test_case'

require 'minitest/autorun'

require 'active_record'
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: File.dirname(__FILE__) + '/tmp/test.sqlite3')
puts "Using ActiveRecord #{ActiveRecord::VERSION::STRING}"
load File.dirname(__FILE__) + '/support/schema.rb'
