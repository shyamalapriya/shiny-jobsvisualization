library(shiny)
library(plyr)

perm_data <- read.csv("./data/PERM_FY14_Q4.csv", header=T, stringsAsFactors=T)
perm_data<- rename(perm_data, c("PW_Job_Title_9089"="Title", "Employer_Name"="Company", "PW_AMOUNT_9089"="Salary"))

show_vars <- c("Title", "Company", "Salary")

# Core wrapping function
wrap.it <- function(x, len)
{ 
  sapply(x, function(y) paste(strwrap(y, len), 
                              collapse = "\n"), 
         USE.NAMES = FALSE)
}


# Call this function with a list or vector
wrap.labels <- function(x, len)
{
  if (is.list(x))
  {
    lapply(x, wrap.it, len)
  } else {
    wrap.it(x, len)
  }
}

shinyServer(function(input,output){
  
  outVarSector <- reactive({
    vars <- as.list(levels(perm_data$US_ECONOMIC_SECTOR))
    return(vars)
  })
  
  outVarState <- reactive({
    vars <- as.list(levels(perm_data$Job_Info_Work_State))
    return(vars)
  })
  
  output$sector = renderUI({
    selectInput('sector', 'Sector', outVarSector())
  })
  
  output$state = renderUI({
    selectInput('state', 'State', outVarState())
  })
    
  filteredData<-reactive({
    if(!(is.null(input$sector) || input$sector=="")) 
        return(perm_data[which(perm_data$US_ECONOMIC_SECTOR==input$sector),])
     else 
       return(perm_data)
    })
  
  filteredStateData<-reactive({
    if(!(is.null(input$state) || input$state=="")) 
      return(filteredData()[which(filteredData()$Job_Info_Work_State==input$state),])
    else
      return(filteredData())
  })
  
  aggr_dataset <- reactive({aggregate(filteredStateData()[["Salary"]],
                                      by=list(filteredStateData()[["Title"]]), 
                                     FUN=mean,
                                     na.rm=T)})
  
  sort1.aggr_dataset<-reactive({aggr_dataset()[with(aggr_dataset(),
                                                   order(x, decreasing = T, na.last=T)),]})
  
  output$salaryPlot <- renderPlot({
          barplot(sort1.aggr_dataset()[1:10,2],
            names.arg=wrap.labels(sort1.aggr_dataset()[1:10,1],15),
            xlab="Job Title",
            ylab="Median Salary",
            ylim=c(0,250000),
            main="Top Salary by Title",
            border="black")
  })
    
  output$salaryTable<-renderDataTable({
    library(ggplot2)
    #diamonds[, input$show_vars, drop = FALSE]
    filteredStateData()[,show_vars, drop=FALSE]
    })
  
  # Implement company tab
  
  outVarcompanySector <- reactive({
    vars <- as.list(levels(perm_data$US_ECONOMIC_SECTOR))
    return(vars)
  })
  
  outVarcompanyState <- reactive({
    vars <- as.list(levels(perm_data$Job_Info_Work_State))
    return(vars)
  })
  
  output$companySector = renderUI({
    selectInput('companySector', 'Sector', outVarcompanySector())
  })
  
  output$companyState = renderUI({
    selectInput('companyState', 'State', outVarcompanyState())
  })
  
  
  filteredCompanyData<-reactive({
    if(!(is.null(input$companySector) || input$companySector=="")) 
      return(perm_data[which(perm_data$US_ECONOMIC_SECTOR==input$companySector),])
    else 
      return(perm_data)
  })
  
  filteredCompanyStateData<-reactive({
    if(!(is.null(input$companyState) || input$companyState=="")) 
      return(filteredCompanyData()[which(filteredCompanyData()$Job_Info_Work_State==input$companyState),])
    else
      return(filteredCompanyData())
  })
  
  aggr_companyDataset <- reactive({aggregate(filteredCompanyStateData()[["Salary"]],
                                      by=list(filteredCompanyStateData()[["Company"]]), 
                                      FUN=mean,
                                      na.rm=T)})
  
  sort1.aggr_companyDataset<-reactive({aggr_companyDataset()[with(aggr_companyDataset(),
                                                    order(x, decreasing = T, na.last=T)),]})
  
  output$companySalaryPlot <- renderPlot({
    barplot(sort1.aggr_companyDataset()[1:10,2],
            names.arg=wrap.labels(sort1.aggr_companyDataset()[1:10,1],15),
            xlab="Company",
            ylab="Median Salary",
            #ylim=c(0,400000),
            main="Top Salary by Company",
            border="black")
  })
  
  
  output$companySalaryTable<-renderDataTable({
    library(ggplot2)
    #diamonds[, input$show_vars, drop = FALSE]
    filteredCompanyStateData()[,show_vars, drop=FALSE]
  })
})