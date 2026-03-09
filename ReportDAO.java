package dao;

import pojo.Report_pojo;
import java.sql.*;
import java.util.*;

import connection.GetConnection;

public class ReportDAO {

    private static final String BASE_SELECT =
        "SELECT r.report_id, r.product_id, p.product_name, r.reporter_id, r.reason, r.reported_at, r.status " +
        "FROM reported_products r JOIN product p ON p.product_id = r.product_id " +
        "WHERE p.seller_port_id = ? ";

    public List<Report_pojo> listBySeller(String sellerPortId, String status, String q,
                                     int page, int size, String sortCol, String sortDir) throws SQLException {

        StringBuilder sql = new StringBuilder(BASE_SELECT);
        List<Object> params = new ArrayList<>();
        params.add(sellerPortId);

        if (status != null && !status.isBlank()) {
            sql.append("AND r.status = ? ");
            params.add(status);
        }
        if (q != null && !q.isBlank()) {
            sql.append("AND (p.product_name LIKE ? OR r.reason LIKE ? OR r.reporter_id LIKE ?) ");
            String like = "%" + q + "%";
            params.add(like); params.add(like); params.add(like);
        }

        
        Set<String> allowedCols = Set.of("reported_at","product_name","status");
        if (!allowedCols.contains(sortCol)) sortCol = "reported_at";
        String dir = "DESC".equalsIgnoreCase(sortDir) ? "DESC" : "ASC";
        sql.append("ORDER BY ").append(sortCol).append(" ").append(dir).append(" ");
        sql.append("LIMIT ? OFFSET ?");

        params.add(size);
        params.add((page - 1) * size);

        try (Connection con = GetConnection.getCon();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            try (ResultSet rs = ps.executeQuery()) {
                List<Report_pojo> out = new ArrayList<>();
                while (rs.next()) {
                    Report_pojo r = new Report_pojo();
                    r.setReport_id(size);
                    r.setProduct_id(size);
                    r.setReporter_id(dir);
                    r.setReason(rs.getString("reason"));
                    Timestamp t = rs.getTimestamp("reported_at");
                    r.setStatus(rs.getString("status"));
                    out.add(r);
                }
                return out;
            }
        }
    }

    public int countBySeller(String sellerPortId, String status, String q) throws SQLException {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM reported_products r JOIN product p ON p.product_id = r.product_id WHERE p.seller_port_id = ? ");
        List<Object> params = new ArrayList<>();
        params.add(sellerPortId);

        if (status != null && !status.isBlank()) { sql.append("AND r.status = ? "); params.add(status); }
        if (q != null && !q.isBlank()) {
            sql.append("AND (p.product_name LIKE ? OR r.reason LIKE ? OR r.reporter_id LIKE ?) ");
            String like = "%" + q + "%";
            params.add(like); params.add(like); params.add(like);
        }

        try (Connection con = GetConnection.getCon();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            try (ResultSet rs = ps.executeQuery()) { rs.next(); return rs.getInt(1); }
        }
    }

    public Report_pojo findOne(int reportId, String sellerPortId) throws SQLException {
        String sql = BASE_SELECT + "AND r.report_id = ? LIMIT 1";
        try (Connection con = GetConnection.getCon();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, sellerPortId);
            ps.setInt(2, reportId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                Report_pojo r = new Report_pojo();
                r.setReport_id(rs.getInt("report_id"));
                r.setProduct_id(rs.getInt("product_id")); 
                r.setReporter_id(rs.getString("reporter_id"));
                r.setReason(rs.getString("reason"));
                Timestamp t = rs.getTimestamp("reported_at");
                r.setStatus(rs.getString("status"));
                return r;
            }
        }
    }

    public boolean resolve(int reportId, String sellerPortId) throws SQLException {
        String sql =
          "UPDATE reported_products r JOIN product p ON p.product_id = r.product_id " +
          "SET r.status='resolved' WHERE r.report_id=? AND p.seller_port_id=? AND r.status='open'";
        try (Connection con = GetConnection.getCon();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, reportId);
            ps.setString(2, sellerPortId);
            return ps.executeUpdate() == 1;
        }
    }

    // Simple helper to create a report (useful to seed from code)
    public int create(int productId, String reporterId, String reason) throws SQLException {
        String sql = "INSERT INTO reported_products (product_id, reporter_id, reason, status) VALUES (?,?,?,'open')";
        try (Connection con = GetConnection.getCon();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, productId);
            ps.setString(2, reporterId);
            ps.setString(3, reason);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) { return keys.next() ? keys.getInt(1) : 0; }
        }
    }
}
