library(shiny)
library(RSQLite)
library(shinythemes)

#Connecting to the database
con <- dbConnect(SQLite(), dbname = "appeals.sqlite")

#Creating a list of column names for the 'appeals' table
appealsFields <- as.list(dbListFields(con, "appeals"));

#Assigning custom names to the list for display purposes
names(appealsFields) = c('ID', 'Case Date', 'Origin', 'Case Name', 'Type', 'Appeal Number', 'Document Type', 'EnBanc', 'Judge 1', 'Judge 2', 'Judge 3', 'Opinion 1', 'Opinion 1 Author', 'Opinion 2', 'Opinion 2 Author', 'Opinion 3', 'Opinion 3 Author', 'Opinion 4', 'Opinion 4 Author', 'Civility Dissent 1', 'Civlity Dissent 2', 'Notes', 'URL');

#Selecting the earliest case date from the database for the dateRangeInput
minCaseDate <- dbGetQuery(con, "SELECT min(caseDate) FROM appeals")[,1];

function(input, output) {
    
    nextID <- reactive({ 
        input$insert
        dbGetQuery(con, "SELECT max(uniqueID) FROM appeals")[,1] + 1;
    })
    
    output$ID <- renderUI(numericInput('uniqueID', "Enter ID:", nextID()))
    
    #Rendering checkboxGroupInput to allow user to display any columns
    output$display <- renderUI(checkboxGroupInput('show_vars', 'Display Columns:', choices = appealsFields));
    
    #Rendering dateRangeInput to allow the user to query the database for any range
    output$dateRange <- renderUI(dateRangeInput(inputId = "dateRange", label = "Select Date Range: yyyy-mm-dd", start = minCaseDate));
    
    #Reactive value holding the current date frame depending on the chosen date range
    current_frame <- reactive({
        query <- paste("SELECT * FROM appeals WHERE caseDate BETWEEN '", input$dateRange[1],"' AND '",input$dateRange[2],"'", sep = "");
        dbGetQuery(con, query);
    })
    
    #Reactive value holding the indices of the variables to be displayed based on the checkboxGroupInput
    current_labels <- reactive({
        which(appealsFields %in% input$show_vars); 
    })
    
    #Rendering the data table for the current data frame, and current labels
    output$mytable1 <- DT::renderDataTable({
        DT::datatable(current_frame()[, input$show_vars, drop = FALSE], colnames = names(appealsFields)[current_labels()]);
    })
    
    output$text <- renderText({
        paste("Inserts this session:", input$insert);
    })
    
    observeEvent(input$insert, {
        query <- paste("INSERT INTO appeals VALUES (", input$uniqueID,",'",input$caseDate,"','",input$origin,"','",input$caseName,"','",input$type,"','",input$appealNumber,"','",input$docType,"','",input$enBanc,"','",input$judge1,"','",input$judge2,"','",input$judge3,"','",input$opinion1,"','",input$opinion1Author,"')", sep="")
        cat(query)
    })
}