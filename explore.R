library(SparkR)
library(magrittr)
library(ggplot2)
SparkR:::sparkR.session()


#system("git config --global user.email \"debajyoti.roy@databricks.com\"")
#system("git config --global user.name \"royatdb\"")

#performance
performance <- read.df("/mnt/roy/loan_performance_parquet/Performance_All", source = "parquet")
performance %>% count()



acquisition <- read.df("/mnt/roy/loan_performance_parquet/Acquisition_All", source = "parquet") %>% 
  withColumn("orig_year", substr(.$orig_dte,5,8))
acquisition$orig_year <- cast(acquisition$orig_year, "integer")
acquisition %>% count()

countsByYear <- count(groupBy(acquisition, "orig_year")) %>% 
  arrange(asc(.$orig_year)) %>%
  collect()

ggplot(data=countsByYear, aes(x=orig_year, y=count)) +
  geom_bar(stat="identity", fill="steelblue")+
  theme_minimal()