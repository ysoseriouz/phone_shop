module InventoriesHelper
  def format_price(price)
    number_to_currency(price, unit: "VND", format: "%n %u", precision: 0)
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
    ["< 16 GB", "16 -> 64 GB", "64 -> 256 GB", "> 256 GB"]
  end

  def price_options
    ["< 10 tr", "10 -> 15 tr", "15 -> 20 tr", "20 -> 30 tr", "> 30 tr"]
  end
end
