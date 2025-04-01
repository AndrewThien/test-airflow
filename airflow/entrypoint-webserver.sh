#!/bin/bash
set -e

# Print current user and environment for debugging
echo "Current user: $(whoami)"
echo "Home directory: $HOME"
echo "Current directory: $(pwd)"
echo "PATH before: $PATH"

# Try to find airflow executable
find / -name airflow 2>/dev/null || echo "Airflow executable not found in filesystem"

# Add possible locations to PATH
export PATH="/opt/airflow/bin:/usr/local/airflow/bin:/home/airflow/.local/bin:$PATH"
echo "PATH after: $PATH"

# Check if Airflow CLI is available
if ! command -v airflow &> /dev/null; then
    echo "Error: Airflow command not found"
    
    # Try installing airflow if not available
    echo "Attempting to install/repair Airflow..."
    pip install "apache-airflow==2.10.5"
    
    # Check again
    if ! command -v airflow &> /dev/null; then
        echo "Failed to find or install Airflow. Exiting."
        exit 1
    fi
fi

# Optional: Verify Airflow version
echo "Airflow version: $(airflow version)"

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