<?php
require("class.IQuestsDB.php");
	
class QuestsDB implements IQuestsDB {
	const DB_HOST = "localhost";
	const DB_LOGIN = "oldborn";
	const DB_PASSWORD = "********";
	const DB_NAME = "oldborn_quests";
	private static $_instance;
	private $_conn;
	
	private function __construct(){}
	private function __clone(){}
	private function __wakeup(){}
	
	public static function getInstance(){
		if (self::$_instance === null) {
			self::$_instance = new self;   
		}
		return self::$_instance;
	}
	
	private function clearData($data, $type="s"){
		switch($type){
			case "s":	return "'".mysql_real_escape_string(trim(strip_tags($data)))."'";
			case "i":	return intval($data);
			case "ui":	$data = intval($data);
						if ($data<0) $data=-$data;
						return $data;
			case "sf":	return "'".trim(strip_tags($data))."'";
			case "stext":return "'".trim(strip_tags($data, '<b><a><u><pre><i><tt><s>'))."'";
		}
	}
	
	private function db2Array($data){
		$arr = array();
		while ($row = mysql_fetch_assoc($data))
			$arr[] = $row;
		return $arr;
	}
	
	private function connectDb(){
		$_conn = mysql_connect(self::DB_HOST,self::DB_LOGIN,self::DB_PASSWORD);
		mysql_select_db(self::DB_NAME);
		$sql = "SET NAMES utf8";
		mysql_query($sql) or die(mysql_error());
		$sql = "SET CHARACTER SET utf8";
		mysql_query($sql) or die(mysql_error());
		return $_conn;
	}
	
	function login($name, $password){
		$_conn = $this->connectDb();
		$name = $this->clearData($name);
		$password = sha1( md5( md5($password . sha1($name)) ) );
		$sql = "SELECT id, name
				FROM users
				WHERE name = $name
				AND password = '$password'
				";
		$result = mysql_query($sql) or die(mysql_error());
		mysql_close($_conn);
		$user = array();
		$user = mysql_fetch_assoc($result);
		return $user;
	}
	
	function addUser($name,$password,$email,$post){
		$i = 0;
		$_conn = $this->connectDb();
		$name = $this->clearData($name);
		$email = $this->clearData($email);
		$post = $this->clearData($post);
		$password = "'".sha1( md5( md5($password . sha1($name)) ) )."'";
		$sql = "SELECT name, email FROM users
				WHERE name = $name
				OR email = $email";
		$result=mysql_query($sql) or die(mysql_error());
		$result=$this->db2array($result);
		foreach($result as $user){
			if ("'".strtoupper($user['name'])."'"==strtoupper($name))
				$i+=10;
			if ("'".strtoupper($user['email'])."'"==strtoupper($email))
				$i+=1;
		}
		if ($i!=0){
			mysql_close($_conn);
			return $i;
		}
		else{
			$sql = "INSERT INTO users (name, password, email, post, regdate)
					VALUES ($name,$password,$email,$post,".time().")";
			mysql_query($sql) or die(mysql_error());
			$sql = "SELECT id, name FROM users WHERE name = $name";
			$result = mysql_query($sql) or die(mysql_error());
			$result = mysql_fetch_assoc($result);
		}
		mysql_close($_conn);
		return $result;
	}

	function getQuestCount($which){
		$_conn = $this->connectDb();
		$sql = "SELECT count(*) FROM quests";
		switch($which){
			case "actual": $sql .= " WHERE done=0"; break;
			case "done": $sql .= " WHERE done=1"; break;
			case "all": break;
			default: die("Error useing getQuestCount: wrong argument.\n");
		}
		$result = mysql_query($sql) or die(mysql_error());
		mysql_close($_conn);
		$result = $this->db2array($result);
		return intval($result[0]['count(*)']);
	}
	
	function getQuests($which, $page=0, $id=0){
		$_conn = $this->connectDb();
		$id = $this->clearData($id,'i');
		$page = $this->clearData($page,'ui');
		$sql = "SELECT id, name, start_txt, author, pubdate, count_of_msg, done, donedate, who_did FROM quests";
		if ($id)
			$sql .= " WHERE id = $id";
		else {
			switch($which){
				case "actual": $sql .= " WHERE done = 0"; break;
				case "done": $sql .= " WHERE done = 1"; break;
				case "all": break;
				default: die("Error using getQuests: 1st argument is wrong.\n");
			}
		}
		$sql .= " ORDER BY ";
		switch($which){
			case "done": $sql .= "donedate"; break;
			default: $sql .= "pubdate"; break;
		}
		$sql .= " DESC LIMIT ".($page*10).", ".(10+$page*10);
		$result = mysql_query($sql) or die(mysql_error());
		mysql_close($_conn);
		return $this->db2array($result);
	}
	
