<?php
	session_start();
	require_once("class.QuestsDB.php");
	$db = QuestsDB::getInstance();
	$quest = $db->getQuests("",0,$_GET['msgid']);
	
	if ($quest[0]['author']==$_SESSION['userName']){
		$db->deleteQuest($_GET['msgid']);
	}
	header("location:index.php");
?>