<?php
	session_start();
	require_once("class.QuestsDB.php");

	if ($_SERVER['REQUEST_METHOD']=='POST'){
		$db = QuestsDB::getInstance();
		$db->addQuest($_POST['questName'],$_POST['questText'],$_SESSION['userName']);
	}
	header("Location:index.php?id=quests");
?>