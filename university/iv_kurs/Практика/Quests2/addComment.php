<?php
	session_start();
	require_once("class.QuestsDB.php");
	
	if ($_SERVER['REQUEST_METHOD']=='POST'){
		$db = QuestsDB::getInstance();
		$db->addComment($_POST['newComment'],$_POST['questId'],$_SESSION['userName']);
	}
	header("Location:index.php?id=comments&msgid=".$_POST['questId']);
?>