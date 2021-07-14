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
  scope :by_id, -> (id) { where id: id }
  scope :by_model_id, -> (model_id) { where model_id: model_id }
  scope :by_manufactoring_year_lb, -> (year) { where "manufactoring_year >= ?", year }
  scope :by_manufactoring_year_ub, -> (year) { where "manufactoring_year <= ?", year }
  scope :by_status, -> (status) { where status: status }
  scope :by_os_version, -> (os) { where "os_version LIKE ?", "%" + os + "%" }
  scope :by_color, -> (color) { where "color LIKE ?", "%" + color.downcase + "%" }

  def self.search(query_params)
    query_params = query_params.delete_if { |k, v| v.blank? }
    
    inventories = self.where(nil)
    query_params.each do |k, v|
      inventories = inventories.public_send("by_#{k}", v)
    end
    inventories
  end

  def self.by_memory_size(query)
    attribute = "memory_size"
    case query
    when "<= 16 GB"
      return range_query(attribute, 0, 16)
    when "16 -> 64 GB"
      return range_query(attribute, 16, 64)
    when "64 -> 256 GB"
      return range_query(attribute, 64, 256)
    when ">= 256 GB"
      return range_query(attribute, 256)
    end
  end

  def self.by_price(query)
    attribute = "price"
    unit = 1e6
    case query
    when "<= 10 tr"
      return range_query(attribute, 0, 10 * unit)
    when "10 -> 15 tr"
      return range_query(attribute, 10 * unit, 15 * unit)
    when "15 -> 20 tr"
      return range_query(attribute, 15 * unit, 20 * unit)
    when "20 -> 30 tr"
      return range_query(attribute, 20 * unit, 30 * unit)
    when ">= 30 tr"
      return range_query(attribute, 30 * unit)
    end
  end

  private

  def self.range_query(attribute, lb, ub=nil)
    return ub.nil? ? where("#{attribute} >= ?", lb) : where("#{attribute} >= ? and #{attribute} <= ?", lb, ub)
  end

  def downcase_color
    self.color.downcase!
  end
end
