from pathlib import Path
import pandas as pd

data_dir = Path(__file__).resolve().parent.parent / "data" / "raw"

for file in sorted(data_dir.glob("*.csv")):
    df = pd.read_csv(file)

    print(f"\n{'=' * 50}"
          f"\nTable: {file.stem}"
          f"\n{'=' * 50}")

    print(f"Rows: {len(df):,}"
          f"\nColumns: {len(df.columns):,}"
          f"\nDuplicates: {df.duplicated().sum():,}")

    print("\nColumns:"
          f"{df.dtypes.to_string()}")

    print("\nMissing values:")
    missing = df.isnull().sum()
    print(missing[missing > 0 ].to_string() if missing.any()
          else "No missing values")

    print(f"\nSample data:\n{df.head().to_string(index=False)}")