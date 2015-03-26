library(plyr)

chgg_income_statement <- read.csv("./data/CHGG Income Statement.csv", header=T, stringsAsFactors=T)
abcd_income_statement <- read.csv("./data/ABCD Income Statement.csv", header=T, stringsAsFactors=T)
chgg_income_statement<-as.data.frame(append(chgg_income_statement, "CHGG", after = 1))
abcd_income_statement<-as.data.frame(append(abcd_income_statement, "ABCD", after = 1))
chgg_income_statement <- rename(chgg_income_statement, c("X.CHGG."="Company"))
abcd_income_statement <- rename(abcd_income_statement, c("X.ABCD."="Company"))

income_statement<-rbind(abcd_income_statement, chgg_income_statement)

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






