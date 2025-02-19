<?php

require('APR1_MD5.php');
use WhiteHat101\Crypt\APR1_MD5;
$password = False;
$password_hash = "";

if( isset($_POST['password']) ){
  $password = $_POST['password'];
  $password_hash = APR1_MD5::hash($password);
}

?>
<html>
<head>
<title>Password Hasher</title>
<style>
input {
  width: 100%;
  max-width: 24em;
}
</style>
</head>
<body>
<h1>Password Hash Generator</h1>
<?php if($password_hash != ""){ ?>
  <p>Your password hash is as follows:</p>
  <input type="text" value="<?php echo(htmlspecialchars($password_hash)); ?>">
<?php } else { ?>
  <p>Enter your password to generate a password hash.</p>
  <form method="post" action="/password.php">
    <input type="password" name="password"><br>
    <input type="submit" value="Generate Hash">
  </form>
<?php } ?>
</body>
</html>
