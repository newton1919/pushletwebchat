package com.yxy.extend;

import java.util.Map.Entry;
import java.util.concurrent.ConcurrentHashMap;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.yxy.dao.UserDao;
import com.yxy.mo.UserMO;

import nl.justobjects.pushlet.core.Command;
import nl.justobjects.pushlet.core.Controller;
import nl.justobjects.pushlet.core.Dispatcher;
import nl.justobjects.pushlet.core.Event;
import nl.justobjects.pushlet.core.Protocol;
import nl.justobjects.pushlet.core.Session;
import nl.justobjects.pushlet.core.SessionManager;

public class ControllerExtend extends Controller{
	/**
	 * Handle Publish request.
	 * 我们需要定制该方法，当subject为/queryOnline时，我们需要额外做些工作，将p_id和userUuid建立联系
	 */
	protected void doPublish(Command aCommand) {
		Event responseEvent = null;
		String p_id = aCommand.reqEvent.getField(P_ID);
		try {
			String subject = aCommand.reqEvent.getField(Protocol.P_SUBJECT);
			if (subject == null) {
				// Return error response
				responseEvent = new Event(E_NACK);
				responseEvent.setField(P_ID, p_id);
				responseEvent.setField(P_REASON, "no subject provided");
			} else {
				aCommand.reqEvent.setField(P_FROM, p_id);
				aCommand.reqEvent.setField(P_EVENT, E_DATA);
				
				//处理额外的逻辑userUuid 和 p_id对应
				if ( subject.equals("/queryOnline")) {
					String userUuid = aCommand.reqEvent.getField("userUuid");
					//UserDao userDao = new UserDao();
					//userDao.updateUserWithpushSessionId(userUuid, p_id);
					ConcurrentHashMap<String, String> userSessionMap = UserSession.getInstance().userWithPushletSession;
					userSessionMap.put(userUuid, p_id);
					//发送当前用户列表给client
					Event onlineevent = pullEvent();
					Dispatcher.getInstance().unicast(onlineevent, p_id);
				} 
				//end
				
				// Event may be targeted to specific user (p_to field)
				String to = aCommand.reqEvent.getField(P_TO);
				if (to != null) {
					//如果是特定的聊天应用，to实际是指userUuid,所以要转换成p_id,由后端动态判断
					if (subject.equals("/chat") && aCommand.reqEvent.getField("action").equals("send")) {
						//UserDao userDao = new UserDao();
						//to = userDao.findUserbyId(to).getPushSessionId();
						ConcurrentHashMap<String, String> userSessionMap = UserSession.getInstance().userWithPushletSession;
						to = userSessionMap.get(to);
					}
					Dispatcher.getInstance().unicast(aCommand.reqEvent, to);
				} else {
					// No to: multicast
					debug("doPublish() event=" + aCommand.reqEvent);
					Dispatcher.getInstance().multicast(aCommand.reqEvent);
				}

				// Acknowledge
				responseEvent = new Event(E_PUBLISH_ACK);
			}

		} catch (Throwable t) {
			responseEvent = new Event(E_NACK);
			responseEvent.setField(P_ID, p_id);
			responseEvent.setField(P_REASON, "unexpected error: " + t);
			warn("doPublish() error: " + t);
			t.printStackTrace();
		} finally {
			// Always set response event in command
			aCommand.setResponseEvent(responseEvent);
		}
	}
	
	public Event pullEvent() {
		// TODO Auto-generated method stub
		Session[] allSessions = SessionManager.getInstance().getSessions();
		JSONArray array = new JSONArray();
		UserDao userDao = new UserDao();
		for (Session session: allSessions) {
			JSONObject obj = new JSONObject();
			try {
				String p_id = session.getId();
				//UserMO user = userDao.findUserbypushSessionId(p_id);
				ConcurrentHashMap<String, String> userSessionMap = UserSession.getInstance().userWithPushletSession;
				String userUuid = null;
				for(Entry<String, String> entry: userSessionMap.entrySet()) {
					if (p_id.equals(entry.getValue())) {
						userUuid = entry.getKey();
						break;
					}
				}
				if (userUuid != null) {
					obj.put("p_id", p_id);
					obj.put("userUuid", userUuid);
					UserMO user = userDao.findUserbyId(userUuid);
					obj.put("userName", user.getUserName());
					obj.put("online", user.isOnline());
				} else {
					obj.put("p_id", p_id);
					obj.put("userUuid", "");
				}
				
			} catch (JSONException e) {
				e.printStackTrace();
			}
			array.put(obj);
		}
		
		Event event = Event.createDataEvent("/queryOnline");
		event.setField("action", "online");
		event.setField("onlinePersonList", array.toString());
		return event;
	}
}
