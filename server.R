library(shiny)
library(RSQLite)
library(shinythemes)

#Connecting to the database
con <- dbConnect(SQLite(), dbname = "appealsNEW.sqlite")

#Creating a list of column names for the 'appeals' table
appealsFields <- as.list(dbListFields(con, "appeals"));

#Assigning custom names to the list for display purposes
names(appealsFields) = c('ID', 'Case Date', 'Year', 'Origin', 'Case Name', 'Type', 'Duplicate', 'Appeal Number', 'Document Type', 'EnBanc', 'Judge 1', 'Judge 2', 'Judge 3', 'Opinion 1', 'Opinion 1 Author', 'Opinion 2', 'Opinion 2 Author', 'Opinion 3', 'Opinion 3 Author', 'Notes', 'URL');

#Selecting the earliest case date from the database for the dateRangeInput
minCaseDate <- dbGetQuery(con, "SELECT min(caseDate) FROM appeals")[,1]



function(input, output, session) {
    
    #Each 'uniqueXXXXX' reactive value is created so anytime new data is added, it will
    #update the items in a filter, adding new ones if neccessary
    
    uniqueYear <- reactive({
        input$insert
        dbGetQuery(con, "SELECT DISTINCT(year) FROM appeals")[,1]
    })
    
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
    
    output$yearFilter <- renderUI(selectInput('yearInput', 'Year:', choices = uniqueYear(), multiple = TRUE))
    
    output$ID <- renderText({paste("New Record ID:", nextID())})
    
    #Rendering checkboxGroupInput to allow user to display any columns
    output$display <- renderUI(checkboxGroupInput('show_vars', 'Display Columns:', choices = appealsFields,
                                                  selected = appealsFields[c(1,2,4,5)]));
    
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
        if(!is.null(input$yearInput)) {
            tempData <- subset(tempData, tempData$year %in% input$yearInput);
        }
        tempData[, input$show_vars, drop = FALSE]
    })
    
    #Reactive value holding the indices of the variables to be displayed based on the checkboxGroupInput
    current_labels <- reactive({
        which(appealsFields %in% input$show_vars); 
    })
    
    #Rendering the data table for the current data frame, and current labels
    output$mytable1 <- DT::renderDataTable({
        DT::datatable(current_frame(), colnames = names(appealsFields)[current_labels()], rownames = FALSE);
    })
    
    output$text <- renderText({
        paste("Session Insertion Count:", input$insert);
    })
    
    observeEvent(input$insert, {
        query <- paste("INSERT INTO appeals VALUES (", nextID(),",'",input$caseDate,"','",format(as.Date(input$caseDate), "%Y"),"','",input$origin,"','",input$caseName,"','",input$type,"','",input$duplicate,"','",input$appealNumber,"','",input$docType,"','",input$enBanc,"','",input$judge1,"','",input$judge2,"','",input$judge3,"','",input$opinion1,"','",input$opinion1Author,"','",input$opinion2,"','",input$opinion2Author,"','",input$opinion3,"','",input$opinion3Author,"','",input$notes,"','",input$url,"')", sep="")
        cat(query)
        #The line below sends insert statement to database to insert the record
        #dbGetQuery(con, query) <--commented out for now
        
        #After the insert, the text fields are cleared
        updateTextInput(session, inputId = "caseDate", value = "")
        updateTextInput(session, inputId = "origin", value = "")
        updateTextInput(session, inputId = "caseName", value = "")
        updateTextInput(session, inputId = "type", value = "")
        updateTextInput(session, inputId = "appealNumber", value = "")
        updateTextInput(session, inputId = "docType", value = "")
        updateTextInput(session, inputId = "enBanc", value = "")
        updateTextInput(session, inputId = "judge1", value = "")
        updateTextInput(session, inputId = "judge2", value = "")
        updateTextInput(session, inputId = "judge3", value = "")
        updateTextInput(session, inputId = "opinion1", value = "")
        updateTextInput(session, inputId = "opinion1Author", value = "")
        updateTextInput(session, inputId = "opinion2", value = "")
        updateTextInput(session, inputId = "opinion2Author", value = "")
        updateTextInput(session, inputId = "opinion3", value = "")
        updateTextInput(session, inputId = "opinion3Author", value = "")
        updateTextInput(session, inputId = "duplicate", value = "No")
        updateTextInput(session, inputId = "notes", value = "")
        updateTextInput(session, inputId = "url", value = "")
    })
    
    output$download <- downloadHandler(
        filename = "data.csv", 
        content = function(file) {
            write.csv(current_frame(), file, row.names = FALSE)
        }, 
        contentType = "text/csv"
    )
}