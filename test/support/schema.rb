# frozen_string_literal: true

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :models, force: true do |t|
    t.string :password_digest
    t.string :confirmation_digest
  end
end
