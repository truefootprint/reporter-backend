class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  extend ExistsHelper
  extend Mobility
end
