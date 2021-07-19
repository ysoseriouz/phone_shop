# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
@brand_model = {
  Samsung: ['Galaxy A22', 'Galaxy M32', 'Galaxy A12', 'Galaxy Note20'],
  Apple: ['iPhone 4S', 'iPhone 5', 'iPhone 6', 'iPhone 6s Plus',
          'iPhone 7', 'iPhone 7 Plus', 'iPhone 8', 'iPhone X'],
  OPPO: ['Oppo F19', 'Oppo A54', 'Oppo A5', 'Oppo Reno 3 Pro'],
  Xiaomi: ['Redmi Note 10T', 'Redmi Note 10 5G', 'Mi 10 Pro'],
  HTC: ['HTC 10', 'HTC Butterfly 3']
}
@android = ['Android 11', 'Android 10.0', 'Android 8.1',
            'Android 9.0', 'Android 8.0', 'Android 7.0']
@ios = ['iOS 14.6', 'iOS 12.5', 'iOS 13.7', 'iOS 11.4']
@color_os = ['ColorOS 11', 'ColorOS 7.2', 'ColorOS 8.1']

def create_model(brand)
  model_name = @brand_model[brand.name.to_sym].sample
  Model.find_or_create_by(name: model_name, brand_id: brand.id)
end

def choose_os(brand_name)
  case brand_name.to_sym
  when :Apple
    @ios.sample
  when :OPPO
    @color_os.sample
  else
    @android.sample
  end
end

def create_inventory(model)
  memory_size = [16, 32, 64, 128, 256].sample
  manu_year = rand(2014..2021)
  os = choose_os(model.brand.name)
  color = Faker::Color.color_name
  unit = 1e6
  p = rand(8.0..20.0)
  price = (p * unit).to_i
  original_price = (rand(7.0..p) * unit).to_i
  source = %w[Retailer Store Unknown].sample
  status = rand(0..2)
  desc = ['Some notes', 'Phone just likes new', "I don't know and don't care"].sample

  Inventory.create(model: model, memory_size: memory_size, manufactoring_year: manu_year,
                   os_version: os, color: color, price: price, original_price: original_price,
                   source: source, status: status, description: desc)
end

# 1 sample
Role.find_or_create_by(name: 'Manager')
Role.find_or_create_by(name: 'Staff')

@brand_model.each_key do |brand|
  Brand.create(name: brand.to_s)
end

# Many samples
@brands = Brand.all
1000.times do
  brand = @brands.sample
  model = create_model(brand)
  create_inventory(model)
end
