# This py file is the entry point of the python docker container 
# at https://github.com/manojmanivannan/docker-images/tree/master/postgres-playground-py-job
# 
# If you update this file, github actions on the repo 
# https://github.com/manojmanivannan/docker-images will build a new image and pushed to docker hub


import psycopg2
from faker import Faker
import random
import time

# Initialize Faker to generate fake data
fake = Faker()

# PostgreSQL connection parameters
db_params = {
    'host': 'db',
    'database': 'postgres',
    'user': 'postgres',
    'password': 'postgres',
}

max_retries = 10  # Adjust the number of retries as needed
retry_delay = 5  # Adjust the delay between retries (in seconds) as needed
user_range = 50 # Adjust the number users you need
order_range = 250
schema_name = 'ecomm'

# Attempt to connect to the PostgreSQL server with retries
for retry in range(max_retries):
    try:
        # Create a connection to the PostgreSQL server
        conn = psycopg2.connect(**db_params)
        cursor = conn.cursor()

        # If the connection is successful, break out of the retry loop
        break
    except psycopg2.OperationalError as e:
        if retry < max_retries - 1:
            print(f"Retry {retry + 1}/{max_retries}: Failed to connect to the database. Retrying in {retry_delay} seconds.")
            time.sleep(retry_delay)
        else:
            print("Max retry attempts reached. Could not connect to the database.")
            raise e

# Create a new schema
cursor.execute(f'CREATE SCHEMA IF NOT EXISTS {schema_name}')


# Create Users Table
cursor.execute(f'''
    CREATE TABLE IF NOT EXISTS {schema_name}.Users (
        user_id INTEGER PRIMARY KEY,
        username TEXT,
        email TEXT,
        registration_date DATE
    )
''')

# Create Products Table
cursor.execute(f'''
    CREATE TABLE IF NOT EXISTS {schema_name}.Products (
        product_id INTEGER PRIMARY KEY,
        product_name TEXT,
        category TEXT,
        price REAL
    )
''')

# Create Orders Table
cursor.execute(f'''
    CREATE TABLE IF NOT EXISTS {schema_name}.Orders (
        order_id INTEGER PRIMARY KEY,
        user_id INTEGER,
        order_date DATE,
        total_amount REAL,
        FOREIGN KEY (user_id) REFERENCES {schema_name}.Users(user_id)
    )
''')

# Create constraint on total_amount on Orders table using trigger
cursor.execute(f'''
CREATE OR REPLACE FUNCTION enforce_order_amount_constraint()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.total_amount < 100 THEN
        RAISE EXCEPTION 'Total amount cannot be less than 100';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
''')



# Creating a trigger to enforce total_amount constraint
cursor.execute(f'''
CREATE TRIGGER check_amount
BEFORE INSERT OR UPDATE ON ecomm.orders
FOR EACH ROW EXECUTE FUNCTION enforce_order_amount_constraint()
''')

# Create OrderDetails Table
cursor.execute(f'''
    CREATE TABLE IF NOT EXISTS {schema_name}.OrderDetails (
        order_detail_id INTEGER PRIMARY KEY,
        order_id INTEGER,
        product_id INTEGER,
        quantity INTEGER,
        FOREIGN KEY (order_id) REFERENCES {schema_name}.Orders(order_id),
        FOREIGN KEY (product_id) REFERENCES {schema_name}.Products(product_id)
    )
''')
cursor.execute(f'''TRUNCATE {schema_name}.Users CASCADE''')
cursor.execute(f'''TRUNCATE {schema_name}.Products CASCADE''')
cursor.execute(f'''TRUNCATE {schema_name}.Orders CASCADE''')
cursor.execute(f'''TRUNCATE {schema_name}.OrderDetails CASCADE''')

# Generate mock data for Users and Products tables
for i in range(user_range):
    user_id = i+1
    username = fake.user_name()
    email = fake.email()
    registration_date = fake.date_between(start_date='-5y', end_date='today')
    cursor.execute(f'INSERT INTO {schema_name}.Users (user_id, username, email, registration_date) VALUES (%s, %s, %s, %s)', (user_id, username, email, registration_date))

