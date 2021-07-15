module InventoriesHelper
  def format_price(price)
    number_to_currency(price, format: "%n", precision: 0)
  end

  def manufactoring_year_range(selected=nil)
    options_for_select(1990..Time.zone.now.year, selected=selected)
  end

  def inventory_status_options(selected=nil)
    options_for_select(
      Inventory.statuses.map { |k, v|
        [k.titleize, Inventory.statuses.key(v)]
      }, selected=selected)
  end

  def model_groups_options(selected=nil)
    option_groups_from_collection_for_select(
      Brand.order(:name), :models, :name,
      :id, :name, selected=selected
    )
  end

  def memory_size_options
    ["Under 16GB", "From 16GB to 64GB", "From 64GB to 256GB", "Over 256GB"]
  end

  def price_options
    ["Under 10 million VND", "From 10 to 15 million VND", "From 15 to 20 million VND",
      "From 20 to 30 million VND", "Over 30 million VND"]
  end

  def create_thumbnail(inventory)
    inventory.images.order(:created_at).first.variant(resize_to_limit: [100, 100])
  end
end
