#!/bin/bash
set -e

# Ensure airflow command is in PATH
export PATH="/home/airflow/.local/bin:$PATH"

# Start the scheduler
exec airflow scheduler