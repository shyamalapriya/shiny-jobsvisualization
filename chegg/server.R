library(shiny)
library(plyr)
source("./data-wrangle.R")

shinyServer(function(input,output){
  
  outVarMetrics <- reactive({
    vars <- as.list(levels(income_statement$Financial.Metrics))
    return(vars)
  })
  
  output$metrics = renderUI({
    selectInput('metrics', 'Select Metrics', outVarMetrics())
  })
  
  filteredData<-reactive({
    if(!(is.null(input$metrics) || input$metrics=="")) {
      
      data<-subset(income_statement[which(income_statement$Financial.Metrics==input$metrics),], 
                   select=-c(TTM))
      
      metric_data_long<-melt(data,
                             # ID variables - all the variables to keep but not split apart on
                             id.vars=c("Company"),
                             # The source columns
                             measure.vars=names(data)[2:length(names(data))],
                             # Name of the destination column that will identify the original
                             # column that the measurement came from
                             variable.name="Year",
                             value.name="Metric"
      )
      metric_data_long[is.na(metric_data_long)] <- 0
      metric_data_long<-subset(metric_data_long[-c(1:2),])
      metric_data_long$Metric <- as.numeric(metric_data_long$Metric)
      #metric_data_long<-format(metric_data_long, scientific=FALSE)
      return(metric_data_long)}
      #data<-income_statement[which(income_statement$Financial.Metrics==input$metrics),]
      #return(subset(data, select=-c(Financial.Metrics,Company,TTM)))}
    else {
      
      data<-subset(income_statement, select=-c(TTM))
      
      metric_data_long<-melt(data,
                             # ID variables - all the variables to keep but not split apart on
                             id.vars=c("Company","Financial.Metrics"),
                             # The source columns
                             measure.vars=names(data)[2:length(names(data))],
                             # Name of the destination column that will identify the original
                             # column that the measurement came from
                             variable.name="Year",
                             value.name="Metric"
      )
      metric_data_long[is.na(metric_data_long)] <- 0
      metric_data_long<-metric_data_long[-c(1:2),]
      metric_data_long$Metric <- as.numeric(metric_data_long$Metric)
      #metric_data_long<-format(metric_data_long, scientific=FALSE)
      return(metric_data_long)
    }
      #return(subset(income_statement, select=-c(Financial.Metrics,Company,TTM)))}
  })
  
  output$metricPlot <- renderPlot({
    
    p<- ggplot(filteredData(), aes(Year, Metric, fill=Company, width=0.5)) +
      geom_bar(position="dodge",stat="identity") 
  
    print(p)
  })
  
  
  
  #barplot(as.matrix(filteredData()),
  #names.arg=wrap.labels(sort1.aggr_dataset()[1:10,1],15),
  #xlab="Year",
  #ylab=input$metrics,
  #main=input$metrics,
  #border="black",
  #beside=T,
  #col=c("darkgreen","orange"))
  # legend("topleft",  
  #fill=c("darkgreen","orange"), 
  #legend=levels(income_statement$Company)  )
  
  # Implementation for second tab
  
  output$salaryPlot <- renderPlot({
    
    ggplot(plot_data_long, aes(Title, Salary, fill=Company, width=0.5)) + 
      geom_bar(position="dodge",stat="identity")
    
    #barplot(as.matrix(subset(plot_data_long, select=-c(Title))),
            #names.arg=list(plot_data$Title),
            #xlab="Market Vs Chegg",
            #ylab="Salary",
            #ylim=c(0,250000),
            #main="Market vs Chegg",
            #border="black",beside=T)
            #col=c("green","orange","blue","brown"))
    #legend("top", 
           #legend=levels(plot_data_long$Title),fill=c("green","orange","blue","brown"))
  })
  
  
})