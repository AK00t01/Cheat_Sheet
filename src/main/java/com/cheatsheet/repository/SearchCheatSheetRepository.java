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
	// SQL using LIKE with wildcard % for partial matching
	String sql = "SELECT s.*, c.name as categoryName FROM snippets s "
		+ "JOIN categories c ON s.categories_id = c.id " + "WHERE s.title LIKE ? OR s.contents LIKE ? "
		+ "ORDER BY s.created_at DESC";

	try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

	    // Setting %keyword% for partial matching
	    String searchPattern = "%" + keyword + "%";
	    ps.setString(1, searchPattern);
	    ps.setString(2, searchPattern);

	    try (ResultSet rs = ps.executeQuery()) {
		while (rs.next()) {
		    SnippetsBean bean = new SnippetsBean();
		    bean.setId(rs.getString("id"));
		    bean.setTitle(rs.getString("title"));
		    bean.setContent(rs.getString("contents"));
		    bean.setCategoryName(rs.getString("categoryName"));
		    bean.setBgColor(rs.getString("bg_color"));
		    bean.setFontFamily(rs.getString("font_family"));
		    list.add(bean);
		}
	    }
	} catch (SQLException e) {
	    e.printStackTrace();
	}
	return list;
    }

}
