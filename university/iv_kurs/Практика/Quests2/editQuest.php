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
		$quest = $db->getQuests("",0,$_GET['msgid']);
		if ($quest[0]['author']==$_SESSION['userName']){?>
			<FORM class="form" method='POST' action='editQuest.php'>
				<SPAN>Редактирование</SPAN>
				<SPAN>Название:</SPAN>
				<INPUT type='text' name='questName' maxlength='100' value='<?=$quest[0]['name']?>'><BR><BR>
				<TEXTAREA rows='6' name='questText'><?=$quest[0]['start_txt']?></TEXTAREA><BR>
				<INPUT type='submit' value='Сохранить'>
				<INPUT type='hidden' name='msgid' value='<?=$quest[0]['id']?>'>
			</FORM><?
		}
		else
			header("location:index.php?id=quests");
	}
	elseif($_SERVER['REQUEST_METHOD']=='POST'){
		$quest = $db->getQuests("",0,$_POST['msgid']);
		if ($quest[0]['author']==$_SESSION['userName']){
			$db->editQuest($quest[0]['id'],$_POST['questName'],$_POST['questText'],$_SESSION['userName']);
		}
		header("location:index.php?id=quests");
	}
?>