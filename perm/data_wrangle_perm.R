master_perm_data <- readRDS("./data/master_perm_data.rds")
#my_count_table<-matrix(table(master_perm_data$country_of_citizenship, 
                             #master_perm_data$year))
count_of_country<- as.matrix(table(master_perm_data$country_of_citizenship, 
                                   master_perm_data$year))
my_country_count<-as.data.frame(count_of_country)
my_country_count<- rename(my_country_count, c("Var1"="Country", "Var2"="Year", "Freq"="Count"))

country_with_rank<-transform(my_country_count, 
                             Year.rank = ave(Count, Year, 
                                             FUN = function(x) rank(-x, ties.method = "first")))

top_10<-subset(country_with_rank, Year.rank<11)
top_10<-top_10[ order(top_10[,2], -top_10[,4]), ]

cat <- sapply(top_10, is.factor) 
top_10[cat] <- lapply(top_10[cat], factor) 

orderlist <- as.vector(top_10[which(top_10$Year=="2014"),1])
missing_country_list_ind<-top_10$Country %in% orderlist
missing_country<-top_10[!missing_country_list_ind,1]
missing_country<-factor(missing_country)
orderlist<-c(levels(missing_country),orderlist)

top_10 <- transform(top_10, Country = factor(Country, levels = orderlist))

#ggplot(top_10, aes(Year, Country, group= Year.rank, colour =factor(Year.rank))) + 
  #geom_line(position="dodge",stat="identity") + theme(legend.title=element_blank())
