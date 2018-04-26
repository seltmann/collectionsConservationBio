# collectionsConservationBio

1. host-insect-relationships.php
2. host-insect-inference.php
3. source allUSDAEndangeredPlants.sql



echo "select * from host_network;" | mysql -u root -p -D pbi_locality > hostNetwork.tsv

**coll_number_same_h** = how many separate collecting events was that insect was collected on that host
**coll_total_i** = total number of collecting events the insect was collected where host species was recorded
**coll_percent** = the percent of all known collecting events for this insect species does the relationship between this host and insect represent?

#what percent of collecting events for a species are on a redlisted plant?
perportion of that species of insect that were on a red listed host		
0.555555556		proportion = fraction
0.047619048		probability is the perportion of species of insect found on red listed plant
0.157894737		probability of record in database vs sampling in the wild
