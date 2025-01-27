FROM rocker/verse:4.3.1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-gnutls-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev \
    && rm -rf /var/lib/apt/lists/*

# Create app directory
RUN mkdir -p /home/rstudio/app

# Set working directory
WORKDIR /home/rstudio/app

# Give write permissions to rstudio user
RUN chown -R rstudio:rstudio /home/rstudio/app

# Install development tools and required packages from CRAN
RUN R -e 'install.packages(c(\
    "httpgd", \
    "languageserver", \
    # Add your required packages here, for example:
    "shiny", \
    "tidyverse", \
    "DT", \
    "plotly" \
    ), repos="https://cloud.r-project.org")' 