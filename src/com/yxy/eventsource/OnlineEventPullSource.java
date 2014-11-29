package com.yxy.eventsource;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.yxy.dao.UserDao;
import com.yxy.mo.UserMO;

import nl.justobjects.pushlet.core.Event;
import nl.justobjects.pushlet.core.EventPullSource;
import nl.justobjects.pushlet.core.Session;
import nl.justobjects.pushlet.core.SessionManager;

public class OnlineEventPullSource extends EventPullSource {

	@Override
	protected long getSleepTime() {
		// TODO Auto-generated method stub
		return 2000;
	}

	@Override
	protected Event pullEvent() {
		// TODO Auto-generated method stub
		Session[] allSessions = SessionManager.getInstance().getSessions();
		JSONArray array = new JSONArray();
		UserDao userDao = new UserDao();
		for (Session session: allSessions) {
			JSONObject obj = new JSONObject();
			try {
				String p_id = session.getId();
				UserMO user = userDao.findUserbypushSessionId(p_id);
				if (user != null) {
					obj.put("p_id", p_id);
					obj.put("userUuid", user.getUserUuid());
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
