# Use rocker/shiny as base image
FROM rocker/shiny:4.3.1

# Install system dependencies required for R packages
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

# Remove default index page and sample apps
RUN rm -rf /srv/shiny-server/*

# Create app directory
RUN mkdir -p /srv/shiny-server/organoid-RNA-seq-app/R
RUN mkdir -p /srv/shiny-server/organoid-RNA-seq-app/www
RUN mkdir -p /srv/shiny-server/organoid-RNA-seq-app/data

# Copy app files
COPY app.R /srv/shiny-server/organoid-RNA-seq-app/
COPY global.R /srv/shiny-server/organoid-RNA-seq-app/
COPY R/ /srv/shiny-server/organoid-RNA-seq-app/R/
COPY www/ /srv/shiny-server/organoid-RNA-seq-app/www/

# Copy data file
COPY data/tpm_df.tsv /srv/shiny-server/organoid-RNA-seq-app/data/

# Make all app files readable
RUN chmod -R 755 /srv/shiny-server/organoid-RNA-seq-app

# Create a symbolic link to make the app the default
RUN ln -s /srv/shiny-server/organoid-RNA-seq-app /srv/shiny-server/index

# Expose port 3838 (default for Shiny)
EXPOSE 3838

# Run the Shiny app
CMD ["/usr/bin/shiny-server"]