<?php

include('session.php');

$_SESSION['pageStore'] = "update_bed.php";
if (isset($_SESSION['login_id'])) {
      $user_id = $_SESSION['login_id'];

function func($session_beds)
{
  echo '<div style="text-align:center;font-size:35px">
  <label>Current Beds :</label>
  '
  . $session_beds
  . '<br>

  </div>';
}
$var="func";

call_user_func($var,"$session_beds");
if (isset($_POST['Update'])) {

$beds_1=$_POST['beds_1'];

include('config.php');

$sql ="UPDATE account SET beds='$beds_1' WHERE id ='$user_id'";

if ($conn->query($sql) === TRUE) {
  echo '<div style="text-align:center;font-size:20px">Record updated successfully</div>';
  $session_beds=$beds_1;
  //call_user_func($var,"$session_beds");
  header("refresh:1.0");
} else {
  echo "Error updating record: ";
}
$conn->close();
}
}
?>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <link rel="stylesheet" href="stl.css">
</head>
<body>
  <form method="post" action="">
  <div style="text-align:center;font-size:35px">
  <label>Update to :</label>
  <input type="number" name="beds_1" min="1" class="rlform-input" required>
  <button type="update" class="rlform-btn" name="Update">Update!</button>

  <br>

  <a href="index.php">Profile</a>
</form>
<form action="logout.php">
   <input type="submit" class="button1" value="Logout"/>
</form>

</div>

</body>
</html>

<style>
<?php include 'stl.css'; ?>
</style>
