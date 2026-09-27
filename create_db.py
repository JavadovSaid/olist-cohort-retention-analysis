import pandas as pd
from sqlalchemy import create_engine, text

# 1. PostgreSQL Connection parameters
DB_USER = "postgres"
DB_PASSWORD = "your_postgres_password"  # Replace with your actual password
DB_HOST = "localhost"
DB_PORT = "5432"
DB_NAME = "postgres"

db_url = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
engine = create_engine(db_url)

# 2. DDL Statements to Create Tables
ddl = """
DROP TABLE IF EXISTS order_reviews CASCADE;
DROP TABLE IF EXISTS order_payments CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS product_category_name_translation CASCADE;
DROP TABLE IF EXISTS sellers CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS geolocation CASCADE;

CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat NUMERIC(10, 8),
    geolocation_lng NUMERIC(11, 8),
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(10)
);

CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);

CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state VARCHAR(10)
);

CREATE TABLE product_category_name_translation (
    product_category_name VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100)
);

CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50) REFERENCES customers(customer_id),
    order_status VARCHAR(50),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

CREATE TABLE order_items (
    order_id VARCHAR(50) REFERENCES orders(order_id),
    order_item_id INT,
    product_id VARCHAR(50) REFERENCES products(product_id),
    seller_id VARCHAR(50) REFERENCES sellers(seller_id),
    shipping_limit_date TIMESTAMP,
    price NUMERIC(10, 2),
    freight_value NUMERIC(10, 2)
);

CREATE TABLE order_payments (
    order_id VARCHAR(50) REFERENCES orders(order_id),
    payment_sequential INT,
    payment_type VARCHAR(50),
    payment_installments INT,
    payment_value NUMERIC(10, 2)
);

CREATE TABLE order_reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50) REFERENCES orders(order_id),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);
"""

print("Executing DDL statements...")
with engine.connect() as conn:
    conn.execute(text(ddl))
    conn.commit()

# 3. Load all CSVs from Data/ into PostgreSQL
datasets = [
    ("Data/olist_geolocation_dataset.csv", "geolocation", []),
    ("Data/olist_customers_dataset.csv", "customers", []),
    ("Data/olist_sellers_dataset.csv", "sellers", []),
    ("Data/product_category_name_translation.csv", "product_category_name_translation", []),
    ("Data/olist_products_dataset.csv", "products", []),
    (
        "Data/olist_orders_dataset.csv", 
        "orders", 
        [
            "order_purchase_timestamp", "order_approved_at",
            "order_delivered_carrier_date", "order_delivered_customer_date",
            "order_estimated_delivery_date"
        ]
    ),
    ("Data/olist_order_items_dataset.csv", "order_items", ["shipping_limit_date"]),
    ("Data/olist_order_payments_dataset.csv", "order_payments", []),
    ("Data/olist_order_reviews_dataset.csv", "order_reviews", ["review_creation_date", "review_answer_timestamp"])
]

for filepath, table_name, date_cols in datasets:
    print(f"Loading {table_name}...")
    df = pd.read_csv(filepath)
    for col in date_cols:
        df[col] = pd.to_datetime(df[col])
    df.to_sql(table_name, engine, if_exists="append", index=False)

print("All 9 datasets successfully loaded into PostgreSQL!")