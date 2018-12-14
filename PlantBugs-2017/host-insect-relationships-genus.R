#RMariaDB?

#clear brain
rm(list=ls())

#set working directory
setwd("~/Documents/collectionsConservationBio/collectionsConservationBio-git/PlantBugs-2017")

#need mysql connectors for entire script (data frame and mysql)
require(RMySQL)
library("sqldf")
library(RSQLite)

#information about mysql connector
help(RMySQL)

#not sure what this does anymore<-------------
Sys.setlocale('LC_ALL','C')
  
#####################################################################################################################
#####################################################################################################################
###########################Query Database and return data frame of insects and host plants###########################
#####################################################################################################################
#host plants to genus level

#create a connection to the db:
connection <- dbConnect(MySQL(), user="pbi_locality", password="generalPass", dbname="pbi_locality", host="localhost")
  
help(fetch)
#check mysql connnection
dbListTables(connection)
dbListFields(connection, "StateProv")

#mysql query that selects distinct insect and host plants from pbi_locaity database. Need to remove spaces and underscores
rs <- dbSendQuery(connection,"SELECT distinct F4.HostTaxName as h_family,
                  F1.HostTaxName as h_genus,F2.HostTaxName as h_species, T5.TaxName as i_family,T3.TaxName as i_tribe,T1.TaxName as i_genus,
                  T2.TaxName as i_species,F4.HostMNLUID as h_family_id,F1.HostMNLUID as h_genus_id,F2.HostMNLUID as h_species_id, T5.MNLUID as i_family_id,
                  T3.MNLUID as i_tribe_id,T1.MNLUID as i_genus_id,T2.MNLUID as i_species_id 
                  FROM Specimen S1 left join MNL T1 ON S1.Genus=T1.MNLUID 
                  left join MNL T2 ON S1.Species=T2.MNLUID 
                  left join MNL T3 ON S1.Tribe=T3.MNLUID 
                  left join MNL T4 on S1.Subfamily=T4.MNLUID 
                  left join MNL T5 on T4.ParentID=T5.MNLUID 
                  left join Locality L1 on S1.Locality=L1.LocalityUID 
                  left join Flora_MNL F1 ON S1.HostG=F1.HostMNLUID 
                  left join Flora_MNL F2 ON S1.HostSp=F2.HostMNLUID 
                  left join Flora_MNL F3 ON S1.HostSSp=F3.HostMNLUID 
                  left join Flora_MNL F4 ON S1.HostF=F4.HostMNLUID 
                  left join SubDiv SD on L1.SubDivUID=SD.SubDivUID 
                  left join StateProv SP on SD.StateProvUID=SP.StateProvUID 
                  left join colevent CE on S1.ColEventUID=CE.ColEventUID 
                  left join Collector C1 on CE.Collector=C1.CollectorUID 
                  left join Country CN on SP.CountryUID=CN.UID 
                  left join HostCommonName HC on S1.HostCName=HC.CommonUID  
                  WHERE S1.Insect_ID=1 
                  AND F1.HostTaxName !='0' 
                  AND F1.HostTaxName !='' 
                  AND F1.HostTaxName !='spp.' 
                  AND F1.HostTaxName not like '%cf.%' 
                  AND F1.HostTaxName not like '%nr.%' 
                  AND F1.HostTaxName !='Unknown' 
                  AND F2.HostMNLUID != '0' 
                  AND T1.TaxName not like '%sp.%' 
                  AND T2.TaxName not like '%sp.%' 
                  AND F2.HostTaxName not like \"%'%\"
                  AND F1.HostTaxName not like \"%'%\"
                  AND F4.HostTaxName !='Unplaced'
                  AND T5.TaxName = 'Miridae'")

while (!dbHasCompleted(rs)) {
  chunk <- dbFetch(rs, 10)
  print(nrow(chunk))
  write.table(chunk, file = "temp-data/host-insect-d1-output.txt", na = "NA", row.names = FALSE,col = FALSE, append = TRUE, sep="\t", quote=FALSE)
}

#add headers to file that gets data from database for loop below. Does not append so this will delete information in file if run
headers <- paste("i_genus","i_species","dlat","dlong","georef_method","GeoRefAccuracy","country","stateProv","collectingID","h_family","h_genus","h_species","i_family","i_tribe","i_genus","i_species","h_family_id","h_genus_id","h_species_id","i_family_id","i_tribe_id","i_genus_id","i_species_id", sep = "\t" )
write.table(headers, file = "temp-data/lat-long-Miridae.txt", na = "NA", row.names = FALSE, col = FALSE, append = FALSE, sep="\t", quote=FALSE)


#mysql query that selects lat-long insect and host plants from pbi_locaity database. Need to remove spaces and underscores
rs <- dbSendQuery(connection,"Select T1.TaxName as genus,T2.TaxName as species, L1.DLat as dlat, L1.DLong as dlong, L1.GeoRefMethod as geoMethod, L1.LocAccuracy as location_accuracy,CN.Country as country,SP.StateProv as stateProv,S1.ColEventUID as eventID,F4.HostTaxName as h_family,
                  F1.HostTaxName as h_genus,F2.HostTaxName as h_species, T5.TaxName as i_family,T3.TaxName as i_tribe,T1.TaxName as i_genus,
                  T2.TaxName as i_species,F4.HostMNLUID as h_family_id,F1.HostMNLUID as h_genus_id,F2.HostMNLUID as h_species_id, T5.MNLUID as i_family_id,
                  T3.MNLUID as i_tribe_id,T1.MNLUID as i_genus_id,T2.MNLUID as i_species_id
                  FROM Specimen S1 
                  left join MNL T1 ON S1.Genus = T1.MNLUID 
                  left join MNL T2  ON S1.Species = T2.MNLUID 
                  left join MNL T3 ON S1.Tribe=T3.MNLUID 
                  left join MNL T4 on S1.Subfamily=T4.MNLUID 
                  left join MNL T5 on T4.ParentID=T5.MNLUID 
                  left join Locality L1 on S1.Locality=L1.LocalityUID 
                  left join Flora_MNL F1 ON S1.HostG=F1.HostMNLUID 
                  left join Flora_MNL F2 ON S1.HostSp=F2.HostMNLUID 
                  left join Flora_MNL F3 ON S1.HostSSp=F3.HostMNLUID 
                  left join Flora_MNL F4 ON S1.HostF=F4.HostMNLUID 
                  left join SubDiv SD on L1.SubDivUID=SD.SubDivUID 
                  left join StateProv SP on SD.StateProvUID=SP.StateProvUID 
                  left join colevent CE on S1.ColEventUID=CE.ColEventUID 
                  left join Collector C1 on CE.Collector=C1.CollectorUID 
                  left join Country CN on SP.CountryUID=CN.UID 
                  WHERE T5.TaxName = 'Miridae' AND (CN.UID = '2' or CN.UID = '8' or CN.UID = '11')")

while (!dbHasCompleted(rs)) {
  chunk <- dbFetch(rs, 10)
  print(nrow(chunk))
  write.table(chunk, file = "temp-data/lat-long-Miridae.txt", na = "NA", row.names = FALSE,col = FALSE, append = TRUE, sep="\t", quote=FALSE)
}




require(igraph)
require(ggplot2)
require(gplots)
require(vcd)


##########################################################################################################################
#read in file in memory
counts = read.delim(file="temp-data/lat-long-Miridae.txt", header = TRUE, sep = "\t")
head(counts)


##########################################################################################################################
#requirements
require(RMySQL)
require(igraph)

#create a connection to the db and write to a table
connection <- dbConnect(MySQL(), user="pbi_locality", password="generalPass", dbname="pbi_locality", host="localhost")
host <- dbGetQuery(connection, "select distinct concat(i_genus,\"_\",i_species) as insect, concat(h_family, \"_\", h_genus) as host, coll_percent as percent from host_network")
write.table(host, "temp-data/edges3.txt", sep=",", row.names=FALSE , col.names=TRUE, quote=FALSE)
write.table(host$host, "temp-data/plants.txt", sep=",", row.names=FALSE , col.names=TRUE, quote=FALSE)




bsk <- read.delim(file="temp-data/edges3.txt",sep=",",head=TRUE)
bsk.network<-graph.data.frame(bsk, directed=F)
V(bsk.network) #prints the list of vertices (people)
E(bsk.network) #prints the list of edges (relationships)
degree(bsk.network) #print the number of edges per vertex (relationships per people)
#V(bsk.network)$size<-degree(bsk.network)
vertex.label=V(bsk.network)$name<-ifelse(degree(bsk.network) > 1000,V(bsk.network)$name,'')
E(bsk.network)$width<- 2
plot(bsk.network)

g <- graph_from_incidence_matrix(bsk.network)
plot(bsk.network, layout = layout_as_bipartite,
     vertex.color=c("green","cyan")[V(g)$type+1])
help(graph_from_incidence_matrix)
# Two columns
g %>%
  add_layout_(as_bipartite()) %>%
  plot()

help(igraph)
help(plot)


####Below this line is unused code################
##################################Not used below##################
#gets all distinct species ids in the database no matter what taxon
  rsp <- dbSendQuery(connection, paste("Select distinct Species from Specimen",  sep = ""))
  while (!dbHasCompleted(rsp)) {
    chunk <- dbFetch(rsp, 10)
    print(nrow(chunk))
    write.table(chunk, file = "temp-data/all-species-id.txt", na = "NA", row.names = FALSE,col = FALSE, append = TRUE, sep="\t", quote=FALSE)
  }
  

all_species_ids <- read.table(file = "temp-data/all-species-id.txt")


#this does not quite work. Something is wrong

#limited to one family Miridae from SQL that created output file. Will limit geographically to US, Canada and Mexico, and remove some bad data in next query set.
#write to table. Iterates through the list of all species ids in the database and checks to see if they fit the criteria of below.
for (single_species in all_species_ids) {
  rsp <- dbSendQuery(connection,paste("Select T1.TaxName,T2.TaxName, L1.DLat, L1.DLong, L1.GeoRefMethod, L1.LocAccuracy FROM Specimen S1 left join MNL T1 ON S1.Genus = T1.MNLUID left join MNL T2  ON S1.Species = T2.MNLUID left join MNL T3 ON S1.Tribe=T3.MNLUID left join MNL T4 on S1.Subfamily=T4.MNLUID left join MNL T5 on T4.ParentID=T5.MNLUID left join Locality L1 on S1.Locality=L1.LocalityUID left join Flora_MNL F1 ON S1.HostG=F1.HostMNLUID left join Flora_MNL F2 ON S1.HostSp=F2.HostMNLUID left join Flora_MNL F3 ON S1.HostSSp=F3.HostMNLUID left join Flora_MNL F4 ON S1.HostF=F4.HostMNLUID left join SubDiv SD on L1.SubDivUID=SD.SubDivUID left join StateProv SP on SD.StateProvUID=SP.StateProvUID left join colevent CE on S1.ColEventUID=CE.ColEventUID left join Collector C1 on CE.Collector=C1.CollectorUID left join Country CN on SP.CountryUID=CN.UID WHERE T5.TaxName = 'Miridae' AND (CN.UID = '2' or CN.UID = '8' or CN.UID = '11') AND S1.species='",single_species,"'",  sep = ""))
  while (!dbHasCompleted(rsp)) {
    chunk <- dbFetch(rsp, 10)
    print(nrow(chunk))
    write.table(chunk, file = "temp-data/lat-long-Miridae.txt", na = "NA", row.names = FALSE,col = FALSE, append = TRUE, sep="\t", quote=FALSE)
  }
}


#if need to type warngings, type in command line warmings()

# Random bipartite graph
inc <- matrix(sample(0:1, 50, replace = TRUE, prob=c(2,1)), 10, 5)
g <- graph_from_incidence_matrix(inc)
plot(g, layout = layout_as_bipartite,
     vertex.color=c("green","cyan")[V(g)$type+1])

# Two columns
g %>%
  add_layout_(as_bipartite()) %>%
  plot()

