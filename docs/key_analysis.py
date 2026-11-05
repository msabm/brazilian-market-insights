from pathlib import Path
import pandas as pd

data_dir = Path(__file__).resolve().parent.parent / "data" / "raw"

def load(name):
    return pd.read_csv(data_dir / f"olist_{name}_dataset.csv")

customers = load("customers")
orders = load("orders")
items = load("order_items")
payments = load("order_payments")
reviews = load("order_reviews")
products = load("products")
sellers = load("sellers")
geo = load("geolocation")

checks = {
    "customers.customer_id": (customers, ["customer_id"]),
    "customers.customer_unique_id": (customers, ["customer_unique_id"]),
    "orders.order_id": (orders, ["order_id"]),
    "products.product_id": (products, ["product_id"]),
    "sellers.seller_id": (sellers, ["seller_id"]),
    "items.order_id": (items, ["order_id", "order_item_id"]),
    "payments.order_id + payment_sequential": (
        payments, ["order_id", "payment_sequential"]),
    "reviews.review_id": (reviews, ["review_id"]),
    "category translation key": (
        pd.read_csv(data_dir / "product_category_name_translation.csv"),
        ["product_category_name"]),
}

print(f"\nUniqueness checks:"
      f"\n{'=' * 50}")

# Check for duplicates in key columns
for name, (df, cols) in checks.items():
    duplicates = df.duplicated(subset=cols).sum()
    print(f"{name}: {duplicates:,} duplicates")

print(f"\nForeign key checks:"
      f"\n{'=' * 50}")

relationships = [
    ("orders.customer_id", orders, "customer_id", customers, "customer_id"),
    ("items.order_id", items, "order_id", orders, "order_id"),
    ("items.product_id", items, "product_id", products, "product_id"),
    ("items.seller_id", items, "seller_id", sellers, "seller_id"),
    ("payments.order_id", payments, "order_id", orders, "order_id"),
    ("reviews.order_id", reviews, "order_id", orders, "order_id"),
]

for name, child, child_col, parent, parent_col in relationships:
    orphan_count = (
        ~child[child_col].isin(parent[parent_col])
    ).sum()
    print(f"{name}: {orphan_count:,} unmatched records")

print(f"\nGeolocation checks:"
      f"\n{'=' * 50}")

print(f"Unique ZIP codes: {geo['geolocation_zip_code_prefix'].nunique()}"
      f"\nZIP code prefixes with multiple locations: {(geo.groupby('geolocation_zip_code_prefix').size() > 1).sum()}")

print(f"\nCustomer checks:"
      f"\n{'=' * 50}")

print(f"\nCustomer records: {len(customers)}"
      f"\nUnique  customer IDs: {customers["customer_id"].nunique()}"
      )

print(f"\nReview duplicates check:"
      f"\n{'=' * 50}")

duplicate_reviews = reviews [
    reviews.duplicated(subset=["review_id"], keep=False)
].sort_values("review_id")

print(f"\nRows with repeated review IDs: {len(duplicate_reviews)}"
      f"\nDistinct review IDs: {duplicate_reviews['review_id'].nunique()}"
      f"\nRepeated review IDs linked to multiple orders: {(duplicate_reviews.groupby('review_id')['order_id'].nunique() > 1).sum()}"
      f"\nDuplicate review IDs + order IDs combo: {reviews.duplicated(subset=['review_id', 'order_id']).sum()}"
      f"\nSample duplicated records:\n{
          (duplicate_reviews[['review_id', 'order_id', 'review_score',
                              'review_creation_date', 'review_answer_timestamp']
                              ].head().to_string(index=False))
      }"
      )