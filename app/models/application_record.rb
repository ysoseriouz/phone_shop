# frozen_string_literal: true

# Default Application Record model
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
