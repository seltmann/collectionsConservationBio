<?php


include("db.php");// Check connection

//check mysql connection
if (mysqli_connect_errno())
  {
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
  }

//selects insect and host plants from pbi_locaity database and adds them to the host network table
	
	$sql="SELECT distinct F4.HostTaxName,F1.HostTaxName,T5.TaxName,T3.TaxName,T1.TaxName,T2.TaxName,F4.HostMNLUID,F1.HostMNLUID,T5.MNLUID,T3.MNLUID,T1.MNLUID,T2.MNLUID,F2.HostTaxName,F2.HostMNLUID FROM Specimen S1 left join MNL T1 ON S1.Genus=T1.MNLUID left join MNL T2 ON S1.Species=T2.MNLUID left join MNL T3 ON S1.Tribe=T3.MNLUID left join MNL T4 on S1.Subfamily=T4.MNLUID left join MNL T5 on T4.ParentID=T5.MNLUID left join Locality L1 on S1.Locality=L1.LocalityUID left join Flora_MNL F1 ON S1.HostG=F1.HostMNLUID left join Flora_MNL F2 ON S1.HostSp=F2.HostMNLUID left join Flora_MNL F3 ON S1.HostSSp=F3.HostMNLUID left join Flora_MNL F4 ON S1.HostF=F4.HostMNLUID left join SubDiv SD on L1.SubDivUID=SD.SubDivUID left join StateProv SP on SD.StateProvUID=SP.StateProvUID left join colevent CE on S1.ColEventUID=CE.ColEventUID left join Collector C1 on CE.Collector=C1.CollectorUID left join Country CN on SP.CountryUID=CN.UID left join HostCommonName HC on S1.HostCName=HC.CommonUID  WHERE S1.Insect_ID=1 AND F1.HostTaxName !='0' AND F1.HostTaxName !='' AND F1.HostTaxName !='spp.' AND F1.HostTaxName not like '%cf.%' AND F1.HostTaxName not like '%nr.%' AND F1.HostTaxName !='Unknown' AND F2.HostTaxName not like '%sp.%' AND F2.HostTaxName not like '%spp.%' AND F2.HostTaxName not like '%unknown%' AND F2.HostMNLUID != '0' AND T1.TaxName not like '%\_%' AND T2.TaxName not like '%\_%' AND T1.TaxName not like '%sp.%' AND T2.TaxName not like '%sp.%' AND F2.HostTaxName not like '%\'%' AND F1.HostTaxName not like '%\'%' AND F4.HostTaxName !='Unplaced'";

$result=mysqli_query($con,$sql);

while ($row=mysqli_fetch_array($result,MYSQLI_NUM)){
	
	$h_family = $row[0];	//F4.HostTaxName - 0 - h_family
	$h_genus = $row[12];	//F1.HostTaxName - 1 - h_genus
	$i_family = $row[2];	//T5.TaxName - 3 - i_family
	$i_tribe = $row[3];		//T3.TaxName - 4 - i_tribe
	$i_genus = $row[4];		//T1.TaxName - 5 - i_genus
	$i_species = $row[5];	//T2.TaxName - 6 - i_species
	$h_family_id = $row[6];	//F4.HostMNLUID - 7 - h_family_id
	$h_genus_id = $row[7];	//F1.HostMNLUID - 8 - h_genus_id
	$i_family_id = $row[8];//T5.MNLUID - 10 - i_family_id
	$i_tribe_id = $row[9];	//T3.MNLUID - 11 - i_tribe_id
	$i_genus_id = $row[10];	//T1.MNLUID - 12 - i_genus_id
	$i_species_id = $row[11];//T2.MNLUID - 13 - i_species_id
	$h_species = $row[1];	//F2.HostTaxName - 14 - h_species
	$h_species_id = $row[13];//F2.HostMNLUID - 15 - h_species_id

	echo $row[0] . "$" . $row[1] ."$" . $row[12] ."$" . $row[2] ."$" . $row[3] ."$" . $row[4] ."$" . $row[5] ."$" . $row[6] . $row[7] ."$" . $row[13] ."$" . $row[8] ."$" . $row[9] ."$" . $row[10] ."$" . $row[11]."\n"; 
	$sql_insert = "INSERT INTO `pbi_locality`.`host_network` (`id`, `h_family`, `h_species`,`h_genus`,`i_family`,`i_tribe`,`i_genus`,`i_species`,`h_family_id`,`h_genus_id`,`h_species_id`,`i_family_id`, `i_tribe_id`, `i_genus_id`, `i_species_id`) VALUES (NULL, '$h_family', '$h_genus', '$h_species','$i_family', '$i_tribe', '$i_genus', '$i_species', '$h_family_id', '$h_genus_id','$h_species_id','$i_family_id', '$i_tribe_id', '$i_genus_id', '$i_species_id')";

	mysqli_query($con,$sql_insert);
}

// Free result set
mysqli_free_result($result);

mysqli_close($con);
?>
