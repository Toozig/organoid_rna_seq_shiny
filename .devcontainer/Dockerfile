FROM rocker/verse:4.3.1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-gnutls-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev \
    && rm -rf /var/lib/apt/lists/*

# Install required R packages
RUN R -e "install.packages(c(\
    'shiny', \
    'readr', \
    'stringr', \
    'tidyr', \
    'dplyr', \
    'reshape2', \
    'coin', \
    'plotly', \
    'bslib', \
    'shinyjs' \
    ), repos='https://cran.rstudio.com/')"

# Create app directory
RUN mkdir -p /home/rstudio/app

# Set working directory
WORKDIR /home/rstudio/app

# Give write permissions to rstudio user
RUN chown -R rstudio:rstudio /home/rstudio/app 