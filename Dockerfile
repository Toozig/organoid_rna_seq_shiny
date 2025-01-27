# Use rocker/shiny as base image
FROM rocker/shiny:4.3.1

# Install system dependencies required for R packages
RUN apt-get update && apt-get install -y \
    libcurl4-gnutls-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev \
    && rm -rf /var/lib/apt/lists/*

# Remove default index page and sample apps
RUN rm -rf /srv/shiny-server/*

# Create app directory
RUN mkdir -p /srv/shiny-server/organoid-RNA-seq-app/R
RUN mkdir -p /srv/shiny-server/organoid-RNA-seq-app/www
RUN mkdir -p /srv/shiny-server/organoid-RNA-seq-app/data

# Copy app files
COPY . /srv/shiny-server/organoid-RNA-seq-app/

# Make all app files readable
RUN chmod -R 755 /srv/shiny-server/organoid-RNA-seq-app

# Install renv and restore packages
RUN R -e 'install.packages("renv", repos = "https://cloud.r-project.org")' && \
    cd /srv/shiny-server/organoid-RNA-seq-app && \
    R -e 'renv::restore()'

# Create a symbolic link to make the app the default
RUN ln -s /srv/shiny-server/organoid-RNA-seq-app /srv/shiny-server/index

# Expose port 3838 (default for Shiny)
EXPOSE 3838

# Run the Shiny app
CMD ["/usr/bin/shiny-server"]