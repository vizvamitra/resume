<?php
	$count = $db->getQuestCount("actual");
	if ($_GET['page'] == NULL) $page = 0;
	else $page = $_GET['page']-1;
	$quests = $db->getQuests("actual",$page);
?>
<?	if ($_SESSION['auth_type']=='user'){?>
		<FORM class='form' id='newQuest' method='POST' action='addQuest.php'>
			<SPAN>Новое задание</SPAN>
			<SPAN id='minus'>-</SPAN>
			<SPAN>Название:</SPAN>
			<INPUT type='text' name='questName' maxlength='33'>
			<TEXTAREA rows='6' name='questText'></TEXTAREA>
			<INPUT type='submit' value='Добавить'>
		</FORM><?		
	}
	if ($count>10){
		if (intval($_GET['page'])<=ceil($count/10)){?>
			<DIV id='pages'>
				<?for ($i = 1; $i<=ceil($count/10); $i++){
					echo "<A class='pageNum'";
					if ($i == $_GET['page'] || (!$_GET['page'] && $i == 1))
						echo " style='background-color:#efe'";
					echo " href='index.php?id=quests&page=$i'>$i</A>";
				}?>
			</DIV><?
		}
	}

	foreach ($quests as $quest){?>
		<DIV class='questDIV'>
			<DIV class='questTitle'><?=$quest['name']?></DIV>
			<DIV class='questText'><?=$quest['start_txt']?></DIV>
			<DIV class='questInfo'>
				Автор: <A href='index.php?id=profile&user=<?=$quest['author']?>'><?=$quest['author']?></A> | 
				Дата: <?=date("d:m:Y H:i:s",$quest['pubdate'])?> |
				<A class='controls' href='index.php?id=comments&msgid=<?=$quest['id']?>'>Комментарии(<?=$quest['count_of_msg']?>)</A><?
				if ($quest['author']==$_SESSION['userName']){?>
					|&nbsp;<A class='controls' href='index.php?id=editQuest&msgid=<?=$quest['id']?>'>Редактировать</A>
					|&nbsp;<A class='controls' href='deleteQuest.php?msgid=<?=$quest['id']?>'>Удалить</A><?
				}?>
				<?if ($_SESSION[auth_type]=='user'){?>
					<SPAN class='markDone' ><A href='markDone.php?msgid=<?=$quest['id']?>'>Завершено</A></SPAN>
				<?}?>
			</DIV>
		</DIV>
<?	}

	if ($count>10){
		if (intval($_GET['page'])<=ceil($count/10)){?>
			<DIV id='pages'>
				<?for ($i = 1; $i<=ceil($count/10); $i++){
					echo "<A class='pageNum'";
					if ($i == $_GET['page'] || (!$_GET['page'] && $i == 1))
						echo " style='background-color:#efe'";
					echo " href='index.php?id=quests&page=$i'>$i</A>";
				}?>
			</DIV><?
		}
	}
?>
		
	