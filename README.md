# Chart Builder

Chart builder application built with RShiny and R. It allows users to create and customize various types of charts.

## TO DO

- Chart creation based on drag-n-drop inputs
- Chart exports
- Column Filtering
- Chart type selection
- Chart customisation

## Features

- Choose from a variety of chart types, including bar charts, line charts, pie charts, etc.
- Customize chart appearance, such as colors, labels, and titles.
- Import data from various sources, such as CSV files or databases.
- Export charts as image files or shareable links.

## Installation

1. Clone this repository: `git clone https://github.com/JustinasLasinskas/chart-builder.git`
2. Install the required R packages by running `install.packages(c("shiny", "dplyr", "sortable","htmlwidgets"))` in your R console and run the app.
3. Or run a docker container by running `docker run -p 3838:3838 chart-builder-app` in terminal and going to `http://localhost:3838` in your browser.

## MIT License

The MIT License is a permissive open-source license that allows you to use, modify, and distribute the code in both commercial and non-commercial projects. It also provides you with the freedom to sublicense the code under different terms if needed.
