<?php
session_start();// Starting Session

//if session exit, user nither need to signin nor need to signup
if(isset($_SESSION['login_id'])){
  if (isset($_SESSION['pageStore'])) {
      $pageStore = $_SESSION['pageStore'];
header("location: $pageStore"); // Redirecting To Profile Page
    }
}

//Register progess start, if user press the signup button
if (isset($_POST['signUp'])) {
if (empty($_POST['fullName']) || empty($_POST['license']) || empty($_POST['email']) || empty($_POST['beds']) || empty($_POST['address']) || empty($_POST['newPassword']))
{
echo "Please fill up all the required field.";
}
else
{

$fullName = $_POST['fullName'];
$license = $_POST['license'];
$email = $_POST['email'];
$beds = $_POST['beds'];
$address = $_POST['address'];
$password = $_POST['newPassword'];
$hash = password_hash($password, PASSWORD_DEFAULT);

// Make a connection with MySQL server.
include('config.php');

$sQuery = "SELECT id from account where license=? LIMIT 1";
$iQuery = "INSERT Into account (fullName,license,email,beds,address,password) values(?,?,?,?,?,?)";

// To protect MySQL injection for Security purpose
$stmt = $conn->prepare($sQuery);
$stmt->bind_param("s", $license);
$stmt->execute();
$stmt->bind_result($id);
$stmt->store_result();
$rnum = $stmt->num_rows;

if($rnum==0) { //if true, insert new data
          $stmt->close();

          $stmt = $conn->prepare($iQuery);
    	  $stmt->bind_param("sssiss", $fullName,$license,$email,$beds,$address,$hash);
          if($stmt->execute()) {
        echo '<div style="text-align:center;font-size:20px">Register successfully, Please login with your login details</div>';}
        } else {
       echo '<div style="text-align:center;font-size:20px">Someone already register with this license number</div>';
     }
$stmt->close();
$conn->close(); // Closing database Connection
}
}

?>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width,initial-scale=1">
	<title>Register</title>
	<link rel="stylesheet" href="mystyle.css">
</head>
<body>

 <div class="rlform">
  <div class="rlform rlform-wrapper">
   <div class="rlform-box">
	<div class="rlform-box-inner">
	 <form method="post" oninput='validatePassword()'>
	  <p>Let's create your account!</p>

    <div class="rlform-group">
	  <label>Hospital Name</label>
	  <input type="text" name="fullName" class="rlform-input" required>
	 </div>

   <div class="rlform-group">
   <label>Hospital License No</label>
   <input type="text" name="license" class="rlform-input" required>
   </div>


	 <div class="rlform-group">
	  <label>Email</label>
	  <input type="email" name="email" class="rlform-input" required>
	 </div>


   <div class="rlform-group">
	  <label>No. of beds available(Current)</label>
	  <input type="number" id="quantity" name="beds" min="1" class="rlform-input" required>
	 </div>

  <div class="rlform-group">
  <label>Address</label>
  <input type="text" name="address" class="rlform-input" required>
  </div>

	 <div class="rlform-group">
	  <label>Password</label>
	  <input type="password" name="newPassword" id="newPass" class="rlform-input" required>
    </div>

     <div class="rlform-group">
	  <label>Conform password</label>
	  <input type="password" name="conformpassword" id="conformPass" class="rlform-input" required>
     </div>

	  <button class="rlform-btn" name="signUp">Sign Up
	  </button>

	  <div class="text-foot">
	   Already have an account? <a href="login.php">Login</a>
	  </div>
	 </form>
	</div>
   </div>
  </div>
 </div>

	<script>
		function validatePassword(){
  if(newPass.value != conformPass.value) {
    conformPass.setCustomValidity('Passwords do not match.');
  } else {
    conformPass.setCustomValidity('');
  }
}
	</script>
</body>
</html>
