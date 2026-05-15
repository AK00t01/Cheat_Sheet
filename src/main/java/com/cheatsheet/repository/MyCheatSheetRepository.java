package com.cheatsheet.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.cheatsheet.model.DetailCheatSheetBean;
import com.cheatsheet.utils.DBConnection;

public class MyCheatSheetRepository {

    public List<DetailCheatSheetBean> getCheatSheetsByUserId(String userId) {
	String sql = "SELECT s.id,c.name as topic_name,c.id as topic_id,tn.name as category_name,tn.id as category_id,\r\n"
		     + "s.title,s.contents,s.view_count,s.created_by,u.username,date(s.created_at) as created_at,"
		     + "COALESCE(stats.rating, 0.0)as rating,COALESCE(stats.user_count, 0) as user_count,s.bg_color,s.font_family\r\n"
		     + "FROM snippets s\r\n"
		     + "JOIN categories c ON s.categories_id=c.id\r\n"
		     + "JOIN categories tn ON c.parent_id=tn.id\r\n"
		     + "JOIN users u ON s.created_by=u.id\r\n"
		     + "\r\n"
		     + "LEFT JOIN(SELECT snippets_id, AVG(stars)as rating,\r\n"
		     + "count(user_id)as user_count\r\n"
		     + "from ratings\r\n"
		     + "GROUP BY snippets_id\r\n"
		     + " ) as stats ON s.id=stats.snippets_id\r\n"
		     + " \r\n"
		     + "WHERE s.created_by=?";
	List<DetailCheatSheetBean> list = new ArrayList<>();

	Connection con = DBConnection.getConnection();
	try {
	    PreparedStatement ps = con.prepareStatement(sql);
	    ps.setString(1, userId);
	    ResultSet rs = ps.executeQuery();
	    while (rs.next()) {
		DetailCheatSheetBean obj = new DetailCheatSheetBean();
		obj.setSheetId(rs.getString("id"));
		obj.setTopic(rs.getString("topic_name"));
		obj.setTopicId(rs.getString("topic_id"));
		obj.setCategoryName(rs.getString("category_name"));
		obj.setCategoryId(rs.getString("category_id"));
		obj.setTitle(rs.getString("title"));
		obj.setContent(rs.getString("contents"));
		obj.setViewCount(rs.getInt("view_count"));
		obj.setUserId(rs.getString("created_at"));
		obj.setCreatedBy(rs.getString("username"));
		obj.setCreatedAt(rs.getDate("created_at").toLocalDate());
		obj.setRating(rs.getDouble("rating"));
		obj.setUserCounts(rs.getInt("user_count"));
		obj.setBgColor(rs.getString("bg_color"));
		obj.setFontFamily(rs.getString("font_family"));
		list.add(obj);
	    }
	} catch (SQLException e) {
	    // TODO Auto-generated catch block
	    e.printStackTrace();
	}
	return list;
    }

}
