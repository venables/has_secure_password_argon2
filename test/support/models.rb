# frozen_string_literal: true

class Model < ActiveRecord::Base
  has_secure_password
end

class ModelWithAttribute < ActiveRecord::Base
  self.table_name = 'models'
  has_secure_password :confirmation
end

class ModelWithAttributeShorthand < ActiveRecord::Base
  self.table_name = 'models'
  has_secure :confirmation
end
