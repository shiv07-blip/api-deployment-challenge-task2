#!/bin/bash

echo "Building image..."

sudo docker build -t sample-api:new .

echo "Starting new container..."

sudo docker run -d \
--name sample-api-new \
-p 5011:5010 \
sample-api:new

echo "Waiting for health check..."

sleep 10

curl -f http://localhost:5011

if [ $? -ne 0 ]; then

  echo "Deployment failed"

  sudo docker rm -f sample-api-new

  exit 1

fi

echo "Replacing old container..."

sudo docker rm -f sample-api || true

sudo docker rename sample-api-new sample-api

echo "Deployment successful"

