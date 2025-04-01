#!/bin/bash
set -e

# Check if Airflow CLI is available
if ! command -v airflow &> /dev/null; then
    echo "Error: Airflow command not found"
    echo "PATH: $PATH"
    exit 1
fi

# Optional: Verify Airflow version
echo "Airflow version: $(airflow version)"

# Wait for the database to be ready
airflow db check

# Initialize/upgrade the database
airflow db init
airflow db migrate

# Start the scheduler
exec airflow scheduler