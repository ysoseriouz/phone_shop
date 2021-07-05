import random

def float_range(start, stop, step):
    result = [float(start)]
    while result[-1] < stop:
        result.append(result[-1] + step)
    return result[:-1]

brand_model = {
    "Samsung": ["Galaxy A22", "Galaxy M32", "Galaxy A12", "Galaxy Note20"],
    "Apple": ["iPhone 4S", "iPhone 5", "iPhone 6", "iPhone 6s Plus",
              "iPhone 7", "iPhone 7 Plus", "iPhone 8", "iPhone X"],
    "OPPO": ["Oppo F19", "Oppo A54", "Oppo A5", "Oppo Reno 3 Pro"],
    "Xiaomi": ["Redmi Note 10T", "Redmi Note 10 5G", "Mi 10 Pro"],
    "HTC": ["HTC 10", "HTC Butterfly 3"]
}
brand_list = list(brand_model.keys())
android = ["Android 11", "Android 10.0", "Android 8.1",
                    "Android 9.0", "Android 8.0", "Android 7.0"]
ios = ["iOS 14.6", "iOS 12.5", "iOS 13.7", "iOS 11.4"]
colorOS = ["ColorOS 11", "ColorOS 7.2", "ColorOS 8.1"]

memory_size_list = [16, 32, 64, 128, 256]
manu_year_list = list(range(2014, 2021))
color_list = ["Silver", "Yellow", "Cyan",
         "Blue", "White", "Black",
         "Green", "Red", "Purple"]

price_step, unit = 0.005, 1e6
price_list = float_range(8, 20, price_step)
source_list = ["retailer", "store", "unknown"]
stock_list = list(range(50))
desc_list = ["Some notes", "Phone just likes new", "I don't know and don't care"]

def get_status(stock, sell, reserve):
    if random.uniform(0, 1) > 0.8:
        return "Inactive"
    if stock > 0 and sell > 0:
        return "Active"
    elif stock > 0 and sell == 0:
        return "Sold out"
    elif stock == 0 and sell == 0 and reserve == 0:
        return "Out of stock"

def mock_data(N=1, filename="mock_data"):
    header = ["brand", "model", "memory_size", "manufactoring_year",
              "os_version", "color", "price", "original_price", "source",
              "stock", "sell", "reserve", "status", "description"]
    header_s = ','.join(header) + "\n"
    with open(filename, "w") as f:
        f.write(header_s)
        for _ in range(N):
            brand = random.choice(brand_list)
            model = random.choice(brand_model[brand])
            memory_size = random.choice(memory_size_list)
            manu_year = random.choice(manu_year_list)
            os_typ = android
            if brand == "Apple":
                os_typ = ios
            elif brand == "OPPO":
                os_typ = colorOS
            os = random.choice(os_typ)
            color = random.choice(color_list)
            p = random.choice(price_list)
            price = int(p * unit)
            og_price_list = float_range(7, p, price_step)
            original_price = int(random.choice(og_price_list) * unit) if random.uniform(0, 1) > 0.8 else None
            source = random.choice(source_list)
            stock = random.choice(stock_list)
            reserve = random.choice(list(range(stock + 1)))
            sell = stock - reserve
            status = get_status(stock, sell, reserve)
            desc = random.choice(desc_list) if random.uniform(0, 1) > 0.8 else None

            data = [brand, model, memory_size, manu_year,
                    os, color, price, original_price, source,
                    stock, sell, reserve, status, desc]
            data_s = ','.join('' if e is None else str(e) for e in data) + "\n"
            
            f.write(data_s)

if __name__ == "__main__":
    mock_data(100, "mock_data.csv")