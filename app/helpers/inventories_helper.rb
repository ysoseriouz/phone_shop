# frozen_string_literal: true

# Inventories helper for controller
module InventoriesHelper
  def format_price(price)
    number_to_currency(price, format: '%n', precision: 0)
  end

  def manufactoring_year_range(selected = nil)
    options_for_select(1990..Time.zone.now.year, selected)
  end

  def inventory_status_options(selected = nil)
    options_for_select(
      Inventory.statuses.map do |k, v|
        [k.titleize, Inventory.statuses.key(v)]
      end, selected
    )
  end

  def model_groups_options(selected = nil)
    option_groups_from_collection_for_select(
      Brand.order(:name), :models, :name,
      :id, :name, selected
    )
  end

  def memory_size_options(selected = nil)
    options_for_select(
      ['Under 16GB', 'From 16GB to 64GB', 'From 64GB to 256GB', 'Over 256GB'],
      selected
    )
  end

  def price_options(selected = nil)
    options_for_select(
      ['Under 10 million VND', 'From 10 to 15 million VND', 'From 15 to 20 million VND',
       'From 20 to 30 million VND', 'Over 30 million VND'],
      selected
    )
  end

  def create_thumbnail(inventory)
    inventory.images.order(:created_at).first.variant(resize_to_limit: [100, 100])
  end
end
