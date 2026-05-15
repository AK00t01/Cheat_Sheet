package com.cheatsheet.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.cheatsheet.model.SnippetsBean;
import com.cheatsheet.utils.DBConnection;

public class CreateCheatSheetRepository {
    public int saveCheatSheet(SnippetsBean obj) {
	// Added bg_color and font_family to the SQL
	String sqlCat = "INSERT INTO categories(id, name,parent_id) VALUES (UUID(), ?,?) "
			+ "ON DUPLICATE KEY UPDATE name = VALUES(name)";
	String sqlGetId = "SELECT id FROM categories WHERE name = ?";
	String sqlSnippet = "INSERT INTO snippets (id, categories_id, title, contents, created_by, bg_color, font_family) "
			    + "VALUES (UUID(), ?, ?, ?, ?, ?, ?)";

	int result = 0;
	try (Connection con = DBConnection.getConnection()) {
	    // Handle Category
	    PreparedStatement psCat = con.prepareStatement(sqlCat);
	    psCat.setString(1, obj.getTopicName());
	    psCat.setString(2, obj.getCategoryId());
	    psCat.executeUpdate();

	    // Get Category ID
	    String categoryId = null;
	    PreparedStatement psGetId = con.prepareStatement(sqlGetId);
	    psGetId.setString(1, obj.getTopicName());
	    ResultSet rs = psGetId.executeQuery();
	    if (rs.next()) {
		categoryId = rs.getString("id");
	    }

	    // Insert Snippet
	    if (categoryId != null) {
		PreparedStatement psSnippet = con.prepareStatement(sqlSnippet);
		psSnippet.setString(1, categoryId);
		psSnippet.setString(2, obj.getTitle());
		psSnippet.setString(3, obj.getContent());
		psSnippet.setString(4, obj.getCreatedBy());
		psSnippet.setString(5, obj.getBgColor()); // New field
		psSnippet.setString(6, obj.getFontFamily()); // New field

		result = psSnippet.executeUpdate();
	    }
	} catch (SQLException e) {
	    System.err.println("msg"
			       + e.getMessage());
	    e.printStackTrace();
	}
	return result;
    }

}
