library(shiny)
library(RSQLite)
library(shinythemes)

#Connecting to the database
con <- dbConnect(SQLite(), dbname = "/Users/Tyler/sqlite/appeals.sqlite")

#Creating a list of column names for the 'appeals' table
appealsFields <- as.list(dbListFields(con, "appeals"));

#Assigning custom names to the list for display purposes
names(appealsFields) = c('ID', 'Case Date', 'Origin', 'Case Name', 'Type', 'Appeal Number', 'Document Type', 'EnBanc', 'Judge 1', 'Judge 2', 'Judge 3', 'Opinion 1', 'Opinion 1 Author', 'Opinion 2', 'Opinion 2 Author', 'Opinion 3', 'Opinion 3 Author', 'Opinion 4', 'Opinion 4 Author', 'Civility Dissent 1', 'Civlity Dissent 2', 'Notes', 'URL');

#Selecting the earliest case date from the database for the dateRangeInput
minCaseDate <- dbGetQuery(con, "SELECT min(caseDate) FROM appeals")[,1];

function(input, output) {
  
  #Each 'uniqueXXXXX' reactive value is created so anytime new data is added, it will
  #update the items in a filter, adding new ones if neccessary
  uniqueOrigin <- reactive({
    input$insert
    dbGetQuery(con, "SELECT DISTINCT(origin) FROM appeals")[,1]
  })
  
  uniqueType <- reactive({
    input$insert
    dbGetQuery(con, "SELECT DISTINCT(type) FROM appeals")[,1]
  })
  
  uniqueDocType <- reactive({
    input$insert
    dbGetQuery(con, "SELECT DISTINCT(docType) FROM appeals")[,1]
  })
  
  uniqueEnBanc <- reactive({
    input$insert
    dbGetQuery(con, "SELECT DISTINCT(enBanc) FROM appeals")[,1]
  })
  
  uniqueOpinion1 <- reactive({
    input$insert
    dbGetQuery(con, "SELECT DISTINCT(opinion1) FROM appeals")[,1]
  })
  
  nextID <- reactive({ 
    input$insert
    dbGetQuery(con, "SELECT max(uniqueID) FROM appeals")[,1] + 1;
  })
  
  output$originFilter <- renderUI(selectInput('originInput', 'Origin:', choices = uniqueOrigin(), multiple = TRUE))
  
  output$typeFilter <- renderUI(selectInput("typeInput", 'Type:', choices = uniqueType(), multiple = TRUE))
  
  output$docTypeFilter <- renderUI(selectInput('docTypeInput', 'Document Type:', choices = uniqueDocType(), multiple = TRUE))
  
  output$enBancFilter <- renderUI(selectInput('enBancInput', 'enBanc:', choices = uniqueEnBanc(), multiple = TRUE))
  
  output$opinion1Filter <- renderUI(selectInput('opinion1Input', 'Opinion 1:', choices = uniqueOpinion1(), multiple = TRUE))
  
  output$ID <- renderText({paste("New Record ID:", nextID())})
  
  #Rendering checkboxGroupInput to allow user to display any columns
  output$display <- renderUI(checkboxGroupInput('show_vars', 'Display Columns:', choices = appealsFields));
  
  #Rendering dateRangeInput to allow the user to query the database for any range
  output$dateRange <- renderUI(dateRangeInput(inputId = "dateRange", label = "Select Date Range: yyyy-mm-dd", start = minCaseDate));
  
  #Reactive value holding the current date frame depending on the chosen date range
  current_frame <- reactive({
    query <- paste("SELECT * FROM appeals WHERE caseDate BETWEEN '", input$dateRange[1],"' AND '",input$dateRange[2],"'", sep = "");
    tempData <- dbGetQuery(con, query);
    if(!is.null(input$originInput)) {
      tempData <- subset(tempData, tempData$origin %in% input$originInput);
    }
    if(!is.null(input$typeInput)) {
      tempData <- subset(tempData, tempData$type %in% input$typeInput);
    }
    if(!is.null(input$docTypeInput)) {
      tempData <- subset(tempData, tempData$docType %in% input$docTypeInput);
    }
    if(!is.null(input$enBancInput)) {
      tempData <- subset(tempData, tempData$enBanc %in% input$enBancInput);
    }
    if(!is.null(input$opinion1Input)) {
      tempData <- subset(tempData, tempData$opinion1 %in% input$opinion1Input);
    }
    tempData[, input$show_vars, drop = FALSE]
  })
  
  #Reactive value holding the indices of the variables to be displayed based on the checkboxGroupInput
  current_labels <- reactive({
    which(appealsFields %in% input$show_vars); 
  })
  
  #Rendering the data table for the current data frame, and current labels
  output$mytable1 <- DT::renderDataTable({
    DT::datatable(current_frame(), colnames = names(appealsFields)[current_labels()]);
  })
  
  output$text <- renderText({
    paste("Session Insertion Count:", input$insert);
  })
  
  observeEvent(input$insert, {
    query <- paste("INSERT INTO appeals VALUES (", input$uniqueID,",'",input$caseDate,"','",input$origin,"','",input$caseName,"','",input$type,"','",input$appealNumber,"','",input$docType,"','",input$enBanc,"','",input$judge1,"','",input$judge2,"','",input$judge3,"','",input$opinion1,"','",input$opinion1Author,"')", sep="")
    cat(query)
  })
  
  output$download <- downloadHandler(
    filename = "data.csv", 
    content = function(file) {
      write.csv(current_frame(), file, row.names = FALSE)
    }, 
    contentType = "text/csv"
  )
}