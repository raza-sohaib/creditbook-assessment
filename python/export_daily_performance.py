from pathlib import Path
from datetime import datetime, timedelta, timezone
import os
import boto3
import pandas as pd
from sqlalchemy import create_engine

UTC = timezone.utc
cutoff = datetime.now(UTC) - timedelta(days=1)

def get_engine():
    user = os.getenv("PGUSER")
    password = os.getenv("PGPASSWORD")
    host = os.getenv("PGHOST")
    port = os.getenv("PGPORT")
    db = os.getenv("PGDATABASE")
    return create_engine(f"postgresql+psycopg2://{user}:{password}@{host}:{port}/{db}")

def main():
    engine = get_engine()
    query = """
        select *
        from marts.mart_loan_performance
        where updated_at >= %(cutoff)s
    """
    df = pd.read_sql(query, engine, params={"cutoff": cutoff.replace(tzinfo=None)})

    now = datetime.now(UTC)
    yyyy = now.strftime("%Y")
    mm = now.strftime("%m")
    dd = now.strftime("%d")

    local_dir = Path("/tmp") / "daily_performance.parquet"
    df.to_parquet(local_dir, index=False)

    s3 = boto3.client("s3")
    bucket = os.getenv("EXPORT_BUCKET")
    key = f"exports/daily_performance/{yyyy}/{mm}/{dd}/daily_performance.parquet"
    s3.upload_file(str(local_dir), bucket, key)
    print(f"Uploaded s3://{bucket}/{key}")

if __name__ == "__main__":
    main()
