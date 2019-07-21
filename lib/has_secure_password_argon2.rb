# frozen_string_literal: true

require 'argon2'
require 'active_record'
require 'active_support/all'
require 'has_secure_password_argon2/version'

module HasSecurePasswordArgon2
  extend ActiveSupport::Concern
  class Error < StandardError; end

  class << self
    attr_accessor :time_cost
    attr_accessor :memory_cost
    attr_accessor :secret
  end
  self.time_cost = 2 # 1..10
  self.memory_cost = 16 # 1..31

  module ClassMethods
    def has_secure_password(options = {})
      super options
      include InstanceMethodsOnActivation
    end
  end

  module InstanceMethodsOnActivation
    # Returns +self+ if the password is correct, otherwise +false+.
    #
    #   class User < ActiveRecord::Base
    #     has_secure_password validations: false
    #   end
    #
    #   user = User.new(name: 'david', password: 'mUc3m00RsqyRe')
    #   user.save
    #   user.authenticate('notright')      # => false
    #   user.authenticate('mUc3m00RsqyRe') # => user
    def authenticate(unencrypted_password)
      if password_digest.start_with?('$argon2')
        Argon2::Password.verify_password(unencrypted_password, password_digest, HasSecurePasswordArgon2.secret) && self
      elsif super(unencrypted_password)
        self.password = hash_argon2_password(unencrypted_password)
        save(validate: false)
        self
      else
        false
      end
    end

    attr_reader :password

    # Encrypts the password into the +password_digest+ attribute, only if the
    # new password is not empty.
    #
    #   class User < ActiveRecord::Base
    #     has_secure_password validations: false
    #   end
    #
    #   user = User.new
    #   user.password = nil
    #   user.password_digest # => nil
    #   user.password = 'mUc3m00RsqyRe'
    #   user.password_digest # => "$2a$10$4LEA7r4YmNHtvlAvHhsYAeZmk/xeUVtMTYqwIvYY76EW5GUqDiP4."
    def password=(unencrypted_password)
      if unencrypted_password.nil?
        self.password_digest = nil
      elsif !unencrypted_password.empty?
        @password = unencrypted_password
        self.password_digest = hash_argon2_password(unencrypted_password)
      end
    end

    private

    def hash_argon2_password(unencrypted_password)
      hasher = Argon2::Password.new t_cost: HasSecurePasswordArgon2.time_cost,
                                    m_cost: HasSecurePasswordArgon2.memory_cost,
                                    secret: HasSecurePasswordArgon2.secret

      hasher.create unencrypted_password
    end
  end
end

ActiveRecord::Base.send :include, HasSecurePasswordArgon2
