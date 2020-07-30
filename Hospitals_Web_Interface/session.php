<?php

  // Make connection with database
include('config.php');


session_start();// Starting Session

if (isset($_SESSION['login_id'])) {
      $user_id = $_SESSION['login_id'];


$Squery = "SELECT fullName from account where id = ? LIMIT 1";
$Squery1 = "SELECT beds from account where id = ? LIMIT 1";


// To protect MySQL injection for Security purpose
$stmt = $conn->prepare($Squery);
$stmt->bind_param("i", $user_id);
$stmt->execute();
$stmt->bind_result($fullName);
$stmt->store_result();

$stmt1 = $conn->prepare($Squery1);
$stmt1->bind_param("i", $user_id);
$stmt1->execute();
$stmt1->bind_result($beds);
$stmt1->store_result();

if($stmt->fetch()) //fetching the contents of the row
        {
        	$session_fullName = $fullName;
          $stmt->close();

        }
        if($stmt1->fetch()) //fetching the contents of the row
                {
                	$session_beds = $beds;
                  $stmt1->close();

                }



}


$conn->close();


?>