products_list = ['Banana','Apple','Milk','Cheese','Peach','Yogurt','Tomato Sauce','Canned Tuna','Orange','Butter','Pineapple','Canned Corn','Grapes','Eggs','Green Beans','Strawberries','Cheddar Cheese','Lemon','Mozzarella Cheese','Blueberries','Heavy Cream','Canned Soup','Watermelon','Whipping Cream','Pears','Cottage Cheese','Pineapple Juice','Kiwi','Greek Yogurt','Pasta Sauce','Cherries','Sour Cream','Canned Peas','Avocado','Cream Cheese','Blackberries','Condensed Milk','Canned Beans','Grapefruit','Cottage Cheese','Canned Pineapple','Plums','Cream Cheese Spread','Canned Tomatoes','Apricots','Whipped Cream','Canned Peaches','Mango','Custard','Canned Carrots','Raspberries','Buttermilk','Canned Asparagus','Grapes','Lettuce','Salmon','Carrots','Cantaloupe','Cucumber','Shrimp','Spinach','Pineapple','Bell Peppers','Tuna','Avocado','Zucchini','Sardines','Mango','Onions','Crab','Watermelon','Potatoes','Tilapia','Kiwi','Cabbage','Cod','Strawberries','Broccoli','Trout','Peaches','Cauliflower','Oysters','Blueberries','Eggplant','Clams','Cherries','Green Beans','Mussels','Oranges','Bell Peppers','Lobster','Lemons','Asparagus','Salmon','Apples','Cauliflower','Swordfish','Pineapples','Kale','Crab','Pears','Radishes','Tilapia','Mangos','Green Onions','Shrimp','Blackberries','T-Shirt','Laptop','Socks','Smartphone','Dress','Toy Car','Laptop Bag','Laptop Charger','Toy Blocks','Jacket','Video Game','Headphones','Hair Dryer','Sneakers','Couch','Hoodie','Coffee Maker','Kitchen Appliance','Toy Doll','Bed Sheets','Dining Table','Comforter Set','Desk','Bookshelf','Television','Microwave','Blender','Vacuum Cleaner','Gaming Console','Sofa','Piano','Guitar','Violin','Drums','Camera','Watch','Bracelet','Necklace','Ring','Earrings','Backpack','Wallet','Hat','Sunglasses','Scarf','Umbrella','Sunscreen','Shampoo','Soap','Toothbrush','Toothpaste','Razor','Perfume','Lotion','Body Wash','Deodorant','Makeup','Nail Polish','Hairbrush','Cologne','Hiking Boots','Sweater','Jeans','Bicycle','Tennis Racket','Basketball','Yoga Mat','Soccer Ball','Treadmill','Dumbbells','Running Shoes','Sandals','Boots','Lipstick','Eyeliner','Foundation','Camping Tent','Sleeping Bag','Fishing Rod','Swimsuit','Ski Jacket','Snowboard','Backpack','Flashlight','Tent','Hiking Boots','Compass','Ski Goggles','Bike Helmet','Dress','Washing Machine','Toy Blocks','Laptop','T-Shirt','Refrigerator','Sneakers','Tablet','Blouse','Toaster','Toy Car','Camera','Headphones','Coffee Maker','Luggage','Shirt','Printer','Desk','Microwave','Sofa','Bookshelf','Jacket','Iron','Bed Sheets','Jeans','Dining Table','Lamp','Vacuum Cleaner','Tableware','Guitar','Video Game','Water Heater','Violin','Drums','Recliner','Piano','Television','Handbag','Wristwatch','Backpack','Earrings','Sunglasses','Hat','Scarf','Umbrella','Sunscreen','Shampoo','Soap','Toothbrush','Toothpaste','Razor','Perfume','Lotion','Body Wash','Deodorant','Makeup','Nail Polish','Hairbrush','Cologne','Hiking Boots','Sweater','Bicycle','Tennis Racket','Basketball','Yoga Mat','Soccer Ball','Treadmill','Dumbbells','Running Shoes','Sandals','Boots','Lipstick','Eyeliner','Foundation','Camping Tent','Sleeping Bag','Fishing Rod','Swimsuit','Ski Jacket','Snowboard','Flashlight','Tent','Hiking Boots','Compass','Ski Goggles','Bike Helmet']
products_category = ['Fruit','Fruit','Dairy','Dairy','Fruit','Dairy','Canned Goods','Canned Goods','Fruit','Dairy','Fruit','Canned Goods','Fruit','Dairy','Canned Goods','Fruit','Dairy','Fruit','Dairy','Fruit','Dairy','Canned Goods','Fruit','Dairy','Fruit','Dairy','Canned Goods','Fruit','Dairy','Canned Goods','Fruit','Dairy','Canned Goods','Fruit','Dairy','Fruit','Dairy','Canned Goods','Fruit','Dairy','Canned Goods','Fruit','Dairy','Canned Goods','Fruit','Dairy','Canned Goods','Fruit','Dairy','Canned Goods','Fruit','Dairy','Canned Goods','Fruit','Vegetables','Seafood','Vegetables','Fruit','Vegetables','Seafood','Vegetables','Fruit','Vegetables','Seafood','Fruit','Vegetables','Seafood','Fruit','Vegetables','Seafood','Fruit','Vegetables','Seafood','Fruit','Vegetables','Seafood','Fruit','Vegetables','Seafood','Fruit','Vegetables','Seafood','Fruit','Vegetables','Seafood','Fruit','Vegetables','Seafood','Fruit','Vegetables','Seafood','Fruit','Vegetables','Seafood','Fruit','Vegetables','Seafood','Fruit','Vegetables','Seafood','Fruit','Vegetables','Seafood','Fruit','Vegetables','Seafood','Fruit','Clothing','Electronics','Clothing','Electronics','Clothing','Toys','Electronics','Electronics','Toys','Clothing','Electronics','Electronics','Electronics','Clothing','Home & Furniture','Clothing','Electronics','Home & Furniture','Toys','Home & Furniture','Home & Furniture','Home & Furniture','Home & Furniture','Home & Furniture','Electronics','Electronics','Electronics','Electronics','Electronics','Home & Furniture','Music & Instruments','Music & Instruments','Music & Instruments','Music & Instruments','Electronics','Jewelry','Jewelry','Jewelry','Jewelry','Jewelry','Accessories','Accessories','Accessories','Accessories','Accessories','Accessories','Health & Beauty','Health & Beauty','Health & Beauty','Health & Beauty','Health & Beauty','Health & Beauty','Health & Beauty','Health & Beauty','Health & Beauty','Health & Beauty','Health & Beauty','Health & Beauty','Health & Beauty','Health & Beauty','Footwear','Clothing','Clothing','Sports & Outdoors','Sports & Outdoors','Sports & Outdoors','Sports & Outdoors','Sports & Outdoors','Sports & Outdoors','Sports & Outdoors','Footwear','Footwear','Footwear','Health & Beauty','Health & Beauty','Health & Beauty','Sports & Outdoors','Sports & Outdoors','Sports & Outdoors','Clothing','Sports & Outdoors','Sports & Outdoors','Outdoor Gear','Outdoor Gear','Outdoor Gear','Outdoor Gear','Outdoor Gear','Sports & Outdoors','Sports & Outdoors','Clothing','Appliances','Toys','Electronics','Clothing','Appliances','Clothing','Electronics','Clothing','Appliances','Toys','Electronics','Electronics','Appliances','Travel & Luggage','Clothing','Electronics','Office & Furniture','Appliances','Home & Furniture','Office & Furniture','Clothing','Appliances','Home & Furniture','Clothing','Home & Furniture','Home & Furniture','Appliances','Home & Furniture','Music & Instruments','Electronics','Appliances','Music & Instruments','Music & Instruments','Home & Furniture','Music & Instruments','Electronics','Accessories','Accessories','Accessories','Jewelry','Accessories','Accessories','Accessories','Accessories','Health & Beauty','Health & Beauty','Health & Beauty','Health & Beauty','Health & Beauty','Health & Beauty','Health & Beauty','Health & Beauty','Health & Beauty','Health & Beauty','Health & Beauty','Health & Beauty','Health & Beauty','Health & Beauty','Footwear','Clothing','Sports & Outdoors','Sports & Outdoors','Sports & Outdoors','Sports & Outdoors','Sports & Outdoors','Exercise Equipment','Exercise Equipment','Footwear','Footwear','Footwear','Health & Beauty','Health & Beauty','Health & Beauty','Outdoor Gear','Outdoor Gear','Sports & Outdoors','Clothing','Sports & Outdoors','Sports & Outdoors','Outdoor Gear','Outdoor Gear','Outdoor Gear','Outdoor Gear','Sports & Outdoors','Sports & Outdoors']

