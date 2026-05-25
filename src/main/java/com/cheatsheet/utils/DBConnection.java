package com.cheatsheet.utils;

import java.sql.Connection;

public class DBConnection {
//    public static void main(String[] args) {
//	Connection con = new DBConnection().getConnection();
//    }

    public static Connection getConnection() {
	Connection con = null;
	try {

	    Class.forName("com.mysql.cj.jdbc.Driver");
	    con = java.sql.DriverManager.getConnection("jdbc:mysql://localhost:3306/cheat_sheet", "root", "root");
	    // System.out.println(con);
	} catch (Exception e) {
	    e.printStackTrace();
	    System.out.println("Connection Error : " + e.getMessage());
	}
	return con;
    }
}
