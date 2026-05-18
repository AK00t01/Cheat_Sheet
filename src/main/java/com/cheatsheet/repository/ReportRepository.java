package com.cheatsheet.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import com.cheatsheet.model.ReportBean;
import com.cheatsheet.utils.DBConnection;

public class ReportRepository {
    public boolean insertReport(ReportBean obj) {
	String sql = "INSERT INTO reports (id, report_by, target_id, target_type, reason, status) VALUES (?, ?, ?, ?, ?, 'PENDING')";

	try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

	    ps.setString(1, UUID.randomUUID().toString());
	    ps.setString(2, obj.getUserId());
	    ps.setString(3, obj.getTargetId());
	    ps.setString(4, obj.getTargetType());
	    ps.setString(5, obj.getReason());

	    return ps.executeUpdate() > 0;

	} catch (SQLException e) {
	    e.printStackTrace();
	    return false;
	}
    }

    public List<ReportBean> getReportsByTargetType(String type) {
	List<ReportBean> list = new ArrayList<>();
	String sql = "SELECT r.id, u.username as report_by, r.target_id, r.target_type, r.reason, r.status, r.created_at FROM reports r "
		     + "JOIN users u ON r.report_by =u.id "
		     + "WHERE r.target_type = ? AND r.status = 'PENDING' ORDER BY r.created_at DESC";

	try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
	    ps.setString(1, type);
	    try (ResultSet rs = ps.executeQuery()) {
		while (rs.next()) {
		    ReportBean r = new ReportBean();
		    r.setId(rs.getString("id"));
		    r.setUserName(rs.getString("report_by"));
		    r.setTargetId(rs.getString("target_id"));
		    r.setTargetType(rs.getString("target_type"));
		    r.setReason(rs.getString("reason"));
		    r.setStatus(rs.getString("status"));
		    r.setCreatedAt(rs.getTimestamp("created_at").toString());
		    list.add(r);
		}
	    }
	} catch (SQLException e) {
	    e.printStackTrace();
	}
	return list;
    }

    public boolean updateReportStatus(String reportId, String newStatus) {
	String sql = "UPDATE reports SET status = ? WHERE id = ?";
	try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
	    ps.setString(1, newStatus);
	    ps.setString(2, reportId);
	    return ps.executeUpdate() > 0;
	} catch (SQLException e) {
	    e.printStackTrace();
	    return false;
	}
    }

    public int countPendingReports() {
	String sql = "SELECT COUNT(*) FROM reports WHERE status = 'PENDING'";
	try (Connection con = DBConnection.getConnection();
		PreparedStatement ps = con.prepareStatement(sql);
		ResultSet rs = ps.executeQuery()) {
	    if (rs.next())
		return rs.getInt(1);
	} catch (SQLException e) {
	    e.printStackTrace();
	}
	return 0;
    }

    public int countActiveSnippets() {
	String sql = "SELECT COUNT(*) FROM snippets WHERE deleted_at IS NULL";
	try (Connection con = DBConnection.getConnection();
		PreparedStatement ps = con.prepareStatement(sql);
		ResultSet rs = ps.executeQuery()) {
	    if (rs.next())
		return rs.getInt(1);
	} catch (SQLException e) {
	    e.printStackTrace();
	}
	return 0;
    }

    public int countTotalUsers() {
	String sql = "SELECT COUNT(*) FROM users";
	try (Connection con = DBConnection.getConnection();
		PreparedStatement ps = con.prepareStatement(sql);
		ResultSet rs = ps.executeQuery()) {
	    if (rs.next())
		return rs.getInt(1);
	} catch (SQLException e) {
	    e.printStackTrace();
	}
	return 0;
    }
}
