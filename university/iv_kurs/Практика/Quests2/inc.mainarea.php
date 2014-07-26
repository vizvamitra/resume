<?php
	$id = strip_tags($_GET['id']);
	if ($id!='register'){
		$_SESSION['nameError']='';
		$_SESSION['passwordError']='';
		$_SESSION['emailError']='';
	}
	switch ($id){
		case 'done':			include "done.php";break;
		case 'register':		include "register.php";break;
		case 'profile':			include "profile.php";break;
		case 'comments':		include "comments.php";break;
		case 'editQuest':		include "editQuest.php";break;
		case 'editComment':		include "editComment.php";break;
		default: 				include "quests.php";
	}
?>