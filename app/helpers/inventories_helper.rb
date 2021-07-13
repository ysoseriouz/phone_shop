module InventoriesHelper
  def format_price(price)
    number_to_currency(price, unit: "VND", format: "%n %u", precision: 0)
  end

  def manufactoring_year_range
    1990..Time.zone.now.year
  end

  def inventory_status_options(inventory)
    options_for_select(
      Inventory.statuses.map { |k, v|
        [k.titleize, Inventory.statuses.key(v)]
      }, selected=inventory.status)
  end
end
