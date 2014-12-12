package com.yxy.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.yxy.dao.UserDao;

@WebServlet("/register")
public class Register extends HttpServlet{

	/**
	 * 
	 */
	private static final long serialVersionUID = -3132218928527819501L;

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
		try {
			String userName = req.getParameter("userName");
			String password = req.getParameter("password");
			String password2 = req.getParameter("password2");
			if (!password.equals(password2)) {
				req.setAttribute("error", "second password mismatch the first");
				req.getRequestDispatcher("/html/register.jsp").forward(req, resp);
				return;
			}
			UserDao userDao = new UserDao();
			if(userDao.findUserbyName(userName) != null) {
				req.setAttribute("error", "userName existed,try another name");
				req.getRequestDispatcher("/html/register.jsp").forward(req, resp);
				return;
			}
			userDao.createUser(userName, password);
			//req.getRequestDispatcher("/html/login.jsp").forward(req, resp);
			resp.sendRedirect("login");
		} catch (Exception ex) {
			ex.printStackTrace();
			req.setAttribute("error", ex.getMessage());
			req.getRequestDispatcher("/html/register.jsp").forward(req, resp);
		}
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		req.getRequestDispatcher("/html/register.jsp").forward(req, resp);
	}
	

}
