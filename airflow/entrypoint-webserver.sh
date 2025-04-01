#!/bin/bash
set -e

# Ensure airflow command is in PATH
export PATH="/home/airflow/.local/bin:$PATH"
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