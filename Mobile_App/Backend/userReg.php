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
    
    
   
    $name = $_POST['name'];
    $email = $_POST['email'];
    $password = $_POST['password'];
    $result = $db->query("SELECT * FROM users WHERE email='$email'");
            
        
    if($result->num_rows=0){
    
    	if (isset($_POST['email'])) {
            $db->query("INSERT INTO users(name,email,password)VALUES('".$name."','".$email."','".$password."')");
        
            $response->status = true;
            $response->message = "User Registered Successfully";
    	}else{
            $response->status = false;
            $response->message = "Sign Up Failed,Please Retry.";
             }
    }else
       {$response->status = false;
        $response->message = "User Already Exists,Please Login.";
	}
    
    header('Content-type: application/json');
    echo json_encode($response);

?>