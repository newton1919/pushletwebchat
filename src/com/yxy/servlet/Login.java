package com.yxy.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.yxy.dao.UserDao;
import com.yxy.mo.UserMO;

/**
 * Servlet implementation class Login
 */
@WebServlet("/login")
public class Login extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Login() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		request.getRequestDispatcher("/html/login.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String userName = request.getParameter("userName");
		String password = request.getParameter("password");
		UserDao userDao = new UserDao();
		UserMO user = userDao.loginUser(userName, password);
		if (user == null) {
			request.setAttribute("error", "userName or password error, try again");
			request.getRequestDispatcher("/html/login.jsp").forward(request, response);
			return;
		} else {
			//login success
			HttpSession session=request.getSession();
			session.setAttribute("userName", user.getUserName());
			session.setAttribute("userUuid", user.getUserUuid());
			request.getRequestDispatcher("/html/index.jsp").forward(request, response);
		}
	}

}
