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

# Create app directory
RUN mkdir /srv/shiny-server/myapp

# Copy app files
COPY app.R /srv/shiny-server/myapp/
COPY global.R /srv/shiny-server/myapp/
COPY R/ /srv/shiny-server/myapp/R/
COPY www/ /srv/shiny-server/myapp/www/

# Copy data file
COPY data/rsem.merged.gene_tpm.tsv /srv/shiny-server/myapp/data/

# Update global.R to use the correct data path
RUN sed -i 's|/home/ls/toozig/gonen-lab/users/toozig/testis_organoids_project/organoids_RNA_seq/organoids_nf-core-rnaseq_v3.16.0_r0/star_rsem/rsem.merged.gene_tpm.tsv|/srv/shiny-server/myapp/data/rsem.merged.gene_tpm.tsv|g' /srv/shiny-server/myapp/global.R

# Make all app files readable
RUN chmod -R 755 /srv/shiny-server/myapp

# Expose port 3838 (default for Shiny)
EXPOSE 3838

# Run the Shiny app
CMD ["/usr/bin/shiny-server"] 