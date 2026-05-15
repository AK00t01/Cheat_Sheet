package com.cheatsheet.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import com.cheatsheet.model.CommentsBean;
import com.cheatsheet.utils.DBConnection;
import com.cheatsheet.utils.TimeUnits;

public class CommentsRepository {

    public List<CommentsBean> getCommentsForSnippetById(String snippetId) {
	List<CommentsBean> allComments = new ArrayList<>();
	Map<String, CommentsBean> commentMap = new HashMap<>();

	String sql = "SELECT c.*, u.username FROM comments c "
		     + "JOIN users u ON c.user_id = u.id "
		     + "WHERE c.snippets_id = ? "
		     + "ORDER BY c.created_at ASC";

	try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

	    ps.setString(1, snippetId);
	    ResultSet rs = ps.executeQuery();

	    while (rs.next()) {
		CommentsBean comment = new CommentsBean();
		comment.setId(rs.getString("id"));
		comment.setCommentText(rs.getString("comment_text"));
		comment.setParentCommentsId(rs.getString("parent_comments_id"));
		comment.setUserId(rs.getString("user_id"));
		comment.setUsername(rs.getString("username"));
		comment.setCreatedAt(rs.getTimestamp("created_at"));
		comment.setSnippetsId(rs.getString("snippets_id"));
		comment.setTimeAgo(TimeUnits.convertToTimeAgo(comment.getCreatedAt()));
		// 1. Put every comment into a Map for easy lookup
		commentMap.put(comment.getId(), comment);
		allComments.add(comment);
	    }

	    // 2. The Tree Builder Logic
	    List<CommentsBean> rootComments = new ArrayList<>();

	    for (CommentsBean c : allComments) {
		String parentId = c.getParentCommentsId();

		if (parentId == null || parentId.isEmpty()) {
		    // This is a top-level comment
		    rootComments.add(c);
		} else {
		    // This is a reply! Find the parent in our Map and add this as a child
		    CommentsBean parent = commentMap.get(parentId);
		    if (parent != null) {
			parent.getReplies().add(c);
		    } else {
			rootComments.add(c);
		    }
		}
	    }
	    return rootComments; // Return only the top-level comments (they contain the replies)

	} catch (SQLException e) {
	    e.printStackTrace();
	    return new ArrayList<>();
	}
    }

    public int postComment(CommentsBean obj) {
	String sql = "INSERT INTO comments (id, user_id, snippets_id, comment_text, parent_comments_id) "
		     + "VALUES (?, ?, ?, ?, ?)";

	try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

	    ps.setString(1, UUID.randomUUID().toString());
	    ps.setString(2, obj.getUserId());
	    ps.setString(3, obj.getSnippetsId());
	    ps.setString(4, obj.getCommentText());
	    ps.setString(5, obj.getParentCommentsId()); // JDBC handles null perfectly here

	    return ps.executeUpdate();
	} catch (SQLException e) {
	    e.printStackTrace();
	    return 0;
	}
    }
//
//    public int replyComments(CommentsBean obj) {
//	String sql = "INSERT INTO comments (id,comment_text,snippets_id,user_id,parent_comments_id) values (?,?,?,?,?)";
//	int i = 0;
//	obj.setId(UUID.randomUUID().toString());
//	Connection con = DBConnection.getConnection();
//	try {
//	    PreparedStatement ps = con.prepareStatement(sql);
//	    ps.setString(1, obj.getId());
//	    ps.setString(2, obj.getCommentText());
//	    ps.setString(3, obj.getSnippetsId());
//	    ps.setString(4, obj.getUserId());
//	    ps.setString(5, obj.getParentCommentsId());
//	    i = ps.executeUpdate();
//	} catch (SQLException e) {
//	    e.printStackTrace();
//	}
//
//	return i;
//    }

}
