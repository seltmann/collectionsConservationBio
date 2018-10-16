################################################################################
##Estimating the number of declining species using natural history collections##
##############################Katja Seltmann, 2018##############################
################################################################################

rm(list=ls())

#include libraries
library(ggplot2)
library(RColorBrewer)
library(ggthemes)

#set working directory
setwd("~/Documents/collectionsConservationBio/collectionsConservationBio-git")

##########simple description of database data###################

#read in output from database which is in the hostNetwork.tsv file
data <- read.delim("temp-data/hostNetwork.tsv",header = TRUE)

#append two new columns that includes the host plant name and insect species
data$host <- paste(data$h_genus,data$h_species)
data$insect <- paste(data$i_genus,data$i_species)

#write new table that includes new columns
write.table(data, "temp-data/data.txt", , na = "NA", row.names = FALSE,col = TRUE, append = FALSE, sep="\t", quote=FALSE)

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
write.table(uniqueHostNameRedList, "temp-data/uniqueHostNameRedList.txt", , na = "NA", row.names = FALSE,col = FALSE, append = FALSE, sep="\t", quote=FALSE)

################redlist frequencies###################
#read in output from database
data <- read.delim("temp-data/redListdata.txt",header = TRUE)

#append two new columns
data$scientificName <- paste(data$Genus,data$Species)
write.table(data, "temp-data/redListdata.txt", , na = "NA", row.names = FALSE,col = TRUE, append = FALSE, sep="\t", quote=FALSE)

head(data)
##########plots###################
#####group by scientific name#######
data$scientificName <- factor(data$scientificName, levels = data$scientificName[order(data$Family)])
cbPalette <- c("#999999", "#000000", "#D19392","#AA4643","#89A54E","#89A54E", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

  p <- ggplot(data, aes(scientificName, Proportion)) + geom_point(aes(colour = Family), size = 3) + 
    scale_colour_manual(values = cbPalette) +
    xlab("Dose (mg)") + ylab("")
  p + theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.text.y=element_text(size=15),
        legend.text=element_text(size=15))
  
help(scale_colour_brewer)
colors()
help("scale_colour_manual")
  
##number of listed families
  p <- ggplot(data, mapping = aes(x = Family)) + geom_bar(aes(fill = scientificName))
  p + theme(legend.position="none",axis.text.x = element_text(angle = 60, hjust = 1))
  
