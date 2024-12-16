#!/bin/bash

# Build the Docker image
docker build -t organoid-shiny-app .

# Run the container with mounted data volume
docker run --rm -p 3838:3838 \
  -v "$(pwd)/data:/srv/shiny-server/myapp/data" \
  organoid-shiny-app