library(shiny)
library(ggplot2)
library(shinydashboard)

# Define UI for Top Paying jobs application
shinyUI(
  
  dashboardPage(
    dashboardHeader(title = "Perm Job Data"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Salary by Title", tabName = "title"),
        menuItem("Salary by Company", tabName = "company")
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
                h2("Company tab content")
        )
))))