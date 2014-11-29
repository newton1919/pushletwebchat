package com.yxy.extend;

import com.yxy.mo.UserMO;

import nl.justobjects.pushlet.core.Session;

public class UserSession extends Session{
	private UserMO user;

	public UserMO getUser() {
		return user;
	}

	public void setUser(UserMO user) {
		this.user = user;
	}
	
}