	function addQuest($name,$text,$author){
		$_conn = $this->connectDb();
		$name = $this->clearData($name,'stext');
		if ($name=='')
			$name="'Без названия'";
		$text = $this->clearData($text,'stext');
		$sql = "INSERT INTO quests (name, start_txt, author, pubdate)
				VALUES ($name, $text, '".$author."', ".time().")";
		mysql_query($sql) or die(mysql_error());
		mysql_close($_conn);
	}
	
	function editQuest($questId,$newName,$newTxt,$author){
		$_conn = $this->connectDb();
		$questId = $this->clearData($questId,'i');
		$sql = "SELECT id, author FROM quests
				WHERE id=$questId";
		$result=mysql_query($sql) or die(mysql_error());
		$result=mysql_fetch_assoc($result);
		if ($result['author']==$author){
			$newName = $this->clearData($newName,'sf');
			$newTxt = $this->clearData($newTxt,'stext');
			$sql = "UPDATE quests
					SET name=$newName,
						start_txt=$newTxt
					WHERE id=$questId";
			mysql_query($sql) or die(mysql_error());
		}
		mysql_close($_conn);
	}
	
	function deleteQuest($questId){
		$_conn = $this->connectDb();
		$questId = $this->clearData($questId,'i');
		$sql = "DELETE FROM messages
				WHERE quest_id=$questId";
		mysql_query($sql) or die(mysql_error());
		$sql = "DELETE FROM quests
				WHERE id=$questId";
		mysql_query($sql) or die(mysql_error());
		mysql_close($_conn);
	}
	
	function markDone($questId, $username, $undone=0){
		$_conn = $this->connectDb();
		$questId = $this->clearData($questId,'i');
		$username = $this->clearData($username);
		$sql = "SELECT id, done FROM quests
				WHERE id=$questId";
		$result=mysql_query($sql) or die(mysql_error());
		$result=mysql_fetch_assoc($result);
		switch($undone){
			case 0: if (!$result || $result['done']==1) return -1;
					$sql = "UPDATE quests
							SET done=1,
								who_did=$username,
								donedate=".time()."
							WHERE id=$questId";
					break;
			case 1: if (!$result || $result['done']==0) return -1;
					$sql = "UPDATE quests
							SET done=0,
								who_did=0,
								donedate=0
							WHERE id=$questId";
		}
		$result=mysql_query($sql) or die(mysql_error());
		return 0;
	}
	
	function getComments($id, $page=0, $commentId=0){
		$_conn = $this->connectDb();
		$id = $this->clearData($id,"i");
		$commentId = $this->clearData($commentId,"i");
		$sql = "SELECT id, msg_txt, author, pubdate, quest_id
					FROM messages";
		if ($id!=0)
			$sql .= " WHERE quest_id = $id";
		elseif ($commentId!=0)
			$sql .= " WHERE id = $commentId";
		$sql .= " LIMIT ".($page*10).", ".(10+$page*10);
		$result = mysql_query($sql) or die(mysql_error());
		mysql_close($_conn);
		return $this->db2array($result);
	}
	
	function addComment($text, $questId, $author){
		$_conn = $this->connectDb();
		$text = $this->clearData($text,'stext');
		$questId = $this->clearData($questId,'i');
		$sql = "INSERT INTO messages (msg_txt, quest_id, author, pubdate)
				VALUES ($text, $questId, '".$author."', ".time().")";
		$result = mysql_query($sql) or die(mysql_error());
		$sql = "UPDATE quests
				SET count_of_msg = count_of_msg+1
				WHERE id = $questId";
		$result = mysql_query($sql) or die(mysql_error());
		mysql_close($_conn);
	}
	
	function editComment($commentId,$newTxt,$author){
		$_conn = $this->connectDb();
		$commentId = $this->clearData($commentId,'i');
		$sql = "SELECT id, author FROM messages
				WHERE id=$commentId";
		$result=mysql_query($sql) or die(mysql_error());
		$result=mysql_fetch_assoc($result);
		if ($result['author']==$author){
			$newTxt = $this->clearData($newTxt,'stext');
			$sql = "UPDATE messages
					SET msg_txt=$newTxt
					WHERE id=$commentId";
			mysql_query($sql) or die(mysql_error());
		}
		mysql_close($_conn);
	}
	
	function deleteComment($msgId,$author){
		$_conn = $this->connectDb();
		$msgId = $this->clearData($msgId,'i');
		$sql = "SELECT author, quest_id
				FROM messages
				WHERE id=$msgId";
		$result=mysql_query($sql) or die(mysql_error());
		$result=mysql_fetch_assoc($result);
		if ($result['author']==$author){
			$sql = "DELETE FROM messages
					WHERE id = $msgId";
			mysql_query($sql) or die(mysql_error());
			$sql = "UPDATE quests
				SET count_of_msg = count_of_msg-1
				WHERE id = ".$result['quest_id'];
			mysql_query($sql) or die(mysql_error());
		}
		mysql_close($_conn);
		return $result['quest_id'];
	}
	
}
?>