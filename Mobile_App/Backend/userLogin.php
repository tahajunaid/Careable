<?php
    $servername = "localhost";
    $username = "xxxxxxxx";
    $password = "***********";
    $dbname = "xxxxxxxxdb";
   
    $db=mysqli_connect($servername,$username,$password,$dbname);

$email = $_POST['email'];
    $password = $_POST['password'];
        
    //creating a query
    $result = $db->query("SELECT * FROM users WHERE email='$email' AND password = '$password'");
            
        
    if($result->num_rows>0){
        
    while ($row = mysqli_fetch_assoc($result)) {
        
$json['value'] = 1;
$json['message'] = 'User Successfully LoggedIn';
$json['email'] = $row['email'];
$json['status'] = 'success';
}
}else{
    
$json['value'] = 0;
$json['message'] = 'Sign Up to Login!';
$json['email'] = '';
$json['status'] = 'failure';
    
    }
    echo json_encode($json);
    mysqli_close($db);
?>