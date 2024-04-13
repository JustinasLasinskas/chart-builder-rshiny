library(shiny)
library(dplyr)
library(datasets)
library(htmlwidgets)
library(sortable)

# Specify the application port
options(shiny.host = "0.0.0.0")
options(shiny.port = 3838)


df <- mtcars
icon_list <- function(x){
  lapply(
    x,
    function(x) {
      tags$div(x)
    }
  )
}

# FRONTEND
ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      #sidebar {
        height: 100vh;
      }"))
  ),
  # Application title
  titlePanel("Chart builder"),
  sidebarLayout(
    sidebarPanel(id="sidebar",
      h4(textOutput("topText")),
      fileInput(
        "dataUpload",
        "",
        multiple = FALSE,
        accept = NULL,
        width = NULL,
        buttonLabel = "Browse...",
        placeholder = "No file selected",
        capture = NULL
      ),
      br(),
      h4(textOutput("columnText")),
      tags$div(
        class = "colnamesDiv",
        id = "sort1",
        icon_list(names(df))
      )
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Chart",
                 tags$div(class="xAxisDataContainer",style = "display:flex; flex-direction: horizontal; width: 100%; height: 30px; border: 1px #CCC solid; border-radius: 5px; margin-top:20px; padding-left:10px; align-items:center;",
                          tags$div(style = "margin-right: 30px;", "X axis:"),
                          tags$div(id = "sort2", style="background-color:#CCC; border-radius: 10px; margin-right: 20px; padding-left: 20px; padding-right: 20px; display: flex; flex-direction:horizontal;")),
                 tags$div(class="yAxisDataContainer",style = "display:flex; flex-direction: horizontal; width: 100%; height: 30px; border: 1px #CCC solid; border-radius: 5px; margin-top:10px; padding-left:10px; align-items:center;",
                          tags$div(style = "margin-right: 30px;", "Y axis:"),
                          tags$div(id = "sort3", style="background-color:#CCC; border-radius: 10px; margin-right: 20px; padding-left: 20px; padding-right: 20px; display: flex; flex-direction:horizontal;")),
                 br(),
                 selectInput("chartType", "Select Chart Type", choices = c("Line chart", "Bar chart", "Scatter plot")),
                 h3(textOutput("chType")),
                 plotOutput("mainChart"),
                 br(),
                 actionButton(style="display:flex;","downloadButton", "Download Chart"),
                 
                 # SORTABLE LISTS
                # colnames js
                 sortable_js(
                   "sort1",
                   options = sortable_options(
                     group = list(
                       pull = "clone",
                       name = "sortGroup1",
                       put = FALSE
                     ),
                     # swapClass = "sortable-swap-highlight",
                     onSort = sortable_js_capture_input("sort_vars")
                   )
                 ),
                # x axis js
                 sortable_js(
                   "sort2",
                   options = sortable_options(
                     group = list(
                       group = "sortGroup1",
                       put = JS("function (to) { return to.el.children.length < 1; }"),
                       pull = TRUE
                     ),
                     swapClass = "sortable-swap-highlight",
                     onSort = sortable_js_capture_input("sort_x")
                   )
                 ),
                # y axis js
                 sortable_js(
                   "sort3",
                   options = sortable_options(
                     group = list(
                       group = "sortGroup1",
                       put = JS("function (to) { return to.el.children.length < 1; }"),
                       pull = TRUE
                     ),
                     swapClass = "sortable-swap-highlight",
                     onSort = sortable_js_capture_input("sort_y")
                   )
                 ),
                # delete js
                 sortable_js(
                   "sort1",
                   options = sortable_options(
                     group = list(
                       group = "sortGroup1",
                       put = TRUE,
                       pull = TRUE
                     ),
                     onAdd = JS("function (evt) { this.el.removeChild(evt.item); }")
                   )
                 )
        ),
        tabPanel("Data",
                 tableOutput("dataTable")
                 ),
        tabPanel("Docs", tags$div(
          HTML("
        <h2>How to Use a Chart Builder</h2>
        <p>A chart builder is a tool that allows you to create a variety of charts and graphs to visualize your data. Here's a step-by-step guide on how to use it:</p>
        <ol>
          <li><strong>Select Chart Type</strong>: The first step in using a chart builder is to select the type of chart you want to create. This could be a bar chart, line chart, pie chart, scatter plot, etc. The choice of chart type depends on the nature of your data and what you want to illustrate.</li>
          <li><strong>Input Data</strong>: After selecting the chart type, the next step is to input your data into the chart builder. This could involve uploading a data file, pasting data directly into the tool, or connecting to a database. Make sure your data is in the correct format required by the tool.</li>
          <li><strong>Configure Chart</strong>: Once your data is loaded, you can configure your chart. This involves setting various options such as the labels for the x-axis and y-axis, the title of the chart, the color scheme, etc. Some chart builders also allow you to perform transformations on your data at this stage.</li>
          <li><strong>Preview and Adjust</strong>: After configuring your chart, you can preview it. If you're not satisfied with how it looks, you can go back and adjust the settings until you get the desired result.</li>
          <li><strong>Export Chart</strong>: Once you're happy with your chart, you can export it. Most chart builders allow you to export your chart in a variety of formats such as PNG, JPEG, SVG, or PDF. Some also allow you to embed the chart directly into a webpage.</li>
        </ol>")
        )
        ))

    )
  )
)

# BACKEND
server <- function(input, output, session) {
  # render a chart
  output$mainChart <- renderPlot({
    plot(mtcars$mpg, type = 's')
  })
  
  # change chart type button
  output$chType <- renderText({
    paste0("Your ",input$chartType,":")
  })
  
  # render data table in tab 2
  output$dataTable <- renderTable({df})
  
  # render top text
  output$topText <- renderText("Upload your dataset:")
  # render col text
  output$columnText <- renderText("Column names:")
  
}

shinyApp(ui, server)