package com.cheatsheet.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.cheatsheet.model.DetailCheatSheetBean;
import com.cheatsheet.utils.DBConnection;

public class DetailCheatSheetRepository {

    public DetailCheatSheetBean getRatings(String id) {

	String sql = "select snippets_id,count(user_id)as user,round(avg(stars),1)as ratings from ratings\r\n"
		     + "where snippets_id=? "
		     + "group by snippets_id ";
	DetailCheatSheetBean obj = null;
	Connection con = DBConnection.getConnection();
	try {
	    PreparedStatement ps = con.prepareStatement(sql);
	    ps.setString(1, id);
	    ResultSet rs = ps.executeQuery();
	    while (rs.next()) {
		obj = new DetailCheatSheetBean();
		obj.setSheetId(rs.getString("snippets_id"));
		obj.setUserCounts(rs.getInt("user"));
		obj.setRating(rs.getDouble("ratings"));

	    }

	} catch (SQLException e) {
	    e.printStackTrace();
	}
	return obj;
    }

    public DetailCheatSheetBean getCheatSheetById(String id) {
	String sql = "SELECT s.id,c.name as topic,tn.name as category,s.title,s.contents,s.view_count,\r\n"
		     + "s.created_by as user_id,u.username as created_by, date(s.created_at) as created_at,s.updated_at as update_time,\r\n"
		     + "s.bg_color,s.font_family\r\n"
		     + "FROM snippets s\r\n"
		     + "JOIN categories c ON s.categories_id=c.id\r\n"
		     + "LEFT JOIN categories tn ON c.parent_id=tn.id\r\n"
		     + "JOIN users u ON s.created_by=u.id\r\n"
		     + "WHERE s.id=?";
//	List<DetailCheatSheetBean> list = new ArrayList<>();

	DetailCheatSheetBean obj = null;
	Connection con = DBConnection.getConnection();

	try {
	    PreparedStatement ps = con.prepareStatement(sql);
	    ps.setString(1, id);

	    ResultSet rs = ps.executeQuery();
	    if (rs.next()) {
		obj = new DetailCheatSheetBean();
		obj.setSheetId(rs.getString("id"));
		obj.setTopic(rs.getString("topic"));
		obj.setCategoryName(rs.getString("category"));
		obj.setTitle(rs.getString("title"));
		obj.setContent(rs.getString("contents"));
		obj.setViewCount(rs.getInt("view_count"));
		obj.setUserId(rs.getString("user_id"));
		obj.setCreatedBy(rs.getString("created_by"));
		obj.setCreatedAt(rs.getDate("created_at").toLocalDate());
		obj.setEditedTime(rs.getDate("update_time").toLocalDate());
		obj.setBgColor(rs.getString("bg_color"));
		obj.setFontFamily(rs.getString("font_family"));

	    }

	} catch (SQLException e) {

	    e.printStackTrace();
	}
	return obj;

    }

    public void addViewCounts(String id) {
	String sql = "UPDATE  snippets SET view_count=view_count+1 WHERE id=?";
	Connection con = DBConnection.getConnection();
	try {
	    PreparedStatement ps = con.prepareStatement(sql);
	    ps.setString(1, id);
	    ps.executeUpdate();
	} catch (SQLException e) {
	    System.out.println("viewCount err");
	    e.printStackTrace();
	}

    }

}
