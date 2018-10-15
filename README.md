## Estimating the number of declining species using natural history collections

[```Introduction```](#Introduction) / [```Citation```](#citation) / [```Definitions```](#definitions) / [```Included Resources```](#included-resources) /  [```Data Issues```](#data-issues) / [```Summary```](#summary)

###Introduction
Some species are at a greater risk of extinction because they have combinations of extinction promoting traits. It is difficult to assess this risk in insects because they are small, difficult to identify and their current populations and distributions are unknown or difficult to determine. Insects in the family Miridae, or plant bugs, are a speciose order of insects that are known to be specialist plant predators. We assess the probable risk of Miridae species extinction by evaluating their specialization on threatened and endangered host plants, and use the better known host plants as a proxy for evaluating the plant bugs. In addition, this paper is part of a new generation of synthetic biological data research that utilizes the large amount of well-determined and geocoded natural history collection data available through the Integrated Digitized Biocollections project, and as such, introduces new methods for evaluating and handling those datasets.

### Citation
Katja C. Seltmann


###Definitions

1. host-insect-relationships.php
2. host-insect-inference.php
3. source allUSDAEndangeredPlants.sql



echo "select * from host_network;" | mysql -u root -p -D pbi_locality > hostNetwork.tsv

**coll_number_same_h** = how many separate collecting events was that insect was collected on that host
**coll_total_i** = total number of collecting events the insect was collected where host species was recorded
**coll_percent** = the percent of all known collecting events for this insect species does the relationship between this host and insect represent?

###Included Resources

###Data Issues

###Summary
perportion of that species of insect that were on a red listed host		
0.555555556		proportion = fraction
0.047619048		probability is the perportion of species of insect found on red listed plant
0.157894737		probability of record in database vs sampling in the wild, which has variables 

