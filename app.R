library(shiny)
source("global.R")
source("R/data_utils.R")
source("R/plot_utils.R")
source("R/ui_utils.R")

# UI Definition
ui <- fluidPage(
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
      checkboxInput("show_samples",
        label = "Show individual samples",
        value = FALSE
      ),
      checkboxInput("log_scale",
        label = "Log scale",
        value = FALSE
      ),
      numericInput("facet_ncol",
        label = "Number of columns",
        value = 1,
        min = 1,
        max = 10
      ),
      width = 2
    ),
    mainPanel(
      width = 10,
      div(
        id = "gridScatter",
        plotlyOutput("gridScatter")
      )
    )
  )
)

# Server Definition
server <- function(input, output, session) {
  updateSelectizeInput(session, "gene_name",
    choices = ord_mtx$gene_name,
    selected = "Amh",
    server = TRUE
  )

  output$gridScatter <- renderPlotly({
    req(input$gene_name)

    data <- sort_data(
      group_means_melted, input$gene_name,
      input$show_samples, input$log_scale
    )

    create_scatter_plot(
      data, 
      is_first_plot = TRUE,
      input$show_samples, 
      input$log_scale,
      input$facet_ncol
    )
  })
}

# Run the app
shinyApp(ui = ui, server = server)
