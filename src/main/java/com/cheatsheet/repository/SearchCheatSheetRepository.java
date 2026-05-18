package com.cheatsheet.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.cheatsheet.model.SnippetsBean;
import com.cheatsheet.utils.DBConnection;

public class SearchCheatSheetRepository {
    public List<SnippetsBean> searchSnippets(String keyword) {
	List<SnippetsBean> list = new ArrayList<>();

	// Fixed: Added explicit spaces before JOIN, WHERE, and ORDER BY blocks
	String sql = "SELECT s.*, u.id AS user_id, u.username, c.name AS categoryName " + "FROM snippets s "
		     + "LEFT JOIN categories c ON s.categories_id = c.id "
		     + "LEFT JOIN users u ON s.created_by = u.id " // Switched to LEFT JOIN to handle deleted accounts
								   // gracefully
		     + "WHERE (s.title LIKE ? OR s.contents LIKE ? OR u.username LIKE ?) "
		     + "AND s.deleted_at IS NULL " // Crucial if you have soft-deletes in your database!
		     + "ORDER BY s.created_at DESC";

	try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

	    String searchPattern = "%" + (keyword != null ? keyword.trim() : "") + "%";

	    // Fixed: All three placeholders are now safely mapped
	    ps.setString(1, searchPattern);
	    ps.setString(2, searchPattern);
	    ps.setString(3, searchPattern);

	    try (ResultSet rs = ps.executeQuery()) {
		while (rs.next()) {
		    SnippetsBean bean = new SnippetsBean();
		    bean.setId(rs.getString("id"));
		    bean.setUserId(rs.getString("user_id"));

		    // Fixed: Dynamically pulling the real username row cell instead of literal text
		    String author = rs.getString("username");
		    bean.setCreatedBy(author != null ? author : "Deleted User");

		    bean.setTitle(rs.getString("title"));
		    bean.setContent(rs.getString("contents"));
		    bean.setCategoryName(rs.getString("categoryName"));
		    bean.setBgColor(rs.getString("bg_color"));
		    bean.setFontFamily(rs.getString("font_family"));

		    list.add(bean);
		}
	    }
	} catch (SQLException e) {
	    System.err.println("Database Exception encountered during search operation for keyword: " + keyword);
	    e.printStackTrace();
	}
	return list;
    }

}
