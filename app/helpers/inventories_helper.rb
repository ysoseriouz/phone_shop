module InventoriesHelper
  def format_price(price)
    number_to_currency(price, unit: "VND", format: "%n %u", precision: 0)
  end
end
