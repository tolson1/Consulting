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
                               textInput('caseDate', "Enter Case Date:",Sys.Date()), 
                               textInput('origin', "Enter Origin:",""), 
                               textInput('caseName', "Enter Case Name:",""), 
                               textInput('type', "Enter Type:",""), 
                               textInput('appealNumber', "Enter Appeal Number:",""), 
                               textInput('docType', "Enter Document Type:",""), 
                               textInput('enBanc', "Enter EnBanc:",""), 
                               textInput('judge1', "Enter Judge 1:",""), 
                               textInput('judge2', "Enter Judge 2:",""), 
                               textInput('judge3', "Enter Judge 3:","")
                               
                               
                        ),
                        column(6,
                               textInput('opinion1', "Enter Opinion 1:",""),
                               textInput('opinion1Author', "Enter Opinion 1 Author:",""),
                               textInput('opinion2', "Enter Opinion 2:", ""),
                               textInput('opinion2Author', "Enter Opinion 2 Author:",""),
                               textInput('opinion3', "Enter Opinion 3:", ""),
                               textInput('opinion3Author', "Enter Opinion 3 Author:",""),
                               textInput('duplicate', "Duplicate?:", "No"),
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
                                 actionButton("getRecord", "Get Record"),
                                 textOutput('IDNotFound')
                          )
                        )
                      ),
                      wellPanel(
                        fluidRow(
                          column(6,
                                 uiOutput('caseDateUpdate'), 
                                 uiOutput('originUpdate'), 
                                 uiOutput('yearUpdate'),
                                 uiOutput('caseNameUpdate'), 
                                 uiOutput('typeUpdate'), 
                                 uiOutput('appealNumberUpdate'), 
                                 uiOutput('docTypeUpdate'), 
                                 uiOutput('enBancUpdate'), 
                                 uiOutput('judge1Update'), 
                                 uiOutput('judge2Update')
                          ),
                          column(6,
                                 uiOutput('judge3Update'),
                                 uiOutput('opinion1Update'),
                                 uiOutput('opinion1AuthorUpdate'),
                                 uiOutput('opinion2Update'),
                                 uiOutput('opinion2AuthorUpdate'),
                                 uiOutput('opinion3Update'),
                                 uiOutput('opinion3AuthorUpdate'),
                                 uiOutput('notesUpdate'),
                                 uiOutput('urlUpdate'),
                                 uiOutput('duplicateUpdate'),
                                 uiOutput('updateButton')
                          )
                        )
                        
                      )
                    )
                    
           )
)