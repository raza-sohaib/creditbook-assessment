FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

RUN pip install --no-cache-dir \
    boto3 \
    pandas \
    sqlalchemy \
    psycopg2-binary \
    pyarrow

COPY export_daily_performance.py /app/export_daily_performance.py

CMD ["tail", "-f", "/dev/null"]
