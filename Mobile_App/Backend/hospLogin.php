<?php
    $servername = "localhost";
    $username = "xxxxxxxx";
    $password = "***********";
    $dbname = "xxxxxxxxdb";
   
    $db=mysqli_connect($servername,$username,$password,$dbname);

$license = $_POST['license'];
    $password = $_POST['password'];
        
    //creating a query
    $result = $db->query("SELECT * FROM person WHERE license='$license' AND password = '$password'");
            
        
    if($result->num_rows>0){
        
    while ($row = mysqli_fetch_assoc($result)) {
        
$json['value'] = 1;
$json['message'] = 'User Successfully LoggedIn';
$json['license'] = $row['license'];
$json['status'] = 'success';
}
}else{
    
$json['value'] = 0;
$json['message'] = 'Unregistered License,Please Sign Up.';
$json['license'] = '';
$json['status'] = 'failure';
    
    }
    echo json_encode($json);
    mysqli_close($db);
?>