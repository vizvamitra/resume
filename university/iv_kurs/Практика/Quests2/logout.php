<?php
	session_start();
	$_SESSION['auth_type']='anonimous';
	$_SESSION['userName']='';
	$_SESSION['userID']='';
	$queryString = "?id={$_POST['id']}";
	if ($_POST['id']){
		$queryString = "?id={$_POST['id']}";
		if ($_POST['msgid'])
			$queryString .= "&msgid={$_POST['msgid']}";
	}
	header("Location:index.php".$queryString);
	exit;
?>