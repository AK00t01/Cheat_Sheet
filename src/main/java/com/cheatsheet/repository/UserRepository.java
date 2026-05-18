package com.cheatsheet.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;

import com.cheatsheet.model.UserBean;
import com.cheatsheet.utils.DBConnection;

public class UserRepository {

    public int registerUser(String name, String email, String password) {
	Connection con = DBConnection.getConnection();
	String userId = UUID.randomUUID().toString();
//	String hashedPassword = PasswordConfig.hashPassword(password);
	String sql = "INSERT INTO users (id,username, email, password) VALUES (?,?, ?, ?)";
	int i = 0;
	try {
	    PreparedStatement ps = con.prepareStatement(sql);
	    ps.setString(1, userId);
	    ps.setString(2, name);
	    ps.setString(3, email);
	    ps.setString(4, password);
	    i = ps.executeUpdate();
	} catch (Exception e) {
	    e.printStackTrace();
	}
	return i;
    }

    public UserBean loginUser(String email) {
	Connection con = DBConnection.getConnection();
	String sql = "SELECT id,username,role,password FROM users WHERE email = ? ";
//	List<UserBean> list = new ArrayList<>();
	UserBean user = null;

	try {
	    PreparedStatement ps = con.prepareStatement(sql);
	    ps.setString(1, email);
	    ResultSet rs = ps.executeQuery();

	    if (rs.next()) {
		user = new UserBean();
		user.setId(rs.getString("id"));
		user.setName(rs.getString("username"));
		user.setRole(rs.getString("role"));
		user.setHashedPassword(rs.getString("password"));

	    }
	} catch (SQLException e) {
	    e.printStackTrace();
	}
	return user;
    }

    public boolean isEmailRegistered(String email) {
	Connection con = DBConnection.getConnection();
	String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
	try {
	    PreparedStatement ps = con.prepareStatement(sql);
	    ps.setString(1, email);
	    ResultSet rs = ps.executeQuery();
	    if (rs.next()) {
		return rs.getInt(1) > 0;
	    }
	} catch (SQLException e) {
	    e.printStackTrace();
	}
	return false;
    }

    public UserBean getUserById(String id) {
	Connection con = DBConnection.getConnection();
	String sql = "SELECT id, username, role, email FROM users WHERE id = ?";
	UserBean user = null;

	try {
	    PreparedStatement ps = con.prepareStatement(sql);
	    ps.setString(1, id);
	    ResultSet rs = ps.executeQuery();

	    if (rs.next()) {
		user = new UserBean();
		user.setId(rs.getString("id"));
		user.setName(rs.getString("username"));
		user.setRole(rs.getString("role"));
		user.setEmail(rs.getString("email"));
	    }
	} catch (SQLException e) {
	    e.printStackTrace();
	}
	return user;
    }

}
