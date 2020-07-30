<?php
    $servername = "localhost";
    $username = "xxxxxxxx";
    $password = "***********";
    $dbname = "xxxxxxxxdb";
   
    $db=mysqli_connect($servername,$username,$password,$dbname);
    if(!$db){
        echo "Database connection failed";
    }
    
   //SELECT * FROM person order by (6371 * acos( cos( radians(17.35683) ) * cos( radians( latitude ) ) * cos( radians( longitude ) - radians(78.47133) ) + sin( radians(17.35683) ) * sin( radians( latitude ) ) ) )
    $search = $_POST['search'];
    
    $list =array();
    $person = $db->query("SELECT * FROM person where hospname like '%$search%'");
    
    while ($rowdata = $person->fetch_assoc()) {$list[]=$rowdata;}
    
    echo json_encode($list);
    
    
    
?>