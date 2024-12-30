library(shiny)
source("global.R")
source("R/data_utils.R")
source("R/plot_utils.R")

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
      checkboxInput("facet_by_source",
        label = "Split by source (Organoid/Testis)",
        value = TRUE
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

  output$gridScatter <- renderPlotly({
    req(input$gene_name)

    data <- sort_data(
      group_means_melted,
      input$gene_name,
      input$show_samples,
      input$log_scale
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
