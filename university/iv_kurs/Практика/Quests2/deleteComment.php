<?php
	session_start();
	require_once("class.QuestsDB.php");
	
	if ($_SESSION['auth_type']=='user'){
		$db = QuestsDB::getInstance();
		$questId=$db->deleteComment($_GET['msgid'],$_SESSION['userName']);
	}
	header("Location:index.php?id=comments&msgid=$questId");
?>