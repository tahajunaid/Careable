<?php
    $servername = "localhost";
    $username = "xxxxxxxx";
    $password = "***********";
    $dbname = "xxxxxxxxdb";
   
    $db=mysqli_connect($servername,$username,$password,$dbname);
    if(!$db){
        echo "Database connection failed";
    }
    
   
    $lat = $_POST['lat'];
    $lon = $_POST['lon'];
    
    $list =array();
    $person = $db->query("SELECT * FROM person order by 111.111 *DEGREES(ACOS(LEAST(1.0, COS(RADIANS(latitude))* COS(RADIANS($lat))* COS(RADIANS(longitude - $lon))+ SIN(RADIANS(latitude))* SIN(RADIANS($lat)))))");
    
    //$person = $db->query("SELECT * FROM person having (111.111 *DEGREES(ACOS(LEAST(1.0, COS(RADIANS(latitude))* COS(RADIANS($lat))* COS(RADIANS(longitude - $lon))+ SIN(RADIANS(latitude))* SIN(RADIANS($lat))))))<15 order by 111.111 *DEGREES(ACOS(LEAST(1
    
    while ($rowdata = $person->fetch_assoc()) {$list[]=$rowdata;}
    
    echo json_encode($list);
    
    
    
?>