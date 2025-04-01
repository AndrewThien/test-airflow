#!/bin/bash
set -e

# Wait for the database to be ready
airflow db check

# Initialize/upgrade the database
airflow db init
airflow db migrate

# Start the scheduler
exec airflow scheduler