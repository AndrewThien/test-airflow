#!/bin/bash
set -e

# Print current environment for debugging
echo "Current user: $(whoami)"
echo "Home directory: $HOME"
echo "Current directory: $(pwd)"
echo "PATH: $PATH"
echo "Airflow version: $(airflow version || echo 'COMMAND FAILED')"

# Wait for the database to be ready
airflow db check || { echo "Database check failed"; exit 1; }

# Initialize/upgrade the database
airflow db init || { echo "Database init failed"; exit 1; }
airflow db migrate || { echo "Database migrate failed"; exit 1; }

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