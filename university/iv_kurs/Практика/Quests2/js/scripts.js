$(document).ready(function(){
	$("#newQuest").click(openForm);
	$("#minus").click(closeForm);
})

function openForm(){
	$("#newQuest").css({"cursor":"auto"}).animate({"height":"190px"}, 400);
	$("#minus").css({"display":"block"});
}

function closeForm(){
	$("#newQuest").css({"cursor":"pointer"}).animate({"height":"0px"}, 400);
	$("#minus").css({"display":"none"});
	return false;
}