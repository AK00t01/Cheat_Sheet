package com.cheatsheet.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.UUID;

import com.cheatsheet.utils.DBConnection;

public class CreateCategoryRepository {

    public boolean createCategory(String name) {
	String sql = "INSERT INTO categories (id, name) VALUES (?, ?)";

	try (Connection con = DBConnection.getConnection()) {
	    if (categoryExists(con, name)) {
		return false;
	    }

	    try (PreparedStatement ps = con.prepareStatement(sql)) {
		ps.setString(1, UUID.randomUUID().toString());
		ps.setString(2, name);
		return ps.executeUpdate() > 0;
	    }
	} catch (SQLException e) {
	    e.printStackTrace();
	    return false;
	}
    }

    private boolean categoryExists(Connection con, String name) throws SQLException {
	String sql = "SELECT 1 FROM categories WHERE LOWER(name) = LOWER(?) LIMIT 1";

	try (PreparedStatement ps = con.prepareStatement(sql)) {
	    ps.setString(1, name);
	    return ps.executeQuery().next();
	}
    }
}
