<?php
	session_start();
	if (!$_SESSION['auth_type'])
		$_SESSION['auth_type']="anonimous";
	require_once("class.QuestsDB.php");
	$db = QuestsDB::getInstance();
?>
<!DOCTYPE HTML>
<HTML>
<HEAD>
	<META CHARSET="utf-8"/>
	<LINK rel="stylesheet" type="text/css" href="css/styles.css"/>
	<SCRIPT type="text/javascript" src="js/jquery-1.9.1.min.js"></SCRIPT>
	<SCRIPT type="text/javascript" src="js/scripts.js"></SCRIPT>
	<TITLE>Quest beta 0.12</TITLE>
</HEAD>


<BODY>
	<DIV id="header">
		<?php
			include("inc.header.php");
		?>
	</DIV>
	<DIV id="main">
		<?php
			include("inc.mainarea.php");
		?>
	</DIV>
</BODY>
</HTML>