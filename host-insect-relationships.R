#RMariaDB?

#clear brain
rm(list=ls())

#set working directory
setwd("~/Documents/collectionsConservationBio/collectionsConservationBio-git")

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


#create a connection to the db:
connection <- dbConnect(MySQL(), user="pbi_locality", password="generalPass", dbname="pbi_locality", host="localhost")
  
#check mysql connnection
dbListTables(connection)
dbListFields(connection, "host_network")

#mysql query that selects insect and host plants from pbi_locaity database. Need to remove spaces and underscores
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
                  AND F2.HostTaxName not like '%sp.%' 
                  AND F2.HostTaxName not like '%spp.%' 
                  AND F2.HostTaxName not like '%unknown%' 
                  AND F2.HostMNLUID != '0' 
                  AND T1.TaxName not like '%sp.%' 
                  AND T2.TaxName not like '%sp.%' 
                  AND F2.HostTaxName not like \"%'%\"
                  AND F1.HostTaxName not like \"%'%\"
                  AND F4.HostTaxName !='Unplaced'")

d1 <- fetch(rs)
head(d1)

write.table(d1, "temp-data/host-insect-d1-output.txt", , na = "NA", row.names = FALSE,col = TRUE, append = FALSE, sep="\t", quote=FALSE)

#clears the mysql memory before going forward
dbClearResult(rs)

#####################################################################################################################
#####################################################################################################################
###########################Do stuff with data frame ###########################
#####################################################################################################################

#read in output data frame from part 1 of the script. Good to do this because keeps the output of the first part intact in case we do something silly
interactions <- read.table("temp-data/host-insect-d1-output.txt", header=TRUE, sep = "\t")

head(interactions)
for (i_species_id in interactions) {
  #print(i_species_id)
  rs <- dbSendQuery(connection,"Select count(distinct ColEventUID) from Specimen 
                  where Specimen.species=",i_species_id," AND Specimen.species !='0' AND Specimen.HostSp != '0'")

  }





#total number of collecting events the insect was collected where host species was recorded
#	function coll_total_i($i_species_id){
#global $con;
#$sql = "Select count(distinct ColEventUID) from Specimen where Specimen.species='$i_species_id' AND Specimen.species !='0' AND Specimen.HostSp != '0'";
#$results=mysqli_query($con,$sql);
#$row=mysqli_fetch_array($results,MYSQLI_NUM);
#$counts = $row[0];
#echo $counts;
#$sql_update = "UPDATE `pbi_locality`.`host_network` SET `coll_total_i` = '$counts' where `i_species_id`='$i_species_id'";
#mysqli_query($con,$sql_update);
#return $counts;	
#}


