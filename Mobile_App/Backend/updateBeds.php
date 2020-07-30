<?php 

    $servername = "localhost";
    $username = "xxxxxxxx";
    $password = "***********";
    $dbname = "xxxxxxxxdb";
   
    $db=mysqli_connect($servername,$username,$password,$dbname);
    if(!$db){
        echo "Database connection failed";
    }
    
    
    //Response object structure
    $respons = new stdClass;
    $respons->status = null;
    $respons->message = null;
    
    
    if(isset($_POST['beds']))
{$beds = $_POST['beds'];
    $license = $_POST['license'];
$db->query("UPDATE person SET beds = '$beds' WHERE license = '$license'");
$respons->status = true;
$respons->message = "updated successfully";
        }
    
        else {
            $respons->status = false;
            $respons->message = "update failed,enter a value !";
        }
 
    
    header('Content-type: application/json');
    echo json_encode($respons);

?>