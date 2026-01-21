package dao;

import model.Candidate;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CandidateDAO {

    // 🔹 Get all candidates (for manage.jsp & votepage.jsp)
   public List<Candidate> getAllCandidates() {

    List<Candidate> list = new ArrayList<>();

    try {
        Connection conn = DBConnection.getConnection();

        String sql =
            "SELECT c.candidate_id, c.name, c.image_path, " +
            "c.student_id, c.election_id, c.course_id, " +
            "co.course_name " +
            "FROM CANDIDATE c " +
            "LEFT JOIN COURSE co ON c.course_id = co.course_id";

        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Candidate c = new Candidate();
            c.setCandidateId(rs.getString("candidate_id"));
            c.setName(rs.getString("name"));
            c.setImagePath(rs.getString("image_path"));
            c.setStudentId(rs.getString("student_id"));
            c.setElectionId(rs.getInt("election_id"));
            c.setCourseId(rs.getInt("course_id"));
            c.setCourseName(rs.getString("course_name")); // ✅

            list.add(c);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}
    // 🔹 Add new candidate
    public void addCandidate(Candidate c) {

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "INSERT INTO CANDIDATE " +
                         "(candidate_id, name, image_path, course_id) " +
                         "VALUES (?, ?, ?, ?)";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, c.getCandidateId());
            ps.setString(2, c.getName());
            ps.setString(3, c.getImagePath());
            ps.setInt(4, c.getCourseId());

            System.out.println(">>> DAO inserting candidate: " + c.getCandidateId());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

public void updateCandidate(String id, String name, int courseId, String imagePath) {

    try {
        Connection conn = DBConnection.getConnection();

        String sql;
        PreparedStatement ps;

        if (imagePath != null) {
            sql = "UPDATE CANDIDATE SET name=?, course_id=?, image_path=? WHERE candidate_id=?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setInt(2, courseId);
            ps.setString(3, imagePath);
            ps.setString(4, id);
        } else {
            sql = "UPDATE CANDIDATE SET name=?, course_id=? WHERE candidate_id=?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setInt(2, courseId);
            ps.setString(3, id);
        }

        ps.executeUpdate();

    } catch (Exception e) {
        e.printStackTrace();
    }
}


     
    public boolean isStudentCandidate(String studentId) {
        boolean isCandidate = false;

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT 1 FROM CANDIDATE WHERE candidate_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, studentId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                isCandidate = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return isCandidate;
    }

     // ================= DELETE (FIXED) =================
    public void deleteCandidate(String candidateId) {

        Connection conn = null;
        PreparedStatement psVote = null;
        PreparedStatement psCandidate = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // delete votes first
            String sqlVote = "DELETE FROM VOTE WHERE candidate_id = ?";
            psVote = conn.prepareStatement(sqlVote);
            psVote.setString(1, candidateId);
            psVote.executeUpdate();

            // delete candidate
            String sqlCandidate = "DELETE FROM CANDIDATE WHERE candidate_id = ?";
            psCandidate = conn.prepareStatement(sqlCandidate);
            psCandidate.setString(1, candidateId);

            int rows = psCandidate.executeUpdate();
            System.out.println("Deleted candidate rows: " + rows);

            conn.commit();

        } catch (Exception e) {
            try {
                if (conn != null) conn.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();

        } finally {
            try {
                if (psVote != null) psVote.close();
                if (psCandidate != null) psCandidate.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

}
