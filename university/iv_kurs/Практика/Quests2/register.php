<?php
	if ($_SESSION['auth_type']=='user')
		header("Location:index.php");
?>
<style>
	#questsTab{
		height:22px;
		background-color:#cfc;
	}
	#doneTab{
		top:-64px;
	}
	#registerTab{
		display:block;
		height:30px;
		top:-128px;
		background-color:#efe;
	}
</style>
<FORM id='registerForm' method="POST" action='addUser.php'>
	<TABLE>
		<TR>
			<TD><SPAN>Имя:</SPAN></TD>
			<TD><INPUT id="enteredLogin" type='text' name='name' size='30' maxlength='30'></TD>
			<TD class='error'><?=$_SESSION['nameError']?></TD>
		</TR>
		<TR>
			<TD><SPAN>Пароль:</SPAN></TD>
			<TD><INPUT id='enteredPassword' type='password' name='password' size="30" maxlength='30'></TD>
			<TD class='error'><?=$_SESSION['passwordError']?></TD>
		</TR>
		<TR>
			<TD><SPAN>Email:</SPAN></TD>
			<TD><INPUT id='enteredEmail' type='text' name='email' size="30"></TD>
			<TD class='error'><?=$_SESSION['emailError']?></TD>
		</TR>
		<TR>
			<TD><SPAN>Должность:</SPAN></TD>
			<TD><INPUT id='enteredPost' type='text' name='post' size="30"></TD>
		</TR>
		<TR>
			<TD></TD>
			<TD><INPUT type='submit' value='Зарегистрироваться'></TD>
			<TD></TD>
		</TR>
	</TABLE>
</FORM>