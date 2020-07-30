<?php
    $servername = "localhost";
    $username = "xxxxxxxx";
    $password = "***********";
    $dbname = "xxxxxxxxdb";
   
    $db=mysqli_connect($servername,$username,$password,$dbname);
    if(!$db){
        echo "Database connection failed";
    }
    $list =array();
    $news = $db->query("SELECT * FROM news");
    while ($rowdata = $news->fetch_assoc()) {
        $list[]=$rowdata;
        
    }
    
    echo json_encode($list);
?>