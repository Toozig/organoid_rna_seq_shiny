#!/bin/bash

# Build the Docker image
docker build -t organoid-shiny-app .

# Run the container with mounted data volume and expose to network
docker run --rm -p 0.0.0.0:8000:3838 \
  -v "$(pwd)/data:/srv/shiny-server/organoid-RNA-seq-app/data" \
  organoid-shiny-app