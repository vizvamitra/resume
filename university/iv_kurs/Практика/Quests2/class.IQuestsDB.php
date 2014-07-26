<?php
/**
*	IQuestsDB
*		содержит основные методы для работы с Базой данных
*/
interface IQuestsDB {
	function login($name, $password);	
	function addUser($name,$password,$email,$post);
	function getQuestCount($which);
	function getQuests($which,$page=0, $id=0);
	function addQuest($name,$text,$author);
	function editQuest($questId,$newName,$newTxt,$author);
	function deleteQuest($questID);
	function markDone($questId,$username, $undone=0);
	function getComments($id,$commentId=0);
	function addComment($text, $questId, $author);
	function editComment($commentId,$newTxt,$author);
	function deleteComment($msgId,$author);
}
?>