package com.cheatsheet.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.UUID;

import com.cheatsheet.utils.DBConnection;

public class CreateCategoryRepository {

    public void createCategory(String name) {
	String sql = "insert into categories (id,name) value (?,?)";
	Connection con = DBConnection.getConnection();
	try {
	    PreparedStatement ps = con.prepareStatement(sql);
	    ps.setString(1, UUID.randomUUID().toString());
	    ps.setString(2, name);
	    ps.executeUpdate();
	} catch (SQLException e) {

	}
    }
}
