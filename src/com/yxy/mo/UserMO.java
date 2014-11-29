package com.yxy.mo;

public class UserMO {
	private String userUuid;
	private String userName;
	private String password;
	private boolean online;
	private String pushSessionId;
	
	
	public String getPushSessionId() {
		return pushSessionId;
	}
	public void setPushSessionId(String pushSessionId) {
		this.pushSessionId = pushSessionId;
	}
	public String getUserUuid() {
		return userUuid;
	}
	public void setUserUuid(String userUuid) {
		this.userUuid = userUuid;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public boolean isOnline() {
		return online;
	}
	public void setOnline(boolean online) {
		this.online = online;
	}
	@Override
	public String toString() {
		return "UserMO [userUuid=" + userUuid + ", userName=" + userName
				+ ", online=" + online + ", pushSessionId=" + pushSessionId + "]";
	}
}
