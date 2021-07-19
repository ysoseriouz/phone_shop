# frozen_string_literal: true

# Inventory model mapped to Inventories table in database
class Inventory < ApplicationRecord
  belongs_to :model, -> { includes :brand }
  has_many_attached :images, dependent: :destroy
  enum status: {
    active: 0,
    sold: 1,
    inactive: 2
  }, _prefix: true

  before_save :downcase_color

  validates_associated :model
  validates :memory_size, :manufactoring_year, :os_version, :color, :price, presence: true

  validates :memory_size, numericality: { only_integer: true, greater_than: 0 }
  validates :manufactoring_year, numericality: { only_integer: true, greater_than: 0,
                                                 less_than_or_equal_to: Time.zone.now.year }
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  # Search / Filter functions
  scope :by_id, ->(id) { where id: id }
  scope :by_brand_id, ->(brand_id) { joins(:model).where(model: { brand_id: brand_id }) }
  scope :by_model_id, ->(model_id) { where model_id: model_id }
  scope :by_manufactoring_year_lower, ->(year) { where 'manufactoring_year >= ?', year }
  scope :by_manufactoring_year_upper, ->(year) { where 'manufactoring_year <= ?', year }
  scope :by_status, ->(status) { where status: status }
  scope :by_os_version, ->(os) { where 'os_version LIKE ?', "%#{os}%" }
  scope :by_color, ->(color) { where 'color LIKE ?', "%#{color.downcase}%" }

  # Class method
  class << self
    def search(query_params)
      query_params = query_params.delete_if { |_k, v| v.blank? }

      inventories = where(nil)
      query_params.each do |k, v|
        inventories = inventories.public_send("by_#{k}", v)
      end
      inventories
    end

    def by_memory_size(query)
      attribute = 'memory_size'
      case query
      when 'Under 16GB'
        range_query(attribute, 0, 16)
      when 'From 16GB to 64GB'
        range_query(attribute, 16, 64)
      when 'From 64GB to 256GB'
        range_query(attribute, 64, 256)
      when 'Over 256GB'
        range_query(attribute, 256)
      end
    end

    def by_price(query)
      attribute = 'price'
      unit = 1e6
      case query
      when 'Under 10 million VND'
        range_query(attribute, 0, 10 * unit)
      when 'From 10 to 15 million VND'
        range_query(attribute, 10 * unit, 15 * unit)
      when 'From 15 to 20 million VND'
        range_query(attribute, 15 * unit, 20 * unit)
      when 'From 20 to 30 million VND'
        range_query(attribute, 20 * unit, 30 * unit)
      when 'Over 30 million VND'
        range_query(attribute, 30 * unit)
      end
    end

    private

    def range_query(attribute, lower_bound, upper_bound = nil)
      if upper_bound.nil?
        where("#{attribute} >= ?", lower_bound)
      else
        where("#{attribute} >= ? and #{attribute} <= ?", lower_bound, upper_bound)
      end
    end
  end

  # Private method
  private

  def downcase_color
    color.downcase!
  end
end
