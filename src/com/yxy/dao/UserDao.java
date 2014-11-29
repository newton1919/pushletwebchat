package com.yxy.dao;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.criterion.Restrictions;
import org.junit.Test;

import com.yxy.mo.UserMO;

import utils.HibernateUtil;

public class UserDao extends HibernateUtil{
	@Test
	public void createTable() {
		
	}
	
	public void createUser(String userName, String password) {
		Session session = sessionFactory.getCurrentSession();
		Transaction transaction = session.beginTransaction();
		
		UserMO newUser = new UserMO();
		newUser.setOnline(false);
		newUser.setPassword(password);
		newUser.setPushSessionId(null);
		newUser.setUserName(userName);
		session.save(newUser);
		transaction.commit();
	}
	
	@SuppressWarnings("unchecked")
	public UserMO findUserbyName(String userName) {
		Session session = sessionFactory.getCurrentSession();
		Transaction transaction = session.beginTransaction();
		
		Criteria criteria = session.createCriteria(UserMO.class);
		Criteria criteria2 = criteria.add(Restrictions.eq("userName", userName));
		List<UserMO> userList = criteria2.list();
		transaction.commit();
		if (userList == null || userList.isEmpty()) {
			return null;
		} else {
			return userList.get(0);
		}
	}
	
	@SuppressWarnings("unchecked")
	public UserMO findUserbypushSessionId(String pushSessionId) {
		Session session = sessionFactory.getCurrentSession();
		Transaction transaction = session.beginTransaction();
		
		Criteria criteria = session.createCriteria(UserMO.class);
		Criteria criteria2 = criteria.add(Restrictions.eq("pushSessionId", pushSessionId));
		List<UserMO> userList = criteria2.list();
		transaction.commit();
		if (userList == null || userList.isEmpty()) {
			return null;
		} else {
			return userList.get(0);
		}
	}
	
	public void updateUserWithpushSessionId(String userUuid, String pushSessionId) {
		Session session = sessionFactory.getCurrentSession();
		Transaction transaction = session.beginTransaction();
		UserMO user = (UserMO)session.get(UserMO.class, userUuid);
		user.setPushSessionId(pushSessionId);
		transaction.commit();
	}
	
	@SuppressWarnings("unchecked")
	public UserMO loginUser(String userName, String password) {
		Session session = sessionFactory.getCurrentSession();
		Transaction transaction = session.beginTransaction();
		
		Criteria criteria = session.createCriteria(UserMO.class);
		Criteria criteria2 = criteria.add(Restrictions.eq("userName", userName))
									 .add(Restrictions.eq("password", password));
		List<UserMO> userList = criteria2.list();
		transaction.commit();
		if (userList == null || userList.isEmpty()) {
			return null;
		} else {
			return userList.get(0);
		}
	}
}
