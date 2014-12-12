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
		//Session session = sessionFactory.getCurrentSession();
		Session session = sessionFactory.openSession();
		Transaction transaction = session.beginTransaction();
		
		UserMO newUser = new UserMO();
		newUser.setOnline(false);
		newUser.setPassword(password);
		newUser.setPushSessionId(null);
		newUser.setUserName(userName);
		session.save(newUser);
		transaction.commit();
		session.close();
	}
	
	@SuppressWarnings("unchecked")
	public UserMO findUserbyName(String userName) {
		//Session session = sessionFactory.getCurrentSession();
		//for bae,must not be long connected session
		Session session = sessionFactory.openSession();
		Transaction transaction = session.beginTransaction();
		
		Criteria criteria = session.createCriteria(UserMO.class);
		Criteria criteria2 = criteria.add(Restrictions.eq("userName", userName));
		List<UserMO> userList = criteria2.list();
		transaction.commit();
		session.close();
		if (userList == null || userList.isEmpty()) {
			return null;
		} else {
			return userList.get(0);
		}
		
	}
	
	@SuppressWarnings("unchecked")
	public UserMO findUserbyId(String userUuid) {
		//Session session = sessionFactory.getCurrentSession();
		Session session = sessionFactory.openSession();
		Transaction transaction = session.beginTransaction();
		
		Criteria criteria = session.createCriteria(UserMO.class);
		Criteria criteria2 = criteria.add(Restrictions.eq("userUuid", userUuid));
		UserMO userMO = (UserMO)criteria2.uniqueResult();
		transaction.commit();
		session.close();
		return userMO;
	}
	
	@SuppressWarnings("unchecked")
	public UserMO findUserbypushSessionId(String pushSessionId) {
		//Session session = sessionFactory.getCurrentSession();
		Session session = sessionFactory.openSession();
		Transaction transaction = session.beginTransaction();
		
		Criteria criteria = session.createCriteria(UserMO.class);
		Criteria criteria2 = criteria.add(Restrictions.eq("pushSessionId", pushSessionId));
		List<UserMO> userList = criteria2.list();
		transaction.commit();
		session.close();
		if (userList == null || userList.isEmpty()) {
			return null;
		} else {
			return userList.get(0);
		}
		
	}
	
	public void updateUserWithpushSessionId(String userUuid, String pushSessionId) {
		//Session session = sessionFactory.getCurrentSession();
		Session session = sessionFactory.openSession();
		Transaction transaction = session.beginTransaction();
		UserMO user = (UserMO)session.get(UserMO.class, userUuid);
		user.setPushSessionId(pushSessionId);
		transaction.commit();
		session.close();
	}
	
	@SuppressWarnings("unchecked")
	public UserMO loginUser(String userName, String password) {
		//Session session = sessionFactory.getCurrentSession();
		Session session = sessionFactory.openSession();
		Transaction transaction = session.beginTransaction();
		
		Criteria criteria = session.createCriteria(UserMO.class);
		Criteria criteria2 = criteria.add(Restrictions.eq("userName", userName))
									 .add(Restrictions.eq("password", password));
		List<UserMO> userList = criteria2.list();
		transaction.commit();
		session.close();
		if (userList == null || userList.isEmpty()) {
			return null;
		} else {
			return userList.get(0);
		}
	}
}
