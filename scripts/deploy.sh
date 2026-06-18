#!/bin/bash

set -e

echo "Building image..."

sudo docker build -t sample-api:new .

echo "Starting new container..."

sudo docker run -d \
  --name sample-api-new \
  -p 5012:5010 \
  --log-driver json-file \
  --log-opt max-size=10m \
  --log-opt max-file=3 \
  sample-api:new

echo "Waiting for health check..."

for i in {1..30}
do
    if curl -f http://localhost:5012 >/dev/null 2>&1
    then
        echo "Health check passed"
        break
    fi

    sleep 1
done

if ! curl -f http://localhost:5012 >/dev/null 2>&1
then
    echo "Health check failed"

    sudo docker rm -f sample-api-new

    exit 1
fi

sudo docker rm -f sample-api || true

sudo docker rename sample-api-new sample-api

echo "Deployment successful"
