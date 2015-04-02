library(shiny)
library(ggplot2)
library(shinydashboard)
library(BH)

# Define UI for Top Paying jobs application
shinyUI(
  
  dashboardPage(
    dashboardHeader(title = "Chegg Data"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("", tabName = ""),
        menuItem("", tabName = ""),
        menuItem("Finance Metrics Comparison", tabName = "metricstab"),
        menuItem("2014 Salary Comparison", tabName = "jobstab")
      )
    ),
    dashboardBody(
      tabItems(
        # First tab content
        tabItem(tabName = "metricstab",
                fluidPage(
                  fluidRow(
                    column(12,
                           fluidRow(
                             column(2,
                                    uiOutput('metrics')
                             ),
                             column(10,
                                    plotOutput("metricPlot")
                             )
                           )
                    )
                  ))),
        tabItem(tabName = "jobstab",
                fluidPage(
                  fluidRow(
                    column(12,
                           fluidRow(
                             column(12,
                                    plotOutput("salaryPlot")
                             )
                           )
                    )
                  )))
        
      ))))