#!/bin/bash
set -e

# Wait for the database to be ready
airflow db check

# Upgrade the database (safer than init for production)

airflow db init
airflow db migrate

# Create admin user
airflow users create \
  --username admin \
  --password admin \
  --firstname Air \
  --lastname Flow \
  --role Admin \
  --email admin@example.com

# Start the webserver
exec airflow webserver