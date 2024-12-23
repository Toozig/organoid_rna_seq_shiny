#!/bin/bash

# Build and run the development container
docker build -t organoid-rna-seq-dev -f Dockerfile.dev .
docker run -p 3838:3838 organoid-rna-seq-dev 