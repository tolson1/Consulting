library(shiny)
library(RSQLite)
library(shinythemes)

navbarPage(theme = shinytheme("yeti"),
           "Federal Circuit Decisions Database ",
           tabPanel("Query Data",
                    sidebarLayout(
                        sidebarPanel(
                            tabsetPanel(
                                tabPanel("Filter", 
                                         br(),
                                         uiOutput(outputId = 'dateRange'),
                                         uiOutput(outputId = 'originFilter'),
                                         uiOutput(outputId = 'typeFilter'),
                                         uiOutput(outputId = 'docTypeFilter'),
                                         uiOutput(outputId = 'enBancFilter'),
                                         uiOutput(outputId = 'opinion1Filter'),
                                         uiOutput(outputId = 'yearFilter')
                                ),
                                tabPanel("Display",
                                         br(),
                                         uiOutput(outputId = 'display'))
                            )
                        ),
                        mainPanel(
                            DT::dataTableOutput('mytable1'), 
                            downloadButton('download', 'Download')
                        )
                    )
           ), 
           tabPanel("Insert Data", 
                    mainPanel(wellPanel(
                        fluidRow(
                            column(6,
                                   textInput('caseDate', "Enter Case Date:",""), 
                                   textInput('origin', "Enter Origin:",""), 
                                   textInput('caseName', "Enter Case Name:",""), 
                                   textInput('type', "Enter Type:",""), 
                                   textInput('appealNumber', "Enter Appeal Number:",""), 
                                   textInput('docType', "Enter Document Type:",""), 
                                   textInput('enBanc', "Enter EnBanc:",""), 
                                   textInput('judge1', "Enter Judge 1:",""), 
                                   textInput('judge2', "Enter Judge 2:",""), 
                                   textInput('judge3', "Enter Judge 3:",""), 
                                   textInput('opinion1', "Enter Opinion 1:","")
                                   
                            ),
                            column(6,
                                   textInput('opinion1Author', "Enter Opinion 1 Author:",""),
                                   textInput('opinion2', "Enter Opinion 2:", ""),
                                   textInput('opinion2Author', "Enter Opinion 2 Author:",""),
                                   textInput('opinion3', "Enter Opinion 3:", ""),
                                   textInput('opinion3Author', "Enter Opinion 3 Author:",""),
                                   textInput('opinion4', "Enter Opinion 4:", ""),
                                   textInput('opinion4Author', "Enter Opinion 4 Author:",""),
                                   textInput('civilDis1', "Enter Civility Dissent 1:", ""),
                                   textInput('civDis2', "Enter Civility Dissent 2:", ""),
                                   textInput('notes', "Enter Notes:", ""),
                                   textInput('url', "Enter URL:","")
                                   
                            )
                        )
                    )
                    
                    ),
                    textOutput('ID'),
                    br(),
                    textOutput("text"),
                    br(),
                    actionButton("insert","Insert")
           ),
           tabPanel("Update Record",
                    mainPanel(
                    wellPanel(
                        fluidRow(
                            column(6,
                                textInput('updateID', "Enter ID:", "")
                            ),
                            column(6,
                                 br(),
                                 actionButton("getRecord", "Get Record")
                            )
                        )
                    ),
                    wellPanel(
                        fluidRow(
                            column(6,
                                   textInput('caseDateUpdate', "Case Date:",""), 
                                   textInput('originUpdate', "Origin:",""), 
                                   textInput('caseNameUpdate', "Case Name:",""), 
                                   textInput('typeUpdate', "Type:",""), 
                                   textInput('appealNumberUpdate', "Appeal Number:",""), 
                                   textInput('docTypeUpdate', "Document Type:",""), 
                                   textInput('enBancUpdate', "EnBanc:",""), 
                                   textInput('judge1Update', "Judge 1:",""), 
                                   textInput('judge2Update', "Judge 2:",""), 
                                   textInput('judge3Update', "Judge 3:",""), 
                                   textInput('opinion1Update', "Opinion 1:","")
                                   
                            ),
                            column(6,
                                   textInput('opinion1AuthorUpdate', "Opinion 1 Author:",""),
                                   textInput('opinion2Update', "Opinion 2:", ""),
                                   textInput('opinion2AuthorUpdate', "Opinion 2 Author:",""),
                                   textInput('opinion3Update', "Opinion 3:", ""),
                                   textInput('opinion3AuthorUpdate', "Opinion 3 Author:",""),
                                   textInput('opinion4Update', "Opinion 4:", ""),
                                   textInput('opinion4AuthorUpdate', "Opinion 4 Author:",""),
                                   textInput('civilDis1Update', "Civility Dissent 1:", ""),
                                   textInput('civDis2Update', "Civility Dissent 2:", ""),
                                   textInput('notesUpdate', "Notes:", ""),
                                   textInput('urlUpdate', "URL:","")
                                   
                            )
                        )
                    
                )
           )
           
    )
)