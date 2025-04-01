#!/bin/bash
set -e

# Print current environment for debugging
echo "Current user: $(whoami)"
echo "Home directory: $HOME"
echo "Current directory: $(pwd)"
echo "PATH: $PATH"

# Verify airflow executable exists and has proper permissions
AIRFLOW_EXEC="/home/airflow/.local/bin/airflow"
if [ -f "$AIRFLOW_EXEC" ]; then
  echo "Airflow executable exists at $AIRFLOW_EXEC"
  ls -la "$AIRFLOW_EXEC"
else
  echo "ERROR: Airflow executable not found at $AIRFLOW_EXEC"
  find /home -name "airflow" -type f 2>/dev/null || echo "Could not locate airflow executable"
  exit 1
fi

echo "Airflow version: $($AIRFLOW_EXEC version || echo 'COMMAND FAILED')"

# Wait for the database to be ready
$AIRFLOW_EXEC db check || { echo "Database check failed"; exit 1; }

# Initialize/upgrade the database
$AIRFLOW_EXEC db init || { echo "Database init failed"; exit 1; }
$AIRFLOW_EXEC db migrate || { echo "Database migrate failed"; exit 1; }


# Create admin user
$AIRFLOW_EXEC users create \
  --username admin \
  --password admin \
  --firstname Air \
  --lastname Flow \
  --role Admin \
  --email admin@example.com

# Start the webserver
$AIRFLOW_EXEC webserver