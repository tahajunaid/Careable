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
    $response = new stdClass;
    $response->status = null;
    $response->message = null;
    
    //Uploading File
    $destination_dir = "uploads/";
    
    $base_filename = basename($_FILES["image"]["name"]);
    //new
    $license = $_POST['license'];
    $hospname = $_POST['hospname'];
    $address = $_POST['address'];
    $beds = $_POST['beds'];
    $password = $_POST['password'];
    $latitude = $_POST['latitude'];
    $longitude = $_POST['longitude'];
    $email=basename($_FILES["image"]["name"]);
    
    //------
    $temp = explode(".", $base_filename);
    $target_file = $destination_dir .round(microtime(true)) . '.' . end($temp);
    $path = "https://careableindia.000webhostapp.com/" . $target_file;
    //$base_filename = basename($_FILES["file"]["name"]);
    //$target_file = $destination_dir . $base_filename;
    
    if (isset($_FILES["image"])) {
        if (move_uploaded_file($_FILES["image"]["tmp_name"], $target_file)){
            //$sql = "INSERT INTO person (name, image) VALUES ('$name', '$path')";
            $db->query("INSERT INTO person(license,hospname,address,beds,image,password,latitude,longitude)VALUES('".$license."','".$hospname."','".$address."','".$beds."','".$path."','".$password."','".$latitude."','".$longitude."')");
        
            $response->status = false;
            $response->message = "Hospital Registration Successfull";
        }
    
        else {
            $response->status = false;
            $response->message = "Registration Failed";
        }
    }else{
        $response->status = false;
        $response->message = "Registration Failed";
    }
    
    header('Content-type: application/json');
    echo json_encode($response);

?>