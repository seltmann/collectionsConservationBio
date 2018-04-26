################################################################################
##Estimating the number of declining species using natural history collections##
##############################Katja Seltmann, 2018##############################
################################################################################

rm(list=ls())

#include libraries
library(ggplot2)

#set working directory
setwd("~/Documents/collectionsConservationBio/collectionsConservationBio-git")

#read in output from database
data <- read.delim("hostNetwork.tsv",header = TRUE)

#append two new columns
data$host <- paste(data$h_genus,data$h_species)
data$insect <- paste(data$i_genus,data$i_species)

#write new table
write.table(data, "data.txt", , na = "NA", row.names = FALSE,col = TRUE, append = FALSE, sep="\t", quote=FALSE)

##########simple description of data###################

#total number of collecting events in entire dataset
sumAllCollectingEvents <- sum(data$coll_number_same_h)

#write a unique list of insect names in entire dataset
uniqueInsectNameList <- unique(data$insect)
write.table(uniqueInsectNameList, "uniqueInsectNameList.txt", , na = "NA", row.names = FALSE,col = FALSE, append = FALSE, sep="\t", quote=FALSE)

#write a unique list of host names in entire dataset
uniqueHostNameList <- unique(data$host)
write.table(uniqueHostNameList, "uniqueHostNameList.txt", , na = "NA", row.names = FALSE,col = FALSE, append = FALSE, sep="\t", quote=FALSE)

#subset data for only redlisted host plants and insects
subdata <- subset(data,redList == TRUE)

#write a unique list of insects on red listed plants
uniqueInsectNameRedList <- unique(subdata$insect)
write.table(uniqueInsectNameRedList, "uniqueInsectNameRedList.txt", , na = "NA", row.names = FALSE,col = FALSE, append = FALSE, sep="\t", quote=FALSE)

#write a unique list of red listed plants
uniqueHostNameRedList <- unique(subdata$host)
write.table(uniqueHostNameRedList, "uniqueHostNameRedList.txt", , na = "NA", row.names = FALSE,col = FALSE, append = FALSE, sep="\t", quote=FALSE)

################additional data about number of collecting events were on redlisted###################



##########plots###################


