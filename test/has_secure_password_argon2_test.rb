# frozen_string_literal: true

require 'test_helper'
require 'support/model'
require 'bcrypt'

class HasSecurePasswordArgon2Test < ActiveSupport::TestCase
  test 'it has a version number' do
    refute_nil ::HasSecurePasswordArgon2::VERSION
  end

  test 'password= sets password_digest on a new model' do
    model = Model.new
    model.password = 'abc123'

    assert model.password_digest.start_with?('$argon2')
  end

  test 'password= sets password_digest to nil if given a nil password' do
    model = Model.new(password: 'testing')
    model.password = nil

    assert model.password_digest.nil?
  end

  test '#authenticate returns the model upon valid password' do
    model = Model.new(password: 'testing')

    assert_equal model, model.authenticate('testing')
  end

  test '#authenticate returns false upon invalid password' do
    model = Model.new(password: 'testing')

    refute model.authenticate('note-testing')
  end

  test '#authenticate updates the model for argon2 and returns the model upon valid bcrypt password' do
    password = 'testing'
    bcrypt_hash = BCrypt::Password.create(password)

    model = Model.new(password_digest: bcrypt_hash)
    assert_changes -> { model.password_digest } do
      assert model.authenticate(password)
    end

    assert model.password_digest.start_with?('$argon2')
    assert model.persisted?
  end

  test '#authenticate returns false if given an invalid bcrypt password' do
    password = 'testing'
    bcrypt_hash = BCrypt::Password.create(password)

    model = Model.new(password_digest: bcrypt_hash)

    refute model.authenticate(password + '1')
  end
end
