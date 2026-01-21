package dao;
import java.sql.*;
import util.DBConnection;

public class DashboardDAO {

    public int getTotalStudents() {
        return getCount("SELECT COUNT(*) FROM STUDENT");
    }

    public int getVotedStudents() {
        return getCount("SELECT COUNT(DISTINCT student_id) FROM VOTE");
    }

    public int getTotalCandidates() {
        return getCount("SELECT COUNT(*) FROM CANDIDATE");
    }

    private int getCount(String sql) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
