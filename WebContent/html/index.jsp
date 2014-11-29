<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Welcome to chat world</title>
<link rel="stylesheet" href="html/css/bootstrap.min.css" >
<link rel="stylesheet" href="html/css/bootstrap-theme.min.css" >
<link rel="stylesheet" href="html/css/font-awesome.css" > 
<link rel="stylesheet" href="html/css/style.css" >
<style type="text/css">
	.panel-contact {
		margin-top:100px;
		min-height:600px;
	}
</style>

<script src="html/js/jquery-2.1.1.js" type="text/javascript"></script>
<script src="html/js/bootstrap.min.js" type="text/javascript"></script>
<script type="text/javascript" src="html/js/ajax-pushlet-client.js"></script>
<script type="text/javascript" src="html/js/util.js"></script>
<script type="text/javascript" src="html/js/hashmap.js"></script>
<script type="text/javascript">
	function joinChat(userUuid) {
		p_subscribe('/chat', "");
		p_publish('/chat', 'action', 'enter', 'userUuid', userUuid);
	}
	
	function onNack(event) {
		alert('negative response from server: ' + event.getEvent()
				+ ' reason: ' + event.get('p_reason'));
	}
	// Event Callback: display all events
	// fetch sessionId of myself
	function onJoinListenAck(event) {
		p_id = event.get("p_id");
		p_map.put(p_id, userUuid);
		p_publish('/queryOnline', 'to', p_id, 'userUuid', userUuid);
	}
	
	function onData(event) {
		//console.log(event);
		//console.log(p_id);
		p_debug(false, "pushlet-app", 'event received event='
				+ event.getEvent());
		var action = event.get('action');
		var content = "";
		if (action == 'send') {
			content = '<b>' + event.get('userUuid') + '</b>: <i>'
					+ event.get('msg') + '</i>';
		} else if (action == 'enter') {
			var enter_id = event.get("p_id");
			var enter_name = p_map.get(enter_id);
			if (enter_name != userUuid) {
				content = '<b><i>*** ' + event.get('userUuid') + ' joined chat  ***</i></b>';
			}
		} else if (action == 'exit') {
			content = '<b><i>*** ' + event.get('userUuid')
					+ ' left chat  ***</i></b>';
		} else if (action == 'online') {
			var onlinePersonList = event.get("onlinePersonList");
			//更新在线列表
			updateUserListPanel(onlinePersonList);
			p_unsubscribe(event.get("p_sid"));
			//服务器返回在线列表，此时加入聊天
			//joinChat(userUuid);
		}
		appendMessage(content);

	}
	//更新在线列表
	function updateUserListPanel(onlinePersonList) {
		$("#userListPanel").html("");
		var person_list = JSON.parse(onlinePersonList); //由JSON字符串转换为JSON对象
		for(var index in person_list) {
			var person = person_list[index];
			console.log(person);
			var userUuid2 = person.userUuid;
			var userName2 = person.userName;
			if (userUuid2 == "" || userName2 == myName) {
				continue;
			}
			var person_html = $('<a href="#" class="list-group-item">'+ userName2 +'</a>');
			$("#userListPanel").append(person_html);
		}
	}
	function appendMessage(content) {
		var newDiv = document.createElement("DIV");
		newDiv.innerHTML = content;
		document.getElementById("contents").appendChild(newDiv);
	}
	//js开始执行的地方
	//var nick=getPageParameter('nick', 'anon');
	var p_id = "";
	var p_map = new Map();
	var userUuid = "";
	var myName = "";
	$(document).ready(function(){
		userUuid = $("#userUuid").text();
		myName = $("#userName").text();
		p_join_listen('/queryOnline');
	});
</script>
</head>
<body>
  <div id="userName" style="display:none;"><%=session.getAttribute("userName")%></div>
  <div id="userUuid" style="display:none;"><%=session.getAttribute("userUuid")%></div>
  
  <div id="contents"></div>
  <div class="container">
  	<div class="row">
  	  <div class="col-lg-3">
  	  	<div class="panel panel-default panel-contact">
  	  	  <div class="panel-heading"><span class="label label-danger" style="font-size:15px;"><strong>contacts</strong></span></div>
  	  	  <div class="panel-body">
  	  	  	<div class="list-group" id="userListPanel">
  	  	  	  <a href="#" class="list-group-item">tom</a>
	          <a href="#" class="list-group-item">jack</a>
	          <a href="#" class="list-group-item">helen</a>
	          <a href="#" class="list-group-item">bob</a>
  	  	  	</div>
  	  	  </div>
  	  	</div>
  	  </div>
  	</div>
  </div>
</body>
</html>