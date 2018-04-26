<?php
$fp = fopen('redListdata.txt', 'w');
include("db.php");// Check connection
//check mysql connection
if (mysqli_connect_errno())
  {
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
  }

  $to_file = '';
  //gets all of the insect species ids that are on red listed plants
  	$sql = "Select distinct(i_species_id) from host_network where redlist='TRUE';";
  	$results=mysqli_query($con,$sql);
	
   		   while ($row=mysqli_fetch_array($results,MYSQLI_NUM)){
    			   $i_species_id = $row[0];
	  			   $numberOnListedHosts = numberOnListedHosts($i_species_id);
	  			   $numberOnAnyHost = numberOnAnyHost($i_species_id);
				   $taxonomy = taxonomy($i_species_id);
	
	
    			   $to_file .= $i_species_id . "\t" . $numberOnListedHosts . "\t" . $numberOnAnyHost . "\t" . $taxonomy . "\n";
	
  		   }
		   
   		$to_file = "insect_species_id" . "\t" . "numberOnListedHosts" . "\t" . "numberOnAnyHost" . "\t" . "Family" . "\t" . "Genus" . "\t" . "Species" . "\n" . $to_file;
   		fwrite($fp, $to_file);	
		   
	   	//number of colecting events in total for insect species that are on red listed plants
	   	function numberOnAnyHost($i_species_id){
	   		global $con;
	   		$sql = "Select sum(coll_number_same_h) from host_network where i_species_id='$i_species_id'";
	   		$results=mysqli_query($con,$sql);
	   		$row=mysqli_fetch_array($results,MYSQLI_NUM);
	   		$counts = $row[0];
	   		return $counts;	
	   	}
		
	   	//number of colecting events in total for insect species that are on red listed plants
	   	function numberOnListedHosts($i_species_id){
	   		global $con;
	   		$sql = "Select sum(coll_number_same_h) from host_network where i_species_id='$i_species_id' and redList='TRUE'";
	   		$results=mysqli_query($con,$sql);
	   		$row=mysqli_fetch_array($results,MYSQLI_NUM);
	   		$counts = $row[0];
	   		return $counts;	
	   	}
		
	   	//number of colecting events in total for insect species that are on red listed plants
	   	function taxonomy($i_species_id){
	   		global $con;
	   		$sql = "Select i_family,i_genus,i_species from host_network where i_species_id='$i_species_id'";
	   		$results=mysqli_query($con,$sql);
	   		$row=mysqli_fetch_array($results,MYSQLI_NUM);
	   		$i_family = $row[0];
			$i_genus = $row[1];
			$i_species = $row[2];
	   		return $i_family . "\t" . $i_genus . "\t" . $i_species;	
	   	}

// Free result set

mysqli_close($con);
 
?>