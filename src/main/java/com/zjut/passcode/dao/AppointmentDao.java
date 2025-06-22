package com.zjut.passcode.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.zjut.passcode.bean.AccompanyingPerson;
import com.zjut.passcode.bean.Appointment;

public class AppointmentDao extends BaseDao {
    public long addAppointment(Appointment appointment) {
        String sql = "INSERT INTO appointment (visitor_name, visitor_id_card, visitor_phone, visitor_unit, campus, entry_time, transport_mode, license_plate, appointment_type, status, official_dept_id, official_dept_no, official_dept_name, official_contact_person, official_reason) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, appointment.getVisitorName());
            pstmt.setString(2, appointment.getVisitorIdCard());
            pstmt.setString(3, appointment.getVisitorPhone());
            pstmt.setString(4, appointment.getVisitorUnit());
            pstmt.setString(5, appointment.getCampus());
            pstmt.setTimestamp(6, appointment.getEntryTime());
            pstmt.setString(7, appointment.getTransportMode());
            pstmt.setString(8, appointment.getLicensePlate());
            pstmt.setString(9, appointment.getAppointmentType());
            pstmt.setString(10, appointment.getStatus());
            if (appointment.getOfficialDeptId() != null) {
                pstmt.setInt(11, appointment.getOfficialDeptId());
            } else {
                pstmt.setNull(11, java.sql.Types.INTEGER);
            }
            pstmt.setString(12, appointment.getOfficialDeptNo());
            pstmt.setString(13, appointment.getOfficialDeptName());
            pstmt.setString(14, appointment.getOfficialContactPerson());
            pstmt.setString(15, appointment.getOfficialReason());
            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    long appointmentId = rs.getLong(1);
                    if (appointment.getAccompanyingPersons() != null) {
                        for (AccompanyingPerson person : appointment.getAccompanyingPersons()) {
                            addAccompanyingPerson(appointmentId, person);
                        }
                    }
                    return appointmentId;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, rs);
        }
        return -1;
    }

    private boolean addAccompanyingPerson(long appointmentId, AccompanyingPerson person) {
        String sql = "INSERT INTO accompanying_person (appointment_id, full_name, id_card, phone) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, appointmentId);
            pstmt.setString(2, person.getFullName());
            pstmt.setString(3, person.getIdCard());
            pstmt.setString(4, person.getPhone());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt);
        }
        return false;
    }

    public boolean updateAppointment(Appointment appointment) {
        String sql = "UPDATE appointment SET visitor_name=?, visitor_id_card=?, visitor_phone=?, visitor_unit=?, campus=?, entry_time=?, transport_mode=?, license_plate=?, appointment_type=?, status=?, official_dept_id=?, official_contact_person=?, official_reason=? WHERE id=?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, appointment.getVisitorName());
            pstmt.setString(2, appointment.getVisitorIdCard());
            pstmt.setString(3, appointment.getVisitorPhone());
            pstmt.setString(4, appointment.getVisitorUnit());
            pstmt.setString(5, appointment.getCampus());
            pstmt.setTimestamp(6, appointment.getEntryTime());
            pstmt.setString(7, appointment.getTransportMode());
            pstmt.setString(8, appointment.getLicensePlate());
            pstmt.setString(9, appointment.getAppointmentType());
            pstmt.setString(10, appointment.getStatus());
            pstmt.setObject(11, appointment.getOfficialDeptId());
            pstmt.setString(12, appointment.getOfficialContactPerson());
            pstmt.setString(13, appointment.getOfficialReason());
            pstmt.setLong(14, appointment.getId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            close(conn, pstmt);
        }
    }

    public boolean updateAppointmentStatus(long appointmentId, String status, int auditedBy) {
        String sql = "UPDATE appointment SET status = ?, audited_by = ?, audited_at = CURRENT_TIMESTAMP WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setInt(2, auditedBy);
            pstmt.setLong(3, appointmentId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt);
        }
        return false;
    }

    public boolean deleteAppointment(long id) {
        String sql = "DELETE FROM appointment WHERE id=?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            close(conn, pstmt);
        }
    }

    public Appointment getAppointmentById(long id) {
        String sql = "SELECT a.*, d.dept_name as official_dept_name, adm.full_name as audited_by_name " +
                    "FROM appointment a " +
                    "LEFT JOIN department d ON a.official_dept_id = d.id " +
                    "LEFT JOIN admin adm ON a.audited_by = adm.id " +
                    "WHERE a.id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, id);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToAppointment(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, rs);
        }
        return null;
    }

    public List<Appointment> getAppointmentsByVisitor(String visitorName, String encryptedIdCard, String encryptedPhone) {
        String sql = "SELECT a.*, d.dept_name as official_dept_name, adm.full_name as audited_by_name " +
                    "FROM appointment a " +
                    "LEFT JOIN department d ON a.official_dept_id = d.id " +
                    "LEFT JOIN admin adm ON a.audited_by = adm.id " +
                    "WHERE a.visitor_name = ? AND a.visitor_id_card = ? AND a.visitor_phone = ? " +
                    "ORDER BY a.created_at DESC";
        List<Appointment> appointments = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, visitorName);
            pstmt.setString(2, encryptedIdCard);
            pstmt.setString(3, encryptedPhone);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                appointments.add(mapResultSetToAppointment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(conn, pstmt, rs);
        }
        return appointments;
    }
    
    public List<Appointment> searchAppointments(String applyDate, String appointmentDate, String campus, 
                                               String visitorUnit, String visitorName, String visitorIdCard,
                                               String officialDept, String officialContactPerson, String status,
                                               int adminDeptId, String adminRole) {
        List<Appointment> appointments = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder();
        sqlBuilder.append("SELECT a.*, d.dept_name as official_dept_name, adm.full_name as audited_by_name ");
        sqlBuilder.append("FROM appointment a LEFT JOIN department d ON a.official_dept_id = d.id ");
        sqlBuilder.append("LEFT JOIN admin adm ON a.audited_by = adm.id WHERE 1=1 ");
        
        List<Object> params = new ArrayList<>();
        
        if (applyDate != null && !applyDate.trim().isEmpty()) {
            sqlBuilder.append("AND DATE(a.created_at) = ? ");
            params.add(applyDate);
        }
        if (appointmentDate != null && !appointmentDate.trim().isEmpty()) {
            sqlBuilder.append("AND DATE(a.entry_time) = ? ");
            params.add(appointmentDate);
        }
        if (campus != null && !campus.trim().isEmpty()) {
            sqlBuilder.append("AND a.campus = ? ");
            params.add(campus);
        }
        if (visitorUnit != null && !visitorUnit.trim().isEmpty()) {
            sqlBuilder.append("AND a.visitor_unit LIKE ? ");
            params.add("%" + visitorUnit + "%");
        }
        if (visitorName != null && !visitorName.trim().isEmpty()) {
            sqlBuilder.append("AND a.visitor_name LIKE ? ");
            params.add("%" + visitorName + "%");
        }
        if (visitorIdCard != null && !visitorIdCard.trim().isEmpty()) {
            sqlBuilder.append("AND a.visitor_id_card = ? ");
            params.add(visitorIdCard);
        }
        if (officialDept != null && !officialDept.trim().isEmpty()) {
            sqlBuilder.append("AND d.dept_name LIKE ? ");
            params.add("%" + officialDept + "%");
        }
        if (officialContactPerson != null && !officialContactPerson.trim().isEmpty()) {
            sqlBuilder.append("AND a.official_contact_person LIKE ? ");
            params.add("%" + officialContactPerson + "%");
        }
        if (status != null && !status.trim().isEmpty()) {
            sqlBuilder.append("AND a.status = ? ");
            params.add(status);
        }
        
        // 部门管理员只能查看本部门的预约
        if ("DEPT_ADMIN".equals(adminRole)) {
            sqlBuilder.append("AND a.official_dept_id = ? ");
            params.add(adminDeptId);
        }
        
        sqlBuilder.append("ORDER BY a.created_at DESC");
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sqlBuilder.toString())) {
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                appointments.add(mapResultSetToAppointment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return appointments;
    }
    
    public List<Appointment> getPendingOfficialAppointments(int adminDeptId, String adminRole) {
        List<Appointment> appointments = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder();
        sqlBuilder.append("SELECT a.*, d.dept_name as official_dept_name, adm.full_name as audited_by_name ");
        sqlBuilder.append("FROM appointment a LEFT JOIN department d ON a.official_dept_id = d.id ");
        sqlBuilder.append("LEFT JOIN admin adm ON a.audited_by = adm.id ");
        sqlBuilder.append("WHERE a.appointment_type = 'OFFICIAL' AND a.status = 'PENDING' ");
        
        if ("DEPT_ADMIN".equals(adminRole)) {
            sqlBuilder.append("AND a.official_dept_id = ? ");
        }
        
        sqlBuilder.append("ORDER BY a.created_at ASC");
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sqlBuilder.toString())) {
            if ("DEPT_ADMIN".equals(adminRole)) {
                pstmt.setInt(1, adminDeptId);
            }
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                appointments.add(mapResultSetToAppointment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return appointments;
    }
    
    public List<Appointment> getAllAppointments() {
        String sql = "SELECT a.*, d.dept_name as official_dept_name, adm.full_name as audited_by_name " +
                    "FROM appointment a " +
                    "LEFT JOIN department d ON a.official_dept_id = d.id " +
                    "LEFT JOIN admin adm ON a.audited_by = adm.id " +
                    "ORDER BY a.created_at DESC";
        
        List<Appointment> appointments = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                appointments.add(mapResultSetToAppointment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return appointments;
    }
    
    public List<Appointment> getAppointmentsByStatus(String status) {
        String sql = "SELECT a.*, d.dept_name as official_dept_name, adm.full_name as audited_by_name " +
                    "FROM appointment a " +
                    "LEFT JOIN department d ON a.official_dept_id = d.id " +
                    "LEFT JOIN admin adm ON a.audited_by = adm.id " +
                    "WHERE a.status = ? " +
                    "ORDER BY a.created_at DESC";
        
        List<Appointment> appointments = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                appointments.add(mapResultSetToAppointment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return appointments;
    }
    
    public List<AccompanyingPerson> getAccompanyingPersons(long appointmentId) {
        String sql = "SELECT * FROM accompanying_person WHERE appointment_id = ?";
        List<AccompanyingPerson> persons = new ArrayList<>();
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, appointmentId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                AccompanyingPerson person = new AccompanyingPerson();
                person.setId(rs.getLong("id"));
                person.setAppointmentId(rs.getLong("appointment_id"));
                person.setFullName(rs.getString("full_name"));
                person.setIdCard(rs.getString("id_card"));
                person.setPhone(rs.getString("phone"));
                persons.add(person);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return persons;
    }
    
    private Appointment mapResultSetToAppointment(ResultSet rs) throws SQLException {
        Appointment appointment = new Appointment();
        appointment.setId(rs.getLong("id"));
        appointment.setVisitorName(rs.getString("visitor_name"));
        appointment.setVisitorIdCard(rs.getString("visitor_id_card"));
        appointment.setVisitorPhone(rs.getString("visitor_phone"));
        appointment.setVisitorUnit(rs.getString("visitor_unit"));
        appointment.setCampus(rs.getString("campus"));
        appointment.setEntryTime(rs.getTimestamp("entry_time"));
        appointment.setTransportMode(rs.getString("transport_mode"));
        appointment.setLicensePlate(rs.getString("license_plate"));
        appointment.setAppointmentType(rs.getString("appointment_type"));
        appointment.setCreatedAt(rs.getTimestamp("created_at"));
        appointment.setStatus(rs.getString("status"));
        
        int officialDeptId = rs.getInt("official_dept_id");
        if (!rs.wasNull()) {
            appointment.setOfficialDeptId(officialDeptId);
        }
        
        appointment.setOfficialDeptNo(rs.getString("official_dept_no"));
        appointment.setOfficialDeptName(rs.getString("official_dept_name"));
        appointment.setOfficialContactPerson(rs.getString("official_contact_person"));
        appointment.setOfficialReason(rs.getString("official_reason"));
        
        int auditedBy = rs.getInt("audited_by");
        if (!rs.wasNull()) {
            appointment.setAuditedBy(auditedBy);
        }
        
        appointment.setAuditedAt(rs.getTimestamp("audited_at"));
        appointment.setAuditedByName(rs.getString("audited_by_name"));
        
        return appointment;
    }

    /**
     * 按申请月度统计预约次数和人次
     */
    public List<Map<String, Object>> getStatsByApplyMonth() {
        String sql = "SELECT DATE_FORMAT(created_at, '%Y-%m') AS month, COUNT(*) AS count, " +
                "SUM(1 + (SELECT COUNT(*) FROM accompanying_person ap WHERE ap.appointment_id = a.id)) AS person_count " +
                "FROM appointment a GROUP BY month ORDER BY month DESC";
        List<Map<String, Object>> result = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("month", rs.getString("month"));
                map.put("count", rs.getInt("count"));
                map.put("personCount", rs.getInt("person_count"));
                result.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    /**
     * 按预约月度统计预约次数和人次
     */
    public List<Map<String, Object>> getStatsByEntryMonth() {
        String sql = "SELECT DATE_FORMAT(entry_time, '%Y-%m') AS month, COUNT(*) AS count, " +
                "SUM(1 + (SELECT COUNT(*) FROM accompanying_person ap WHERE ap.appointment_id = a.id)) AS person_count " +
                "FROM appointment a GROUP BY month ORDER BY month DESC";
        List<Map<String, Object>> result = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("month", rs.getString("month"));
                map.put("count", rs.getInt("count"));
                map.put("personCount", rs.getInt("person_count"));
                result.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    /**
     * 按校区统计预约次数和人次
     */
    public List<Map<String, Object>> getStatsByCampus() {
        String sql = "SELECT campus, COUNT(*) AS count, " +
                "SUM(1 + (SELECT COUNT(*) FROM accompanying_person ap WHERE ap.appointment_id = a.id)) AS person_count " +
                "FROM appointment a GROUP BY campus ORDER BY count DESC";
        List<Map<String, Object>> result = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("campus", rs.getString("campus"));
                map.put("count", rs.getInt("count"));
                map.put("personCount", rs.getInt("person_count"));
                result.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    /**
     * 按公务访问部门统计预约次数和人次
     */
    public List<Map<String, Object>> getStatsByOfficialDept() {
        String sql = "SELECT d.dept_name, COUNT(*) AS count, " +
                "SUM(1 + (SELECT COUNT(*) FROM accompanying_person ap WHERE ap.appointment_id = a.id)) AS person_count " +
                "FROM appointment a LEFT JOIN department d ON a.official_dept_id = d.id " +
                "WHERE a.appointment_type = 'OFFICIAL' GROUP BY d.dept_name ORDER BY count DESC";
        List<Map<String, Object>> result = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("deptName", rs.getString("dept_name"));
                map.put("count", rs.getInt("count"));
                map.put("personCount", rs.getInt("person_count"));
                result.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    // 按申请月度统计（指定部门和类型）
    public List<Map<String, Object>> getStatsByApplyMonthForDept(int deptId, String type) {
        String sql = "SELECT DATE_FORMAT(created_at, '%Y-%m') AS month, COUNT(*) AS count, " +
                "SUM(1 + (SELECT COUNT(*) FROM accompanying_person ap WHERE ap.appointment_id = a.id)) AS person_count " +
                "FROM appointment a WHERE a.official_dept_id = ? AND a.appointment_type = ? GROUP BY month ORDER BY month DESC";
        List<Map<String, Object>> result = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, deptId);
            pstmt.setString(2, type);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("month", rs.getString("month"));
                map.put("count", rs.getInt("count"));
                map.put("personCount", rs.getInt("person_count"));
                result.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
    // 按预约月度统计（指定部门和类型）
    public List<Map<String, Object>> getStatsByEntryMonthForDept(int deptId, String type) {
        String sql = "SELECT DATE_FORMAT(entry_time, '%Y-%m') AS month, COUNT(*) AS count, " +
                "SUM(1 + (SELECT COUNT(*) FROM accompanying_person ap WHERE ap.appointment_id = a.id)) AS person_count " +
                "FROM appointment a WHERE a.official_dept_id = ? AND a.appointment_type = ? GROUP BY month ORDER BY month DESC";
        List<Map<String, Object>> result = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, deptId);
            pstmt.setString(2, type);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("month", rs.getString("month"));
                map.put("count", rs.getInt("count"));
                map.put("personCount", rs.getInt("person_count"));
                result.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
    // 按校区统计（指定部门和类型）
    public List<Map<String, Object>> getStatsByCampusForDept(int deptId, String type) {
        String sql = "SELECT campus, COUNT(*) AS count, " +
                "SUM(1 + (SELECT COUNT(*) FROM accompanying_person ap WHERE ap.appointment_id = a.id)) AS person_count " +
                "FROM appointment a WHERE a.official_dept_id = ? AND a.appointment_type = ? GROUP BY campus ORDER BY count DESC";
        List<Map<String, Object>> result = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, deptId);
            pstmt.setString(2, type);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("campus", rs.getString("campus"));
                map.put("count", rs.getInt("count"));
                map.put("personCount", rs.getInt("person_count"));
                result.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
    // 按公务访问部门统计（指定部门）
    public List<Map<String, Object>> getStatsByOfficialDeptForDept(int deptId) {
        String sql = "SELECT d.dept_name, COUNT(*) AS count, " +
                "SUM(1 + (SELECT COUNT(*) FROM accompanying_person ap WHERE ap.appointment_id = a.id)) AS person_count " +
                "FROM appointment a LEFT JOIN department d ON a.official_dept_id = d.id " +
                "WHERE a.official_dept_id = ? AND a.appointment_type = 'OFFICIAL' GROUP BY d.dept_name ORDER BY count DESC";
        List<Map<String, Object>> result = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, deptId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("deptName", rs.getString("dept_name"));
                map.put("count", rs.getInt("count"));
                map.put("personCount", rs.getInt("person_count"));
                result.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
} 