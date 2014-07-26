<DIV id="login">
	<?php
		switch($_SESSION['auth_type']){
			case 'anonimous':?>	<FORM id='loginForm' method='POST' action='login.php'">
								<SPAN>Имя:</SPAN>
								<INPUT id="enteredLogin" type='text' name='name' size='10' maxlength='30'>
								<SPAN>Пароль:</SPAN>
								<INPUT id='enteredPassword' type='password' name='password' size="10" maxlength='30'>
								<INPUT type='submit' value='Войти'>
								<INPUT type='hidden' name='id' value='<?=$_GET['id']?>'>
								<INPUT type='hidden' name='msgid' value='<?=$_GET['msgid']?>'>
							</FORM>
							<A href='index.php?id=register'>Регистрация</A><?
							break;
			case 'user':?>
							<FORM method='POST' action='logout.php'>
								<SPAN>Вы вошли как: <A href='index.php?id=profile&userid=<?=$_SESSION['userID']?>'><?=$_SESSION['userName']?></A> | </SPAN>
								<INPUT type='submit' value='Выйти'>
								<INPUT type='hidden' name='id' value='<?=$_GET['id']?>'>
								<INPUT type='hidden' name='msgid' value='<?=$_GET['msgid']?>'>
							</FORM><?
							break;
		}
	?>
</DIV>
<SPAN id="title">Quests beta 0.12</SPAN>
<DIV id='tabs'>
	<A id='questsTab' href='index.php'>Текущие</A>
	<A id='doneTab' href='index.php?id=done'>Завершенные</A>
	<A id='commentsTab' href='#'>Комментарии</A>
	<A id='editTab' href='#'>Редактирование</A>
	<A id='registerTab' href='#'>Регистрация</A>
</DIV>