<?php
// Создание структуры Базы Данных трекера задач

define("DB_HOST", "localhost");
define("DB_LOGIN", "oldborn");
define("DB_PASSWORD", "********");
define("DB_NAME", "oldborn_quests");

mysql_connect(DB_HOST, DB_LOGIN, DB_PASSWORD) or die(mysql_error());
mysql_query("CREATE DATABASE ".DB_NAME);
mysql_select_db(DB_NAME) or die(mysql_error());

$sql = "
CREATE TABLE quests (
	id int(11) NOT NULL auto_increment,
	name varchar(33) NOT NULL default '',
	start_txt text,
	author varchar(30),
	pubdate int(11) NOT NULL default 0,
	count_of_msg int(11) NOT NULL default 0,
	done int(1) NOT NULL default 0,
	who_did varchar(30),
	donedate int(11) NOT NULL default 0,
	PRIMARY KEY (id)
)";
mysql_query($sql) or die(mysql_error());

$sql = "
CREATE TABLE messages (
	id int(11) NOT NULL auto_increment,
	msg_txt text,
	quest_id int(11),
	author varchar(30),
	pubdate int(11) NOT NULL default 0,
	PRIMARY KEY (id)
)";
mysql_query($sql) or die(mysql_error());

$sql = "
CREATE TABLE users (
	id int(11) NOT NULL auto_increment,
	name varchar(30) NOT NULL default '',
	password varchar(40) NOT NULL default '',
	email text,
	post text,
	regdate int(11) NOT NULL default 0,
	PRIMARY KEY (id)
)";
mysql_query($sql) or die(mysql_error());

mysql_close();

print '<p>Структура базы данных успешно создана!</p>';
?>