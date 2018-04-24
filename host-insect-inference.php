<?php


include("db.php");// Check connection

//check mysql connection
if (mysqli_connect_errno())
  {
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
  }

  //===table columns in host_network_species table
  //====i_family, i_tribe, i_genus, i_species, h_family, h_genus, h_species
  //====i_family_id, i_tribe_id, i_genus_id, i_species_id, h_family_id, h_genus_id, h_species_id

  //====coll_total_i - total number of times the insect was collected at any collecting event, indifferent of host collected on
  //====coll_number_same_h - number of times collected at different collecting events, of host (at species level) + insect (at species level) - returns numberic value
  //====coll_percent - percent of total colevents host (at species level) + insect (at species level)

  //====h_n_specimens - greatest number of specimens found at single collecting event (at species level) (total)
  //====i_j_same_col - number of total juveniles are found on host (at species level) - returns numberic value
  //====h_voucher - occurrence is verified by vouchered host specimen - number of specimens that were vouchered

//gets the information about the unique associations found in the host_network_species table
	$sql = "Select * from host_network";
	$results=mysqli_query($con,$sql);
	
 		   while ($row=mysqli_fetch_array($results,MYSQLI_NUM)){
  			   $id = $row[0];
  			   $h_family = $row[1];
  			   $h_genus = $row[2];
  			   $h_species = $row[3];
  			   $i_family = $row[4];
  			   $i_tribe = $row[5];
  			   $i_genus = $row[6];
  			   $i_species = $row[7];
  			   $i_family_id = $row[8];
  			   $i_tribe_id = $row[9];
  			   $i_genus_id = $row[10];
  			   $i_species_id = $row[11];
  			   $h_family_id = $row[12];
  			   $h_genus_id = $row[13];
  			   $h_species_id = $row[14];
		
	
  			   $is_vouchered = h_voucher($h_species_id,$i_species_id);
  			   $number_juveniles = i_j_same_col($h_species_id,$i_species_id);
  			   $greatest_number_specimens = h_n_specimens($h_species_id,$i_species_id);
  			   $coll_total_i = coll_total_i($i_species_id);
  			   $coll_number_same_h = coll_number_same_h($h_species_id,$i_species_id);
  			   $coll_percent = coll_percent($coll_total_i,$coll_number_same_h,$h_species_id,$i_species_id);
	
	
  			   echo $h_family . " " . $h_genus . " " . $i_genus . " " . $i_species . " " . $id . " " . $is_vouchered . " " . $number_juveniles . " " . $greatest_number_specimens . " " . $coll_total_i. " ". $coll_number_same_h . " " . $coll_percent . "\n";
	
		   }
	
	
	/////---functions below ////////
	
	//total number of collecting events the insect was collected where host sp were recorded
	function coll_total_i($i_species_id){
			global $con;
		$sql = "Select count(distinct ColEventUID) from Specimen where Specimen.species='$i_species_id' AND Specimen.species !='0' AND Specimen.HostSp != '0'";
		$results=mysqli_query($con,$sql);
		$row=mysqli_fetch_array($results,MYSQLI_NUM);
		$counts = $row[0];
		//echo $counts;
		//$sql_update = "UPDATE `pbi_locality`.`host_network` SET `coll_total_i` = '$counts' where `i_species_id`='$i_species_id'";
		//mysqli_query($con,$sql_update);
		return $counts;	
	
	}
	
	
	//checks to see if vouchers are found with the host-associate combination		
	function h_voucher($h_species_id,$i_species_id){
		 global $con;
		$sql = "Select count(distinct FieldHost.HerbID) from FieldHost left join Specimen on Specimen.FieldHostUID=FieldHost.FieldHostUID where Specimen.HostG='$h_species_id' AND Specimen.species='$i_species_id' AND FieldHost.HerbID !=''";
		$results=mysqli_query($con,$sql);
		$row=mysqli_fetch_array($results,MYSQLI_NUM);
		$counts = $row[0];
		$sql_update = "UPDATE `pbi_locality`.`host_network` SET `h_voucher` = '$counts' where `i_species_id`='$i_species_id' AND `h_species_id`='$h_species_id'";
		mysqli_query($con,$sql_update);
		return $counts;	
            
	}


	//percent of all collecting events is this association representing?
	function coll_percent($coll_total_i,$coll_number_same_h,$h_species_id,$i_species_id){
		global $con;
		$insert_percent = ($coll_number_same_h / $coll_total_i) * 100;
		$rounded_percent = round($insert_percent,2);
		$sql_update = "UPDATE `pbi_locality`.`host_network` SET `coll_percent` = '$rounded_percent' where `i_species_id`='$i_species_id' AND `h_species_id`='$h_species_id'";
		mysqli_query($con,$sql_update);
		return $rounded_percent;
	}


	//number of colecting events with this combination
	function coll_number_same_h($h_species_id,$i_species_id){
		global $con;
		$sql = "Select count(distinct ColEventUID) from Specimen where Specimen.HostSp='$h_species_id' AND Specimen.species='$i_species_id'";
		$results=mysqli_query($con,$sql);
		$row=mysqli_fetch_array($results,MYSQLI_NUM);
		$counts = $row[0];
		$sql_update = "UPDATE `pbi_locality`.`host_network` SET `coll_number_same_h` = '$counts' where `i_species_id`='$i_species_id' AND `h_species_id`='$h_species_id'";
		mysqli_query($con,$sql_update);
		return $counts;	
	}
	

	//number of specimens found at a collecting event that is same species on same host. Cannot tell if that is the same plant or not.
	//some information about number of specimens of things on same pin is in the notes. Could TRUE/FALSE if has like '%on pin%' as indication of more than one specimen. This again does not assume same plant, just collected together.

	function h_n_specimens($h_species_id,$i_species_id){
		global $con;
		$sql = "Select count(SpecimenUID), ColEventUID from Specimen where Specimen.HostSp='$h_species_id' AND Specimen.species='$i_species_id' GROUP BY ColEventUID order by count(SpecimenUID) desc limit 1";
		$results=mysqli_query($con,$sql);
		$row=mysqli_fetch_array($results,MYSQLI_NUM);
		$counts = $row[0];
		$sql_update = "UPDATE `pbi_locality`.`host_network` SET `h_n_specimens` = '$counts' where `i_species_id`='$i_species_id' AND `h_species_id`='$h_species_id'";
		mysqli_query($con,$sql_update);
		return $counts;	
	}
	

	//checks to see if juvys or eggs are found with the host-associate combination
	function i_j_same_col($h_species_id,$i_species_id){
		global $con;
		$sql = "Select count(SpecimenUID) from Specimen where Specimen.HostG='$h_species_id' AND Specimen.species='$i_species_id' AND (Specimen.Sex like '%Juvenile%' OR Specimen.Sex like '%Subadult%' OR Specimen.Sex like '%Egg%')";
		$results=mysqli_query($con,$sql);
		$row=mysqli_fetch_array($results,MYSQLI_NUM);
		$counts = $row[0];
		$sql_update = "UPDATE `pbi_locality`.`host_network` SET `i_j_same_col` = '$counts' where `i_species_id`='$i_species_id' AND `h_species_id`='$h_species_id'";
		mysqli_query($con,$sql_update);
		return $counts;	
	}




  // Free result set
  mysqli_free_result($results);

  mysqli_close($con);
  ?>
