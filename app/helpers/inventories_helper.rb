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

  def memory_size_options
    Inventory.memory_size_ranges.keys
  end

  def price_options
    Inventory.price_ranges.keys
  end
end
