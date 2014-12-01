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
	
	.panel-chat {
		margin-top:100px;
		min-height:600px;
		display:none;
	}
	.panel-footer{
		z-index:9999;
	}
	.btn-send {
		height:54px;
	}
	#chat_content2 {
		margin: 0;
		padding: 0;
		list-style: none;
		overflow-y:auto;
	    overflow-x:hidden;
	    height:457px;
	}
	.main_div {
		background-color: #eee;
	}
	.sessionTime {
		font-size:10px;
		text-align:center;
	}
	
	.guestSession {
		float: left; /* float containment */
		max-width: 280px;
		margin: 0 0 20px 0;
	}
	.ownerSession {
		float: right; 
		max-width: 280px;
		margin: 0 0 20px 0;
	}
	.clear{
		clear:both;
	} 
	.guest {
		float: left;
		width: 50px;
		font-size: 84%;
		text-align: right;
		/*padding-top:4px;*/
	}
	.owner {
		float: right;
		width: 50px;
		font-size: 84%;
		text-align: right;
		/*padding-top:4px;*/
	}
	.left {
		position: relative;
		min-height: 18px;
		margin: 0 0 0 60px;
		padding: 1px 10px 1px 10px;
		-moz-border-radius: 8px;
		-webkit-border-radius: 8px;
		border-radius: 8px;
		background-color: #fff;
		word-wrap: break-word;
	}
	.left:before {
		content: "\00a0";
		display: block;
		position: absolute;
		top: 6px;
		left: -6px;
		width: 0;
		height: 0;
		border-width: 6px 6px 6px 0;
		border-style: solid;
		border-color: transparent #fff transparent transparent;
	}
	.right {
		position: relative;
		min-height: 18px;
		margin: 0 60px 0 0;
		padding: 1px 10px 1px 10px;
		-moz-border-radius: 8px;
		-webkit-border-radius: 8px;
		border-radius: 8px;
		background-color: #A6DADC;
		word-wrap: break-word;
	}
	.right:before {
		content: "\00a0";
		display: block;
		position: absolute;
		top: 6px;
		right: -6px;
		width: 0;
		height: 0;
		border-width: 6px 0 6px 6px;
		border-style: solid;
		border-color: transparent transparent transparent #A6DADC;
	}
</style>

