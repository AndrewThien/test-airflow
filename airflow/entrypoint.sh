#!/bin/bash
set -e

# Initialize the database
airflow db init

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