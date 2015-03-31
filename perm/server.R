library(shiny)
library(plyr)
library(stringr)

#load cleaned perm data into memory
source("./data_wrangle_perm.R")
perm_data <- master_perm_data

#Rename columns to easy names
perm_data<- rename(perm_data, c("pw_job_title_9089"="Title", "employer_name"="Company", "pw_amount_9089"="Salary"))

#Display column names
show_vars <- c("Title", "Company", "Salary", "year")

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
  
  # Implement title tab
  #Reactive block to take the user inputs
  outVarSector <- reactive({
    vars <- as.list(levels(perm_data$us_economic_sector))
    return(vars)
  })
  
  outVarState <- reactive({
    vars <- as.list(levels(perm_data$job_info_work_state))
    return(vars)
  })
  
  output$sector = renderUI({
    selectInput('sector', 'Sector', outVarSector())
  })
  
  output$state = renderUI({
    selectInput('state', 'State', outVarState())
  })
    
  #Filter sector and then state data based on user input
  filteredData<-reactive({
    if(!(is.null(input$sector) || input$sector=="")) 
        return(perm_data[which(perm_data$us_economic_sector==input$sector),])
     else 
       return(perm_data)
    })
  
  filteredStateData<-reactive({
    if(!(is.null(input$state) || input$state=="")) 
      return(filteredData()[which(filteredData()$job_info_work_state==input$state),])
    else
      return(filteredData())
  })
  
  #Aggregate data to Mean Salary based on Title and rename, sort, transform aggregated data frame
  aggr_dataset <- reactive({aggregate(filteredStateData()[["Salary"]],
                                      by=list(filteredStateData()[["Title"]]), 
                                     FUN=mean,
                                     na.rm=T)})
  
  aggr_dataset1<-reactive({rename(aggr_dataset(), c("Group.1"="Title","x"="Mean_Salary"))})
  
  sort1.aggr_dataset<-reactive({aggr_dataset1()[with(aggr_dataset1(),
                                                   order(Mean_Salary, decreasing = T, na.last=T)),]})
  
  sort1.aggr_dataset_ord<-reactive({
   transform(sort1.aggr_dataset(), Title = factor(Title, levels = sort1.aggr_dataset()$Title))
  })
  
  #Display plot
  output$salaryPlot <- renderPlot({
    
    p<- ggplot(sort1.aggr_dataset_ord()[1:10,], aes(Title, Mean_Salary, fill=Title)) + 
      geom_bar(position="dodge",stat="identity", width=0.75) + 
      scale_x_discrete(labels = function(x) str_wrap(x, width = 10))+
      theme(legend.position="none")
    print(p)
         # barplot(sort1.aggr_dataset()[1:10,2],
          #  names.arg=wrap.labels(sort1.aggr_dataset()[1:10,1],15),
           # xlab="Job Title",
            #ylab="Median Salary",
            #ylim=c(0,250000),
            #main="Top Salary by Title",
            #border="black")
  })
    
  output$salaryTable<-renderDataTable({
    library(ggplot2)
    #diamonds[, input$show_vars, drop = FALSE]
    filteredStateData()[,show_vars, drop=FALSE]
    })
  
  # Implement company tab
  # Reactive block to take the user inputs
  outVarcompanySector <- reactive({
    vars <- as.list(levels(perm_data$us_economic_sector))
    return(vars)
  })
  
  outVarcompanyState <- reactive({
    vars <- as.list(levels(perm_data$job_info_work_state))
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
      return(perm_data[which(perm_data$us_economic_sector==input$companySector),])
    else 
      return(perm_data)
  })
  
  filteredCompanyStateData<-reactive({
    if(!(is.null(input$companyState) || input$companyState=="")) 
      return(filteredCompanyData()[which(filteredCompanyData()$job_info_work_state==input$companyState),])
    else
      return(filteredCompanyData())
  })
  
  aggr_companyDataset <- reactive({aggregate(filteredCompanyStateData()[["Salary"]],
                                      by=list(filteredCompanyStateData()[["Company"]]), 
                                      FUN=mean,
                                      na.rm=T)})
  
  aggr_companyDataset1<-reactive({rename(aggr_companyDataset(), c("Group.1"="Company","x"="Mean_Salary"))})
  
  sort1.aggr_companyDataset1<-reactive({aggr_companyDataset1()[with(aggr_companyDataset1(),
                                                     order(Mean_Salary, decreasing = T, na.last=T)),]})
  
  sort1.aggr_companyData_ord<-reactive({
    transform(sort1.aggr_companyDataset1(), Company = factor(Company, levels = sort1.aggr_companyDataset1()$Company))
  })
  
  #sort1.aggr_companyDataset<-reactive({aggr_companyDataset()[with(aggr_companyDataset(),
                                                    #order(x, decreasing = T, na.last=T)),]})
  
  output$companySalaryPlot <- renderPlot({
    
    p<- ggplot(sort1.aggr_companyData_ord()[1:10,], aes(Company, Mean_Salary, fill=Company)) + 
      geom_bar(position="dodge",stat="identity", width=0.75) + 
      scale_x_discrete(labels = function(x) str_wrap(x, width = 10))+
      theme(legend.position="none")
    print(p)
    
    #barplot(sort1.aggr_companyDataset()[1:10,2],
            #names.arg=wrap.labels(sort1.aggr_companyDataset()[1:10,1],15),
            #xlab="Company",
            #ylab="Median Salary",
            #ylim=c(0,400000),
            #main="Top Salary by Company",
            #border="black")
  })
  
  
  output$companySalaryTable<-renderDataTable({
    library(ggplot2)
    #diamonds[, input$show_vars, drop = FALSE]
    filteredCompanyStateData()[,show_vars, drop=FALSE]
  })
  
  output$topCountryPlot <- renderPlot({
    ggplot(top_10, aes(Year, Country, group= Year.rank, colour =factor(Year.rank))) + 
      geom_line(position="dodge",stat="identity") + theme(legend.title = element_text(colour="chocolate", size=16, face="bold"))+
      scale_color_discrete(name="Rank")
  })
})