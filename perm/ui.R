library(shiny)
library(ggplot2)
library(shinydashboard)

# Define UI for Top Paying jobs application
shinyUI(
  
  dashboardPage(
    dashboardHeader(title = "Perm Job Data"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("", tabName = ""),
        menuItem("", tabName = ""),
        menuItem("Salary by Title", tabName = "title"),
        menuItem("Salary by Company", tabName = "company"),
        menuItem("Top Countries getting perm", tabName = "top_country")
      )
      ),
    dashboardBody(
      tabItems(
        # First tab content
        tabItem(tabName = "title",
          fluidPage(
                fluidRow(
                    column(12,
                          fluidRow(
                              column(2,
                              h4("Select Inputs"),
                              uiOutput('sector'),
                              uiOutput('state')
                          ),
                    column(10,
                          plotOutput("salaryPlot")
                   )
                 ),
                 fluidRow(
                   column(12,
                          h4("Data Table"),
                          dataTableOutput("salaryTable")))
                 )
            ))),
        # Second tab content
        tabItem(tabName = "company",
                fluidPage(
                  fluidRow(
                    column(12,
                           fluidRow(
                             column(2,
                                    h4("Select Inputs"),
                                    uiOutput('companySector'),
                                    uiOutput('companyState')
                             ),
                             column(10,
                                    plotOutput("companySalaryPlot")
                             )
                           ),
                           fluidRow(
                             column(12,
                                    h4("Data Table"),
                                    dataTableOutput("companySalaryTable")))
                    )
                  ))),
        
        # Third tab content
        tabItem(tabName = "top_country",
                fluidPage(
                  fluidRow(
                    column(12,
                            h4("Top Countries"),
                            plotOutput("topCountryPlot")))
                    )
                  )))
))