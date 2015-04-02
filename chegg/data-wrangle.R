library(plyr)
library(reshape2)
chgg_income_statement <- read.csv("./data/CHGG Income Statement.csv", header=T, stringsAsFactors=T)
abcd_income_statement <- read.csv("./data/ABCD Income Statement.csv", header=T, stringsAsFactors=T)
chgg_income_statement<-as.data.frame(append(chgg_income_statement, "CHGG", after = 1))
abcd_income_statement<-as.data.frame(append(abcd_income_statement, "ABCD", after = 1))
chgg_income_statement <- rename(chgg_income_statement, c("X.CHGG."="Company"))
abcd_income_statement <- rename(abcd_income_statement, c("X.ABCD."="Company"))

income_statement<-rbind(abcd_income_statement, chgg_income_statement)

income_statement<-rename(income_statement, c("X2005.12"="2005", 
                    "X2006.12"="2006", 
                    "X2007.12"="2007",
                    "X2008.12"="2008", 
                    "X2009.12"="2009", 
                    "X2010.12"="2010",
                    "X2011.12"="2011", 
                    "X2012.12"="2012", 
                    "X2013.12"="2013",
                    "X2014.12"="2014"))

perm_data <- read.csv("./data/PERM_FY14_Q4.csv", header=T, stringsAsFactors=T)
perm_data<- rename(perm_data, c("PW_Job_Title_9089"="Title", "Employer_Name"="Company", "PW_AMOUNT_9089"="Salary"))
show_vars <- c("Title", "Company", "Salary")
perm_data_chgg_title <- data.frame(perm_data[which(perm_data$Company=="CHEGG, INC."),])

perm_data_chgg_title <- as.data.frame(
  lapply(perm_data_chgg_title, 
         function(x) if(is.factor(x)) factor(x) else x
  )
)

aggr_dataset_chgg <- aggregate(perm_data_chgg_title[["Salary"]],
                                    by=list(perm_data_chgg_title[["Title"]]), 
                                    FUN=mean,
                                    na.rm=T)

aggr_dataset_perm <- aggregate(perm_data[["Salary"]],
                               by=list(perm_data[["Title"]]), 
                               FUN=mean,
                               na.rm=T)

plot_data<-merge(x=aggr_dataset_chgg,y=aggr_dataset_perm, by="Group.1")
plot_data<- rename(plot_data, c("Group.1"="Title", "x.x"="Chegg", "x.y"="Market"))

plot_data_long<-melt(plot_data,
                     # ID variables - all the variables to keep but not split apart on
                     id.vars=c("Title"),
                     # The source columns
                     measure.vars=c("Chegg", "Market"),
                     # Name of the destination column that will identify the original
                     # column that the measurement came from
                     variable.name="Company",
                     value.name="Salary"
)

# Generate data
#ggplot(plot_data_long, aes(Title, Salary, fill=Company)) + 
  #geom_bar(position="dodge",stat="identity")