for i,_ in enumerate(products_list):
    product_id = i+1
    product_name = products_list[i]
    category = products_category[i]
    price = round(random.uniform(10, 500), 2)
    cursor.execute(f'INSERT INTO {schema_name}.Products (product_id, product_name, category, price) VALUES (%s, %s, %s, %s)', (product_id, product_name, category, price))

# Commit changes to ensure Users and Products data is available for OrderDetails
conn.commit()

# Generate mock data for Orders and OrderDetails tables
for i in range(order_range):
    user_id = random.randint(1, user_range)
    order_id = i+1
    order_date = fake.date_between(start_date='-2y', end_date='today')
    total_amount = round(random.uniform(10, 500), 2)
    try:
        cursor.execute(f'INSERT INTO {schema_name}.Orders (user_id, order_id, order_date, total_amount) VALUES (%s, %s, %s, %s)', (user_id, order_id, order_date, total_amount))
    except Exception as e:
        print(f"Error inserting order {order_id}: {e}")

for i in range(order_range):
    order_id = random.randint(1, order_range)
    order_detail_id=i+1
    product_id = random.randint(1, len(products_list))
    quantity = random.randint(1, 10)
    cursor.execute(f'INSERT INTO {schema_name}.OrderDetails (order_detail_id, order_id, product_id, quantity) VALUES (%s, %s, %s, %s)', (order_detail_id, order_id, product_id, quantity))


# Commit changes and close the database connection
conn.commit()
conn.close()

print("Data insertion completed successfully.")
