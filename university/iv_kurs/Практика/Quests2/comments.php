<STYLE>
	#questsTab{
		height:22px;
		background-color:#cfc;
	}
	#doneTab{
		top:-64px;
	}
	#commentsTab{
		display:block;
		height:30px;
		top:-128px;
		background-color:#efe;
	}
</STYLE>
<?php
	if ($_GET['msgid']){
		$quest = $db->getQuests("",0,$_GET['msgid']);
		$count=$quest[0]['count_of_msg'];
		if ($_GET['page'] == NULL) $page = 0;
		else $page = $_GET['page']-1;
		$comments = $db->getComments($_GET['msgid'], $page);
?>
		<DIV class='questDIV'>
			<DIV class='questTitle'><?=$quest[0]['name']?></DIV>
			<DIV class='questText'><?=$quest[0]['start_txt']?></DIV>
			<DIV class='questInfo' style='float:none;'>
				Автор: <A href='index.php?id=profile&user=<?=$quest[0]['author']?>'><?=$quest[0]['author']?></A> | 
				Дата: <?=date("d:m:Y H:i:s",$quest[0]['pubdate'])?>
				<?if ($quest[0]['done']==1){
					echo "| Завершено: ".date("d:m:Y H:i:s",$quest[0]['donedate'])." by <B>".$quest[0]['who_did']."</B>";	
				}
				if ($_SESSION[auth_type]=='user'){
					if ($quest[0]['done']==1){?>
						<SPAN class='markDone'><A href='index.php?id=markUndone&msgid=<?=$quest[0]['id']?>'>Не&nbspзавершено</A></SPAN>
					<?} else {?>
						<SPAN class='markDone' ><A href='index.php?id=markDone&msgid=<?=$quest[0]['id']?>'>Завершено</A></SPAN>
					<?}
			}?>
			</DIV>
		</DIV>
		<?if ($_SESSION[auth_type]=='user'){?>
			<FORM class='form' method='POST' action='addComment.php'>
				<SPAN>Новый комментарий</SPAN>
				<TEXTAREA rows='6' name='newComment'></TEXTAREA><BR>
				<INPUT type='submit' value='Добавить'>
				<INPUT type='hidden' name='questId' value='<?=$_GET['msgid']?>'>
			</FORM><?		
		}
		else{?>
			<DIV class='form'>
				<SPAN>Чтобы оставлять комментарии, Вы должны <A href='index.php?id=register'>зарегистрироваться</A></SPAN>
			</DIV><?
		}
		if ($count>10){
			if (intval($_GET['page'])<=ceil($count/10)){?>
				<DIV id='pages'>
					<?for ($i = 1; $i<=ceil($count/10); $i++){
						echo "<A class='pageNum' href='index.php?id=comments&msgid={$quest[0]['id']}&page=$i'>$i</A>";
					}?>
				</DIV><?
			}
		}?>
		<DIV id='comments'><?
		foreach($comments as $comment){?>
			<DIV class='comment'>
				<DIV class='questText'><?=$comment['msg_txt']?></DIV>
				<DIV class='questInfo'>
					Автор: <A href='index.php?id=profile&user=<?=$comment['author']?>'><?=$comment['author']?></A> | 
					Дата: <?=date("d:m:Y H:i:s",$comment['pubdate'])?><?
					if ($_SESSION['auth_type']=='user' && $_SESSION['userName']==$comment['author']){?>
						&nbsp;|&nbsp;
						<A class='controls' href='index.php?id=editComment&msgid=<?=$comment['id']?>'>Редактировать</A> | 
						<A class='controls' href='deleteComment.php?msgid=<?=$comment['id']?>'>Удалить</A><?
					}?>
				</DIV>
			</DIV><?
		}?>
		</DIV><?
		if ($count>10){
			if (intval($_GET['page'])<=ceil($count/10)){?>
				<DIV id='pages'>
					<?for ($i = 1; $i<=ceil($count/10); $i++){
						echo "<A class='pageNum' href='index.php?id=comments&msgid={$quest[0]['id']}&page=$i'>$i</A>";
					}?>
				</DIV><?
			}
		}
	}
?>
	
	