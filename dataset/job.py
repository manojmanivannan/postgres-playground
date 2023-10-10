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
product_range = 20 # Adjust the number products you need
order_range = 100
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
    CREATE TABLE {schema_name}.Users (
        user_id INTEGER PRIMARY KEY,
        username TEXT,
        email TEXT,
        registration_date DATE
    )
''')

# Create Products Table
cursor.execute(f'''
    CREATE TABLE {schema_name}.Products (
        product_id INTEGER PRIMARY KEY,
        product_name TEXT,
        category TEXT,
        price REAL
    )
''')

# Create Orders Table
cursor.execute(f'''
    CREATE TABLE {schema_name}.Orders (
        order_id INTEGER PRIMARY KEY,
        user_id INTEGER,
        order_date DATE,
        total_amount REAL,
        FOREIGN KEY (user_id) REFERENCES {schema_name}.Users(user_id)
    )
''')

# Create OrderDetails Table
cursor.execute(f'''
    CREATE TABLE {schema_name}.OrderDetails (
        order_detail_id INTEGER PRIMARY KEY,
        order_id INTEGER,
        product_id INTEGER,
        quantity INTEGER,
        FOREIGN KEY (order_id) REFERENCES {schema_name}.Orders(order_id),
        FOREIGN KEY (product_id) REFERENCES {schema_name}.Products(product_id)
    )
''')

# Generate mock data for Users and Products tables
for i in range(user_range):
    user_id = i+1
    username = fake.user_name()
    email = fake.email()
    registration_date = fake.date_between(start_date='-5y', end_date='today')
    cursor.execute(f'INSERT INTO {schema_name}.Users (user_id, username, email, registration_date) VALUES (%s, %s, %s, %s)', (user_id, username, email, registration_date))

for i in range(product_range):
    product_id = i+1
    product_name = fake.unique.first_name()
    category = fake.word(ext_word_list=['Electronics', 'Clothing', 'Books', 'Toys'])
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
    cursor.execute(f'INSERT INTO {schema_name}.Orders (user_id, order_id, order_date, total_amount) VALUES (%s, %s, %s, %s)', (user_id, order_id, order_date, total_amount))

for i in range(50):
    order_id = random.randint(1, order_range)
    order_detail_id=i+1
    product_id = random.randint(1, 20)
    quantity = random.randint(1, 5)
    cursor.execute(f'INSERT INTO {schema_name}.OrderDetails (order_detail_id, order_id, product_id, quantity) VALUES (%s, %s, %s, %s)', (order_detail_id, order_id, product_id, quantity))


# Commit changes and close the database connection
conn.commit()
conn.close()

print("Data insertion completed successfully.")