package com.cheatsheet.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.cheatsheet.utils.DBConnection;

public class BookmarksRepository {

    public boolean toggleBookmark(String snippetId, String userId) {
	// Step 1: Check if it already exists
	String checkSql = "SELECT count(*) FROM bookmarks WHERE snippets_id = ? AND user_id = ?";
	String insertSql = "INSERT INTO bookmarks (snippets_id, user_id) VALUES (?, ?)";
	String deleteSql = "DELETE FROM bookmarks WHERE snippets_id = ? AND user_id = ?";

	try (Connection con = DBConnection.getConnection()) {
	    // Check existence
	    PreparedStatement checkPs = con.prepareStatement(checkSql);
	    checkPs.setString(1, snippetId);
	    checkPs.setString(2, userId);
	    ResultSet rs = checkPs.executeQuery();

	    if (rs.next() && rs.getInt(1) > 0) {
		// It exists, so REMOVE it (Toggle Off)
		PreparedStatement delPs = con.prepareStatement(deleteSql);
		delPs.setString(1, snippetId);
		delPs.setString(2, userId);
		delPs.executeUpdate();
		return false; // Returns false to indicate "unbookmarked"
	    } else {
		// It doesn't exist, so ADD it (Toggle On)
		PreparedStatement insPs = con.prepareStatement(insertSql);
		insPs.setString(1, snippetId);
		insPs.setString(2, userId);
		insPs.executeUpdate();
		return true; // Returns true to indicate "bookmarked"
	    }
	} catch (SQLException e) {
	    e.printStackTrace();
	    return false;
	}
    }

    public boolean isBookmarked(String snippetId, String userId) {
	String sql = "SELECT 1 FROM bookmarks WHERE snippets_id = ? AND user_id = ?";
	try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
	    ps.setString(1, snippetId);
	    ps.setString(2, userId);
	    try (ResultSet rs = ps.executeQuery()) {
		return rs.next();
	    }
	} catch (SQLException e) {
	    return false;
	}
    }
}
