package com.cheatsheet.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;

import com.cheatsheet.model.DetailCheatSheetBean;
import com.cheatsheet.utils.DBConnection;

public class EditAndDeleteCheatsheetsRepository {
    public String getOrCreateCategoryId(String topicName, String parentId) {
	// 1. Try to find existing topic (Case-Insensitive)
	String findSql = "SELECT id FROM categories WHERE LOWER(name) = LOWER(?)";
	try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(findSql)) {
	    ps.setString(1, topicName.trim());
	    ResultSet rs = ps.executeQuery();
	    if (rs.next()) {
		return rs.getString("id"); // Found it!
	    }
	} catch (SQLException e) {
	    e.printStackTrace();
	}

	// 2. If not found, Create it
	String newId = UUID.randomUUID().toString();
	String insertSql = "INSERT INTO categories (id, name, parent_id) VALUES (?, ?, ?)";
	try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(insertSql)) {
	    ps.setString(1, newId);
	    ps.setString(2, topicName.trim());
	    ps.setString(3, parentId); // Associate with a "General" or "User-Created" parent
	    ps.executeUpdate();
	    return newId;
	} catch (SQLException e) {
	    e.printStackTrace();
	    return null;
	}
    }

    public boolean updateSnippet(DetailCheatSheetBean snippet) {
	String sql = "UPDATE snippets SET title = ?, contents = ?, categories_id = ?, bg_color = ?, font_family = ? WHERE id = ?";

	try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

	    ps.setString(1, snippet.getTitle());
	    ps.setString(2, snippet.getContent());
	    ps.setString(3, snippet.getCategoryId()); // UUID of the sub-category
	    ps.setString(4, snippet.getBgColor());
	    ps.setString(5, snippet.getFontFamily());
	    ps.setString(6, snippet.getSheetId());

	    return ps.executeUpdate() > 0;
	} catch (SQLException e) {
	    e.printStackTrace();
	    return false;
	}
    }
}
