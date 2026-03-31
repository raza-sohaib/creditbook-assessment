# CreditBook Assessment

This repository contains a local assessment setup using PostgreSQL, dbt, and Python. It lets you load the provided CSV files, build the analytics model, validate the tables with dbt tests, and export the daily performance file to S3.

## Project contents
- `data/` - source CSV files loaded into PostgreSQL
- `init_sql/` - database bootstrap scripts and seed loading SQL
- `dbt/` - dbt project containing staging and mart models
- `python/` - Python export job for the daily parquet file
- `docker-compose.yml` - local orchestration for PostgreSQL, dbt, and Python

## Prerequisites
- Docker Desktop installed and running
- Docker Compose available through `docker compose`
- The assessment CSV files are placed in the `data/` folder (do not rename the files)

## Local setup
1. Clone or download the repository.
2. Open [docker-compose.yml](/d:/CreditBook%20Assessment/docker-compose.yml) and replace the AWS settings in the `python` service with your own values before starting the stack:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `AWS_DEFAULT_REGION`
   - `EXPORT_BUCKET`
3. Start the local services:
   ```bash
   docker compose up -d
   ```
4. Confirm the containers are running:
   ```bash
   docker compose ps
   ```
5. Optional: verify PostgreSQL is reachable:
   ```bash
   docker compose exec postgres psql -U creditbook -d creditbook
   ```

## Build the assessment tables
Run dbt inside the dbt container:

```bash
docker compose exec dbt bash
```

Then execute:

```bash
dbt debug
dbt run
```

`dbt run` builds the staging models and the final mart table, including `marts.mart_loan_performance`.

## Test the assessment
After the models are built, run:

```bash
dbt test
```

This checks that the tables were created correctly and that the dbt tests defined in the project pass.

If you want to run both build and validation in one go from your machine, you can use:

```bash
docker compose exec dbt bash -lc "dbt run && dbt test"
```

## Run the Python export to S3
Once `dbt run` has built the mart, execute the export job:

```bash
docker compose exec python python /app/python/export_daily_performance.py
```

What this script does:
- reads records from `marts.mart_loan_performance`
- filters rows updated in the last day
- writes a parquet file
- uploads it to your S3 bucket under a dated path

Before running the export, make sure you already replaced the AWS key, AWS secret, region, and bucket name in [docker-compose.yml](/d:/CreditBook%20Assessment/docker-compose.yml) with your own values.

## Reset and rebuild from scratch
If you want to fully recreate the local database:

```bash
docker compose down -v
docker compose up -d
```

Then rerun:

```bash
docker compose exec dbt bash -lc "dbt run && dbt test"
```

## Default local database connection
- Host: `localhost`
- Port: `5432`
- Database: `creditbook`
- User: `creditbook`
- Password: `creditbook`

## Notes
- The provided assessment references `decrypt_pii(json_blob)`, but PostgreSQL does not include that function by default. The current implementation keeps encrypted values as-is unless a warehouse-specific decryption UDF is added.
- `dim_partners` and `dim_entities` behave like SCD Type 2 dimensions in the source shape, but for this assessment they are treated as no-history-tracking dimensions. Because of that, joins to those tables explicitly filter to the current record using `valid_to >= '9999-12-31'`.
- The export script is located at [export_daily_performance.py](/d:/CreditBook%20Assessment/python/export_daily_performance.py).
- The main mart model is located at [mart_loan_performance.sql](/d:/CreditBook%20Assessment/dbt/models/marts/mart_loan_performance.sql).

## Technical discussion

### Discussion Questions
1. In a model without SCD (historical tracking), what happens to the reporting of a loan if a borrower changes their name or a partner changes their status?

   Answer: In a model without SCD (historical tracking), the attributes are overridden showing the latest state. For instance, in terms to the reporting of a loan if the borrower name changes it will be shown on all of its previous loans as well and/or the new partner's status instead of the status at load origination time.

2. How would you optimize the hourly incremental run if `fct_transactions` grows to 1 billion rows?

   Answer: We have our hourly incremental run which only fetches transactions for last 2 hours only (1 hour for the incremental load and extra hour for any late arriving data). To further optimize the incremental run, we can improve the table performance offered by the Data Warehouse (i.e. Indexing, Partitioning and Distribution etc). For example, in Amazon Redshift, we can add `created_at` as partition key to limit data scanning and set distribution type as  `key` and use the column used in joins with highest cardinality (i.e. `service_id` in our case) 

3. How should we manage the decryption key for `decrypt_pii` to ensure security while maintaining analytic utility?

   Answer: We can use secret managers (like AWS Secrets Manager and Azure Key Vault etc) to store the keys with defined policies to allow access to specified roles and services, and should rotate the keys regularly
