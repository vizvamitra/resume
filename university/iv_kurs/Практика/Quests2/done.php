<style>
	#questsTab{
		height:22px;
		background-color:#cfc;
	}
	#doneTab{
		z-index:3;
		height:30px;
		top:-64px;
		background-color:#efe;
	}
</style>

<?php
	$count = $db->getQuestCount("done");
	if ($_GET['page'] == NULL) $page = 0;
	else $page = $_GET['page']-1;
	$quests = $db->getQuests("done",$page);

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
				<A class='controls' href='index.php?id=comments&msgid=<?=$quest['id']?>'>Комментарии(<?=$quest['count_of_msg']?>)</A> |
				Завершено: <?=date("d:m:Y H:i:s",$quest['donedate'])?> by <B><?=$quest['who_did']?></B>
				<?if ($_SESSION[auth_type]=='user'){?>
					<SPAN class='markDone'><A href='markUndone.php?msgid=<?=$quest['id']?>'>Не&nbspзавершено</A></SPAN>
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