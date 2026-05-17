package com.cheatsheet.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.cheatsheet.model.CategoriesBean;
import com.cheatsheet.model.SnippetsBean;
import com.cheatsheet.utils.DBConnection;

public class CheatSheetRepository {

    public List<SnippetsBean> getSixSheets() {
	Connection con = DBConnection.getConnection();
	String query = "SELECT s.id,mc.name as name,c.name as topic,s.title,s.bg_color,s.font_family,s.contents,s.view_count,u.username,date(s.created_at)as created_at FROM snippets s\r\n"
		       + "		Left JOIN categories c ON s.categories_id=c.id JOIN users u ON s.created_by=u.id\r\n"
		       + "        LEFT JOIN categories mc ON c.parent_id=mc.id\r\n"
		       + "WHERE s.deleted_at IS NULL"
		       + "		ORDER BY view_count DESC LIMIT 6";
	List<SnippetsBean> list = new ArrayList<SnippetsBean>();
	try {
	    PreparedStatement ps = con.prepareStatement(query);
	    ResultSet rs = ps.executeQuery();
	    while (rs.next()) {
		SnippetsBean sb = new SnippetsBean();
		sb.setId(rs.getString("id"));
		sb.setTopicName(rs.getString("topic"));
		sb.setCategoryName(rs.getString("name"));
		sb.setTitle(rs.getString("title"));
		sb.setBgColor(rs.getString("bg_color"));
		sb.setFontFamily(rs.getString("font_family"));
		sb.setContent(rs.getString("contents"));
		sb.setViewCount(rs.getInt("view_count"));
		sb.setCreatedAt(rs.getString("created_at"));
		sb.setCreatedBy(rs.getString("username"));
		list.add(sb);
	    }
	} catch (SQLException e) {
	    e.printStackTrace();
	}
	return list;
    }

    public List<CategoriesBean> getMainCategories() {
	String sql = "SELECT id,name FROM categories WHERE parent_id is null";
	List<CategoriesBean> list = new ArrayList<CategoriesBean>();
	Connection con = DBConnection.getConnection();

	try {
	    PreparedStatement ps = con.prepareStatement(sql);
	    ResultSet rs = ps.executeQuery();
	    while (rs.next()) {
		CategoriesBean obj = new CategoriesBean();
		obj.setCategoryId(rs.getString("id"));
		obj.setCategoryName(rs.getString("name"));
		list.add(obj);
	    }

	} catch (SQLException e) {
	    e.printStackTrace();
	}
	return list;
    }

    public List<CategoriesBean> getSubCategories(String parentId) {
	String sql = "SELECT id,name FROM categories WHERE parent_id=?";
	List<CategoriesBean> list = new ArrayList<CategoriesBean>();
	Connection con = DBConnection.getConnection();
	try {
	    PreparedStatement ps = con.prepareStatement(sql);
	    ps.setString(1, parentId);
	    ResultSet rs = ps.executeQuery();
	    while (rs.next()) {
		CategoriesBean obj = new CategoriesBean();
		obj.setTopicName(rs.getString("name"));
		obj.setTopicId(rs.getString("id"));
		list.add(obj);
	    }
	} catch (SQLException e) {
	    e.printStackTrace();
	}
	return list;
    }

    public List<SnippetsBean> getSheetByCategoryId(String id) {
	String sql = "SELECT s.id as sheetid,c.name as category,t.name as topic,s.title,s.contents,s.bg_color,s.font_family,s.view_count,u.username,date(s.created_at)as date\r\n"
		     + "		FROM snippets s \r\n"
		     + "        JOIN categories t ON t.id=s.categories_id\r\n"
		     + "        JOIN categories c ON c.id=t.parent_id\r\n"
		     + "		JOIN users u ON u.id=s.created_by \r\n"
		     + "        WHERE t.parent_id=? AND deleted_at IS NULL;";
	List<SnippetsBean> list = new ArrayList<SnippetsBean>();
	Connection con = DBConnection.getConnection();
	try {
	    PreparedStatement ps = con.prepareStatement(sql);
	    ps.setString(1, id);
	    ResultSet rs = ps.executeQuery();
	    while (rs.next()) {
		SnippetsBean obj = new SnippetsBean();
		obj.setId(rs.getString("sheetid"));
		obj.setTopicName(rs.getString("topic"));
		obj.setCategoryId(rs.getString("category"));
		obj.setTitle(rs.getString("title"));
		obj.setContent(rs.getString("contents"));
		obj.setBgColor(rs.getString("bg_color"));
		obj.setFontFamily(rs.getString("font_family"));
		obj.setViewCount(rs.getInt("view_count"));
		obj.setCreatedBy(rs.getString("username"));
		obj.setCreatedAt(rs.getString("date"));
		list.add(obj);
	    }
	} catch (SQLException e) {
	    e.printStackTrace();
	}
	return list;
    }

    public int getRatingByUserIdAndSheetId(String userId, String sheetId) {
	String sql = "SELECT stars from ratings\r\n" + "where user_id=? and snippets_id=?";

	Connection con = DBConnection.getConnection();
	int i = 0;
	try {
	    PreparedStatement ps = con.prepareStatement(sql);
	    ps.setString(1, userId);
	    ps.setString(2, sheetId);
	    ResultSet rs = ps.executeQuery();
	    if (rs.next()) {
		i = rs.getInt("stars");
	    }

	} catch (SQLException e) {
	    e.printStackTrace();
	}

	return i;
    }

    // Save or Update a rating (The "Upsert" logic)
    public void saveOrUpdateRating(String userId, String sheetId, int stars) {
	// Check if rating exists
	int existingRating = getRatingByUserIdAndSheetId(userId, sheetId);

	if (existingRating > 0) {
	    // Update
	    String updateSql = "UPDATE ratings SET stars = ? WHERE user_id = ? AND snippets_id = ?";
	    try (Connection con = DBConnection.getConnection();
		    PreparedStatement ps = con.prepareStatement(updateSql)) {
		ps.setInt(1, stars);
		ps.setString(2, userId);
		ps.setString(3, sheetId);
		ps.executeUpdate();
	    } catch (SQLException e) {
		e.printStackTrace();
	    }
	} else {
	    // Insert new with a UUID
	    String insertSql = "INSERT INTO ratings (id, user_id, snippets_id, stars) VALUES (?, ?, ?, ?)";
	    try (Connection con = DBConnection.getConnection();
		    PreparedStatement ps = con.prepareStatement(insertSql)) {
		ps.setString(1, java.util.UUID.randomUUID().toString());
		ps.setString(2, userId);
		ps.setString(3, sheetId);
		ps.setInt(4, stars);
		ps.executeUpdate();
	    } catch (SQLException e) {
		e.printStackTrace();
	    }
	}
    }
}