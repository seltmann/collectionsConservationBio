#######----------------------------------------#####
library(sm)
library(ggplot2)
attach(data)
detach(data)

#p(plant_redlisted|specific_wasp_species) = sum_redlistplants p(plant|wasp)
#if 10 records of an insect and 5 on redlisted, probabiliy insect found on redlisted is 50% or .5
#if 30% are redlist true, than probabllity on redlisted plant is 30%

#Check to see how many removed (>3 collecting events?), describe
#list number of singletons

#redlisted probability is incorrect. 
#Number record involving redlisted/total number for that insect = probability score

#calculate P(rl) for all records
#6.6% is this greater or less than all

#clears r brain
rm(list=ls())
require(sm)
require(RMySQL)
library(devtools)
setwd("~/Documents/collectionsConservationBio/collectionsConservationBio-git")

#create a connection to the db:
connection <- dbConnect(MySQL(), user="", password="", dbname="pbi_locality", host="localhost")
dbListTables(connection)
dbListFields(connection, "host_network")
data.events <- dbGetQuery(connection, "select * from host_network")
head(data.events)
nrow(data.events)

data <- read.delim("hostNetwork.tsv",header = TRUE)
data$host <- paste(data$h_genus,data$h_species)
data$insect <- paste(data$i_genus,data$i_species)

head(data)
par(mar = c(11, 5, 2, 2))


#total number of collecting events in entire dataset
sumAllCollectingEvents <- sum(data$coll_number_same_h)

#unique list of insect names in entire dataset
uniqueInsectNameList <- unique(paste(data$i_genus,data$i_species))

#unique list of host names in entire dataset
uniqueHostNameList <- unique(paste(data$h_genus,data$h_species))

subdata <- subset(data,redList == TRUE)

#plot showing insects/hosts by number collecting events for that combo
p <-ggplot(subdata, aes(insect, host))
p +geom_bar(stat = "identity")

p

#plot showing insects and hosts clustered by host family or insect family

help("plot")
dev.off()
