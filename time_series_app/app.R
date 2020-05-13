library(shiny)
#library(magick)
library(kableExtra)
library(rmarkdown)
options(shiny.maxRequestSize=30*1024^2)
source('model.R')
shinyApp(
  ui = fluidPage(
      #Download Data########################################################
      
      #title = 'Download reports',
      sidebarLayout(
        sidebarPanel(
          # Input: Select a file ----
          fileInput("file1", "Upload sales info",
                    multiple = FALSE,
                    accept = c("text/csv",
                               "text/comma-separated-values,text/plain",
                               ".csv")),
          
          # Horizontal line ----
          tags$hr(),
          
          # Input: Checkbox if file has header ----
          checkboxInput("header", "Header", TRUE),
          
          # Input: Select separator ----
          radioButtons("sep", "Separator",
                       choices = c(Comma = ",",
                                   Semicolon = ";",
                                   Tab = "\t"),
                       selected = ","),
          
          # Input: Select quotes ----
          radioButtons("quote", "Quote",
                       choices = c(None = "",
                                   "Double Quote" = '"',
                                   "Single Quote" = "'"),
                       selected = '"'),
          
          # Horizontal line ----
          tags$hr(),
          
          #Input: Select number of rows to display ----
          # radioButtons("disp", "Display",
          #              choices = c(Head = "head",
          #                          All = "all"),
          #              selected = "head"),
          helpText(),
          # actionButton("done",label = HTML("<span class='small'>Run sales forcast<i class='glyphicon glyphicon-arrow-right'></i></span>"))
          # sliderInput("slider", "Slider", 1, 100, 50),
          radioButtons('format', 'Document format', c('PDF', 'HTML', 'Word'),
                       inline = TRUE),
          downloadButton("downloadreport", "Generate report")
        ),
        mainPanel(
          plotOutput("plot1"),
          DT::dataTableOutput("contents", width = "auto") ,
        )
      )
  ),
  server = function(input, output) {
    filedata <- reactive({
      req(input$file1)
      # when reading semicolon separated files,
      # having a comma separator causes `read.csv` to error
      tryCatch(
        {
          df <- read.csv(input$file1$datapath,
                         header = input$header,
                         sep = input$sep,
                         quote = input$quote)
        },
        error = function(e) {
          # return a safeError if a parsing error occurs
          stop(safeError(e))
        }
      )
      
      return(df)
    })
    
    output$contents <- DT::renderDataTable(
      head(filedata()),
      options = list(scrollX = TRUE))
    
    output$plot1 <-  renderPlot({
    model_function(filedata())
    })
    
    output$downloadreport <- downloadHandler(
      # For PDF output, change this to "report.pdf"
      filename = function() {
        paste('time_series_report', sep = '.', switch(
          input$format, PDF = 'pdf', HTML = 'html', Word = 'docx'
        ))
      },
      content = function(file) {
        # Copy the report file to a temporary directory before processing it, in
        # case we don't have write permissions to the current working dir (which
        # can happen when deployed).
        tempfolder <- file.path(tempdir())
        file.copy("report.Rmd", tempfolder, overwrite = TRUE)
        file.copy("report_info.RData", tempfolder, overwrite = TRUE)
        file.copy("forcast.pdf", tempfolder, overwrite = TRUE)
        file.copy("plot.pdf", tempfolder, overwrite = TRUE)
        # Set up parameters to pass to Rmd document
        # src <- normalizePath('report.Rmd')
        # temporarily switch to the temp dir, in case you do not have write
        # permission to the current working directory
        # owd <- setwd(tempdir())
        # on.exit(setwd(owd))
        #on.exit(unlink(paste0(normalizePath(tempdir()), "/", dir(tempdir())), recursive = TRUE))
        
        library(rmarkdown)
        out <- rmarkdown::render(paste(tempfolder,"/report.Rmd",sep=""), switch(
          input$format,
          PDF = pdf_document(), HTML = html_document(), Word = word_document()
        ) )
        #params = params,
        file.rename(out, file)
      }
    )
  }
)
