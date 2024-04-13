# Base R Shiny image
FROM rocker/shiny

# Make a directory in the container
RUN mkdir /chart-builder-app

# Copy the current directory contents into the container at /app
COPY /app /chart-builder-app

# Install R dependencies
RUN R -e "install.packages(c('dplyr','sortable','htmlwidgets'), repos='http://cran.rstudio.com/')"

# Expose the application port
EXPOSE 3838

# Run the R Shiny app
CMD Rscript /chart-builder-app/app.R