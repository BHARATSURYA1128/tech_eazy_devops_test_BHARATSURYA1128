#!/bin/bash

# Load environment config
source dev_config.env

echo "Deploying $APP_NAME in $ENVIRONMENT environment..."

# Stop existing process if any
sudo pkill -f "$APP_NAME" || true

# Rebuild the app
mvn clean package

# Run on specified port
sudo nohup java -jar target/${APP_NAME}-0.0.1-SNAPSHOT.jar --server.port=${PORT} > log.txt 2>&1 &

echo "App deployed on port $PORT"

# Schedule shutdown
sudo shutdown -h +$SHUTDOWN_TIMER_MINUTES
