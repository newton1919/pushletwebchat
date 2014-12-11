package com.yxy.extend;

import java.util.concurrent.ConcurrentHashMap;

public class UserSession {
	private static UserSession userSession = null;
	public ConcurrentHashMap<String, String> userWithPushletSession = new ConcurrentHashMap<String, String>();
	private UserSession(){
	}
	public static UserSession getInstance() {
		if (userSession == null) {
			userSession = new UserSession();
		}
		return userSession;
	}
	
}
