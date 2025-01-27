library(shiny)
library(shinyjs)
source("global.R")
source("R/data_utils.R")
source("R/plot_utils.R")

# Initialize renv
if (!requireNamespace("renv", quietly = TRUE)) {
  install.packages("renv")
}
renv::restore()

# UI Definition
ui <- fluidPage(
  useShinyjs(),
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
  ),
  titlePanel("RNA Seq Results"),
  sidebarLayout(
    sidebarPanel(
      helpText("Show gene specific expression (in TPM)."),
      selectizeInput("gene_name",
        label = "Choose gene name(s):",
        choices = NULL,
        selected = NULL,
        multiple = TRUE,
        options = list(maxOptions = 10000)
      ),
      div(
        style = "margin-bottom: 15px;",
        helpText("Filter by source:"),
        checkboxGroupInput("source_filter",
          label = NULL,
          choices = c("Testis" = CELL_TYPE_TESTIS, "Organoid" = CELL_TYPE_ORGANOID),
          selected = c(CELL_TYPE_TESTIS, CELL_TYPE_ORGANOID),
          inline = TRUE
        )
      ),
      checkboxInput("show_samples",
        label = "Show individual samples",
        value = FALSE
      ),
      checkboxInput("log_scale",
        label = "Log scale",
        value = FALSE
      ),
      div(
        id = "facet_by_source",
        checkboxInput("facet_by_source",
          label = "Split by source (Organoid/Testis)",
          value = TRUE
        )
      ),
      conditionalPanel(
        condition = "input.facet_by_source == true",
        checkboxInput("share_y",
          label = "Share Y-axis scale",
          value = FALSE
        )
      ),
      width = 2
    ),
    mainPanel(
      width = 10,
      div(
        id = "gridScatter",
        style = "height: calc(100vh - 50px);",  # Dynamic height
        plotlyOutput("gridScatter", height = "95%")
      )
    )
  )
)

# Server Definition
server <- function(input, output, session) {
  updateSelectizeInput(session, "gene_name",
    choices = ord_mtx$gene_name,
    selected = c("Amh", "Wnt4"),
    server = TRUE
  )
  observe({
    if (length(input$source_filter) == 0) {
      updateCheckboxGroupInput(session, "source_filter",
        selected = isolate(setdiff(c(CELL_TYPE_TESTIS, CELL_TYPE_ORGANOID), 
                                 input$source_filter))
      )
    }
  })
  observe({
    req(input$gene_name)
    data <- sort_data(
      group_means_melted,
      input$gene_name,
      input$show_samples,
      input$log_scale,
      source_filter = input$source_filter
    )
    print(names(data))
  })

  # Add reactive for source filter length
  has_multiple_sources <- reactive({
    length(input$source_filter) > 1
  })

  # Update facet_by_source visibility and value based on source selection
  observe({
    if (!has_multiple_sources()) {
      updateCheckboxInput(session, "facet_by_source", value = FALSE)
      # Hide the checkbox using shinyjs
      shinyjs::hide("facet_by_source")
    } else {
      shinyjs::show("facet_by_source")
    }
  })

  output$gridScatter <- renderPlotly({
    req(input$gene_name)

    data <- sort_data(
      group_means_melted,
      input$gene_name,
      input$show_samples,
      input$log_scale,
      source_filter = input$source_filter
    )

    create_scatter_plot(
      data,
      input$show_samples,
      input$log_scale,
      input$facet_by_source,
      input$share_y
    )
  })
}

# Run the app
shinyApp(ui = ui, server = server)
