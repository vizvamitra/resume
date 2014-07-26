<STYLE>
	#questsTab{
		height:22px;
		background-color:#cfc;
	}
	#doneTab{
		top:-64px;
	}
	#editTab{
		display:block;
		height:30px;
		top:-128px;
		background-color:#efe;
	}
</STYLE>
<?php
	session_start();
	require_once("class.QuestsDB.php");
	$db = QuestsDB::getInstance();
	
	if ($_SERVER['REQUEST_METHOD']=='GET'){
		$comment = $db->getComments(0,0,$_GET['msgid']);
		if ($comment[0]['author']==$_SESSION['userName']){
			if ($_SERVER['REQUEST_METHOD']=='GET'){?>
				<FORM class="form" method='POST' action='editComment.php'>
					<SPAN>Редактирование</SPAN>
					<TEXTAREA rows='6' name='commentText'><?=$comment[0]['msg_txt']?></TEXTAREA><BR>
					<INPUT type='submit' value='Сохранить'>
					<INPUT type='hidden' name='msgid' value='<?=$comment[0]['id']?>'>
				</FORM><?
			}
		}
		else
			header("location:index.php?id=quests");
	}
	elseif($_SERVER['REQUEST_METHOD']=='POST'){
		$comment = $db->getComments(0,$_POST['msgid']);
		if ($comment[0]['author']==$_SESSION['userName']){
			$result = $db->editComment($comment[0]['id'],$_POST['commentText'],$_SESSION['userName']);
		}
		header("location:index.php?id=comments&msgid=".$comment[0]['quest_id']);
	}
?>