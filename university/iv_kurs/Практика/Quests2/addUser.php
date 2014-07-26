<?php
	session_start();
	if ($_SERVER['REQUEST_METHOD']=="POST"){
		$_SESSION['nameError']="";
		$_SESSION['emailError']="";
		require_once("class.QuestsDB.php");
		$db = QuestsDB::getInstance();
		if ($_POST['name'] && $_POST['password'] && $_POST['email']){
			$result = $db->addUser($_POST['name'], $_POST['password'], $_POST['email'], $_POST['post']);
			if (is_array($result)){
				$_SESSION['auth_type']='user';
				$_SESSION['userName']=$result["name"];
				$_SESSION['userID']=$result["id"];
				header("Location:index.php");
				exit;
			}
			else{
				switch ($result){
					case 11:	$_SESSION['nameError']="Логин занят";
					case 1:		$_SESSION['emailError']="Email занят";break;
					case 10:	$_SESSION['nameError']="Логин занят";
				}
				header("Location:index.php?id=register");
				exit;
			}
		}
	}
	header("Location:index.php?id=register");
?>