<script src="html/js/jquery-2.1.1.js" type="text/javascript"></script>
<script src="html/js/bootstrap.min.js" type="text/javascript"></script>
<script type="text/javascript" src="html/js/ajax-pushlet-client.js"></script>
<script type="text/javascript" src="html/js/util.js"></script>
<script type="text/javascript" src="html/js/hashmap.js"></script>
<script type="text/javascript">
	function joinChat() {
		p_subscribe('/chat', "");
		p_publish('/chat', 'action', 'enter', 'userUuid', myUuid, "userName", myName);
	}
	
	function onNack(event) {
		alert('negative response from server: ' + event.getEvent()
				+ ' reason: ' + event.get('p_reason'));
	}
	// Event Callback: display all events
	// fetch sessionId of myself
	function onJoinListenAck(event) {
		p_id = event.get("p_id");
		p_publish('/queryOnline', 'userUuid', myUuid);
	}
	
	function onData(event) {
		//console.log(event);
		//console.log(p_id);
		p_debug(false, "pushlet-app", 'event received event='
				+ event.getEvent());
		var action = event.get('action');
		var content = "";
		if (action == 'send') {
			var fromName = event.get('from');
			var message = event.get('msg');
			handleComeMsg(fromName, message);
		} else if (action == 'enter') {
			var enter_uuid = event.get("userUuid");
			var enter_name = event.get("userName");
			
			if (enter_uuid != myUuid) {
				addOnlineUser(enter_uuid, enter_name);
			}
		} else if (action == 'exit') {
			var exit_uuid = event.get("userUuid");
			var exit_name = event.get("userName");
			
			if (exit_uuid != myUuid) {
				removeOfflineUser(exit_uuid, exit_name);
			}
		} else if (action == 'online') {
			var onlinePersonList = event.get("onlinePersonList");
			//更新在线列表
			updateUserListPanel(onlinePersonList);
			p_unsubscribe(event.get("p_sid"));
			//服务器返回在线列表，此时加入聊天
			joinChat();
		}
		

	}
	//更新在线列表
	function updateUserListPanel(onlinePersonList) {
		$("#userListPanel").html("");
		var person_list = JSON.parse(onlinePersonList); //由JSON字符串转换为JSON对象
		for(var index in person_list) {
			var person = person_list[index];
			//console.log(person);
			var userUuid2 = person.userUuid;
			var userName2 = person.userName;
			if (userUuid2 == "" || userName2 == myName) {
				continue;
			}
			var person_html = $('<a id="'+ userUuid2 +'" class="list-group-item" onclick="chatTo(event)">'+ userName2 +'</a>');
			$("#userListPanel").append(person_html);
			p_map.put(userName2, userUuid2);
		}
	}
	function addOnlineUser(enter_uuid, enter_name) {
		if (p_map.keySet().indexOf(enter_name) == -1) {
			var person_html = $('<a id="'+ enter_uuid + '" class="list-group-item" onclick="chatTo(event)">'+ enter_name +'</a>');
			$("#userListPanel").append(person_html);
			p_map.put(enter_name, enter_uuid);
		}
	}
	//somebody offline
	function removeOfflineUser(exit_uuid, exit_name) {
		$("#userListPanel").find("#" + exit_uuid).remove();
		p_map.remove(exit_name);
	}
	
	function chatTo(event){
		var toUserUuid = event.target.id;
		var toUserName = event.target.innerHTML;
		$(".panel-chat").css("display", "block");
		$(".toUserName").html(toUserName);
		$(".toUserName").attr("id", toUserUuid);
		
	}
	function closeChatDialog() {
		$(".panel-chat").css("display", "none");
	}
	
	function sendMsg(event){
		var toUserUuid = $(".toUserName").attr("id");
		p_publish('/chat', 'action', 'send', 'from', myName, 'p_to', toUserUuid, 'msg', document.getElementById("msgContent").value);//todo
		//add my talk to chat panel
		var msg_go = '<li class="ownerSession clear" data-user="{to_user}">\
								<div class="sessionTime">{time}</div>\
							  	<div class="owner">\
							      	<img src="{own_head}" width="50" height="50" alt="">\
							  	</div>\
							    <blockquote class="right">\
							      <p>{msg}</p>\
							    </blockquote>\
							</li>';
		var data_after = {"time":"2014", "to_user":toUserUuid ,"msg":document.getElementById("msgContent").value, "own_head":"html/images/cat_uncle_small.jpg"};
		var msg_go_after = substitute(msg_go, data_after);
		var $ownerSession = $(msg_go_after);
		$("#chat_content2").append($ownerSession);
		$('#chat_content2').stop().animate({
			  scrollTop: $("#chat_content2")[0].scrollHeight
			}, 800);
		
		$("#msgContent").val("");
		$("#msgContent").focus();
	}
	
	/**
	 * 替换字符串中的字段.
	 * @param {String} str 模版字符串
	 * @param {Object} o json data
	 * @param {RegExp} [regexp] 匹配字符串的正则表达式
	 */
	function substitute(str,o,regexp){
		return  str.replace(regexp || /\\?\{([^{}]+)\}/g, function (match, name) {
	    return (o[name] === undefined) ? '' : o[name];
	  });
	}
	
	//显示来得消息todo
	function handleComeMsg(fromName, message) {
		if ($(".panel-chat").css("display") == "block" && fromName == $(".toUserName").html()) {
			var msg_come = '<li class="guestSession clear" data-user="{msg_from}">\
				<div class="sessionTime">{time}</div>\
			  	<div class="guest">\
			      	<img src="{guest_head}" width="50" height="50" alt="">\
			  	</div>\
			    <blockquote class="left">\
			      <p>{msg}</p>\
			    </blockquote>\
			</li>';
			var data_after = {"time":"2014-12-01", "msg_from":fromName,"msg":message, "guest_head":"html/images/asha.jpg"};
			var msg_come_after = substitute(msg_come, data_after);
			var $guestSession = $(msg_come_after);
			$("#chat_content2").append($guestSession);
			$('#chat_content2').stop().animate({
				  scrollTop: $("#chat_content2")[0].scrollHeight
				}, 800);
		} else {
			//将消息显示为通知，因为消息来源不是当前聊天用户todo
		}
	}
	//js开始执行的地方
	//var nick=getPageParameter('nick', 'anon');
	var p_id = "";
	var p_map = new Map();
	var myUuid = "";
	var myName = "";
	$(document).ready(function(){
		myUuid = $("#userUuid").text();
		myName = $("#userName").text();
		
		p_join_listen('/queryOnline');
		
		
		//绑定beforeunload事件
		$(window).bind('beforeunload',function(){
			//return '您已经登录，确定注销并离开此页面吗？';
			p_publish('/chat', 'action', 'exit', 'userUuid', myUuid, "userName", myName);
		}); 
		
	});
</script>
</head>
<body>
  <div id="userName" style="display:none;"><%=session.getAttribute("userName")%></div>
  <div id="userUuid" style="display:none;"><%=session.getAttribute("userUuid")%></div>

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
  	  <div class="col-lg-9">
  	  	<div class="panel panel-default panel-chat">
  	  		<div class="panel-heading">
  	  		  <span id="none" class="label label-danger toUserName" style="font-size:15px;"><strong>xxx</strong></span>
  	  		  <button type="button" class="close" onclick="closeChatDialog()">
  	  		    <span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
  	  		  </button>
  	  		</div>
  	  		<div class="panel-body main_div">
  	  		  <ol id="chat_content2">
		      </ol>
  	  		</div>
  	  		<div class="panel-footer">
  	  		  <div class="input-group">
      			<textarea id="msgContent" class="form-control"></textarea>
			    <span class="input-group-btn">
			      <button class="btn btn-default btn-send" type="button" onclick="sendMsg(event)">Send</button>
			    </span>
    		  </div>
  	  		</div>
  	  	</div>
  	  </div>
  	</div>
  </div>
</body>
</html>