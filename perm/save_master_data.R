data_2014<-read.csv("./data/PERM_FY2014.csv", header=T, stringsAsFactors=T)
data_2013<-read.csv("./data/PERM_FY2013.csv", header=T, stringsAsFactors=T)
data_2012<-read.csv("./data/PERM_FY2012.csv", header=T, stringsAsFactors=T)
data_2011<-read.csv("./data/PERM_FY2011.csv", header=T, stringsAsFactors=T)
data_2010<-read.csv("./data/PERM_FY2010.csv", header=T, stringsAsFactors=T)

data_2014$Year<-factor("2014")
data_2013$Year<-factor("2013")
data_2012$Year<-factor("2012")
data_2011$Year<-factor("2011")
data_2010$Year<-factor("2010")

names(data_2014)<-tolower(names(data_2014))
names(data_2013)<-tolower(names(data_2013))
names(data_2012)<-tolower(names(data_2012))
names(data_2011)<-tolower(names(data_2011))
names(data_2010)<-tolower(names(data_2010))

data_2013<- rename(data_2013, c("us.economic.sector"="us_economic_sector",
                                "pw.soc.title"="pw_soc_title", 
                                "x2007.naics.us.title"="x2007_naics_us_title"))
data_2012<- rename(data_2012, c("country_of_citzenship"="country_of_citizenship"))
data_2011<- rename(data_2011, c("country_of_citzenship"="country_of_citizenship"))
data_2010<- rename(data_2010, c("country_of_citzenship"="country_of_citizenship"))

data_columns <- c("case_no", "employer_name", "employer_state", 
                  "employer_postal_code", "us_economic_sector", 
                  "pw_job_title_9089", "pw_amount_9089", "pw_unit_of_pay_9089", 
                  "job_info_work_city", "job_info_work_state", 
                  "country_of_citizenship", "year")

clean_data_2013<-data_2013[data_columns]
clean_data_2014<-data_2014[data_columns]
clean_data_2012<-data_2012[data_columns]
clean_data_2011<-data_2011[data_columns]
clean_data_2010<-data_2010[data_columns]

master_perm_data<-rbind(clean_data_2014, clean_data_2013,
                        clean_data_2012,clean_data_2011,
                        clean_data_2010)


#saveRDS(master_perm_data, "./data/master_perm_data.rds")