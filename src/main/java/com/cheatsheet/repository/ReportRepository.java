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
    private static final String PENDING_STATUS = "PENDING";
    private static final String RESOLVED_STATUS = "RESOLVED";

    public boolean insertReport(ReportBean obj) {
	String sql = "INSERT INTO reports (id, report_by, target_id, target_type, reason, status) VALUES (?, ?, ?, ?, ?, ?)";

	try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

	    ps.setString(1, UUID.randomUUID().toString());
	    ps.setString(2, obj.getUserId());
	    ps.setString(3, obj.getTargetId());
	    ps.setString(4, obj.getTargetType());
	    ps.setString(5, obj.getReason());
	    ps.setString(6, PENDING_STATUS);

	    return ps.executeUpdate() > 0;

	} catch (SQLException e) {
	    e.printStackTrace();
	    return false;
	}
    }

    public List<ReportBean> getReportsByTargetType(String type) {
	List<ReportBean> list = new ArrayList<>();
	String sql = "SELECT r.id, u.username as report_by, r.target_id, c.comment_text,r.target_type, r.reason, r.status, r.admin_reason, r.created_at FROM reports r "
		     + "JOIN users u ON r.report_by =u.id "
		     + " JOIN comments c ON c.id=r.target_id "
		     + "WHERE r.target_type = ? AND r.status = ? ORDER BY r.created_at DESC";

	try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
	    ps.setString(1, type);
	    ps.setString(2, PENDING_STATUS);
	    try (ResultSet rs = ps.executeQuery()) {
		while (rs.next()) {
		    ReportBean r = new ReportBean();
		    r.setId(rs.getString("id"));
		    r.setUserName(rs.getString("report_by"));
		    r.setTargetId(rs.getString("target_id"));
		    r.setTargetType(rs.getString("target_type"));
		    r.setCommentText(rs.getString("comment_text"));
		    r.setReason(rs.getString("reason"));
		    r.setStatus(rs.getString("status"));
		    r.setAdminReason(rs.getString("admin_reason"));
		    r.setCreatedAt(rs.getTimestamp("created_at").toString());
		    list.add(r);
		}
	    }
	} catch (SQLException e) {
	    e.printStackTrace();
	}
	return list;
    }

    public boolean updateReportStatusByReportId(String reportId, String newStatus, String adminReason) {
	String sql = "UPDATE reports SET status = ?, admin_reason = ? WHERE id = ?";
	try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
	    ps.setString(1, newStatus);
	    ps.setString(2, normalizeAdminReason(adminReason));
	    ps.setString(3, reportId);
	    return ps.executeUpdate() > 0;
	} catch (SQLException e) {
	    e.printStackTrace();
	    return false;
	}
    }

    public boolean updatePendingReportsStatusByTargetId(String targetId, String newStatus, String adminReason) {
	String sql = "UPDATE reports SET status = ?, admin_reason = ? WHERE target_id = ? AND status = ?";

	try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
	    ps.setString(1, newStatus);
	    ps.setString(2, normalizeAdminReason(adminReason));
	    ps.setString(3, targetId);
	    ps.setString(4, PENDING_STATUS);
	    return ps.executeUpdate() > 0;
	} catch (SQLException e) {
	    e.printStackTrace();
	    return false;
	}
    }

    public int countPendingReports() {
	String sql = "SELECT COUNT(*) FROM reports WHERE status = ?";
	try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
	    ps.setString(1, PENDING_STATUS);
	    try (ResultSet rs = ps.executeQuery()) {
		if (rs.next())
		    return rs.getInt(1);
	    }
	} catch (SQLException e) {
	    e.printStackTrace();
	}
	return 0;
    }

    public int countActiveSnippets() {
	String sql = "SELECT COUNT(*) FROM snippets WHERE deleted_at IS NULL AND status = '1'";
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

    public String getResolvedStatus() {
	return RESOLVED_STATUS;
    }

    private String normalizeAdminReason(String adminReason) {
	if (adminReason == null) {
	    return null;
	}

	String trimmed = adminReason.trim();
	return trimmed.isEmpty() ? null : trimmed;
    }
}
