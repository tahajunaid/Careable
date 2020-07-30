<?php



include('session.php');
$_SESSION['pageStore'] = "index.php";

if(!isset($_SESSION['login_id'])){
header("location: login.php"); // Redirecting To login
}
echo '<div style="text-align:center;font-size:35px">
<strong>Profile</strong>
<br>'
.$session_fullName
. '<br>
<a href="update_bed.php">Update bed</a>

</div>';
?>

<style>
<?php include 'stl.css'; ?>
</style>

<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <link rel="stylesheet" href="stl.css">
</head>
<body>
  <form action="logout.php">
  <input type="submit" class="button1" value="Logout"/>
</form>
</body>
