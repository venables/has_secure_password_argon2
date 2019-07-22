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
    def has_secure_password(attribute = :password, validations: true)
      args = if ActiveRecord::VERSION::MAJOR >= 6
               [attribute, validations: validations]
             else
               [validations: validations]
             end

      super(*args) if supports_bcrypt_has_secure_password?

      include InstanceMethodsOnActivation.new(attribute)

      if !supports_bcrypt_has_secure_password? && validations
        include ActiveModel::Validations

        # This ensures the model has a password by checking whether the password_digest
        # is present, so that this works with both new and existing records. However,
        # when there is an error, the message is added to the password attribute instead
        # so that the error message will make sense to the end-user.
        validate do |record|
          record.errors.add(attribute, :blank) unless record.send("#{attribute}_digest").present?
        end

        validates_length_of attribute, maximum: ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED
        validates_confirmation_of attribute, allow_blank: true
      end
    end

    alias has_secure has_secure_password

    private

    def supports_bcrypt_has_secure_password?
      require 'bcrypt'
      true
    rescue LoadError
      false
    end
  end

  class InstanceMethodsOnActivation < Module
    def initialize(attribute)
      attr_reader attribute

      define_method("#{attribute}=") do |unencrypted_password|
        if unencrypted_password.nil?
          send("#{attribute}_digest=", nil)
        elsif !unencrypted_password.empty?
          instance_variable_set("@#{attribute}", unencrypted_password)
          send("#{attribute}_digest=", InstanceMethodsOnActivation.generate_secure_hash(unencrypted_password))
        end
      end

      define_method("#{attribute}_confirmation=") do |unencrypted_password|
        instance_variable_set("@#{attribute}_confirmation", unencrypted_password)
      end

      define_method('authenticate') do |unencrypted_password|
        attribute_digest = send("#{attribute}_digest")

        if attribute_digest.nil? || attribute_digest.start_with?('$argon2')
          send("authenticate_#{attribute}", unencrypted_password)
        elsif defined?(super) && super(unencrypted_password)
          self.password = InstanceMethodsOnActivation.generate_secure_hash(unencrypted_password)
          save(validate: false)
          self
        else
          false
        end
      end

      # Returns +self+ if the password is correct, otherwise +false+.
      #
      #   class User < ActiveRecord::Base
      #     has_secure_password validations: false
      #   end
      #
      #   user = User.new(name: 'david', password: 'mUc3m00RsqyRe')
      #   user.save
      #   user.authenticate_password('notright')      # => false
      #   user.authenticate_password('mUc3m00RsqyRe') # => user
      define_method("authenticate_#{attribute}") do |unencrypted_password|
        begin
          attribute_digest = send("#{attribute}_digest")

          if attribute_digest.nil? || attribute_digest.start_with?('$argon2')
            Argon2::Password.verify_password(unencrypted_password, password_digest, HasSecurePasswordArgon2.secret) && self
          elsif defined?(super) && super(unencrypted_password)
            self.password = InstanceMethodsOnActivation.generate_secure_hash(unencrypted_password)
            save(validate: false)
            self
          else
            false
          end
        rescue Argon2::ArgonHashFail
          false
        end
      end
    end

    def self.generate_secure_hash(unencrypted_password)
      hasher = Argon2::Password.new t_cost: HasSecurePasswordArgon2.time_cost,
                                    m_cost: HasSecurePasswordArgon2.memory_cost,
                                    secret: HasSecurePasswordArgon2.secret

      hasher.create unencrypted_password
    end
  end
end

ActiveRecord::Base.send :include, HasSecurePasswordArgon2
