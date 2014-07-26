<?php
	session_start();
	require_once("class.QuestsDB.php");
	$db = QuestsDB::getInstance();
	
	if($_SERVER['REQUEST_METHOD']=='GET' && $_SESSION['auth_type'] == 'user'){
		$db->markDone($_GET['msgid'],$_SESSION['userName']);
	}
	header("location:index.php?id=quests");
?>