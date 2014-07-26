<?php
	session_start();
	require_once("class.QuestsDB.php");
	$db = QuestsDB::getInstance();	
	
	if ($_SERVER['REQUEST_METHOD']=="POST"){
		if ($_POST['name'] && $_POST['password']){
			$user = $db->login($_POST['name'], $_POST['password']);
			if ($user["name"] && $user["id"]){
				$_SESSION['auth_type']='user';
				$_SESSION['userName']=$user["name"];
				$_SESSION['userID']=$user["id"];
			}
		}
		if ($_POST['id'] && $_POST['id']!="register"){
			$queryString = "?id={$_POST['id']}";
			if ($_POST['msgid'])
				$queryString .= "&msgid={$_POST['msgid']}";
		}
		header("Location:index.php".$queryString);
		exit;
	}
?>