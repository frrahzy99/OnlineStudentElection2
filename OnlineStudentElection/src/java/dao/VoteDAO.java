package dao;

import java.sql.*;
import java.util.*;
import model.Candidate;
import util.DBConnection;

public class VoteDAO {

    // =========================
    // CHECK TOTAL VOTES BY STUDENT
    // =========================
    public int getVoteCount(String studentId, int electionId) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM VOTE WHERE student_id=? AND election_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, studentId);
            ps.setInt(2, electionId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    // =========================
    // CHECK IF STUDENT VOTED THIS CANDIDATE
    // =========================
    public boolean hasVotedCandidate(String studentId, String candidateId, int electionId) {
        String sql = "SELECT 1 FROM VOTE WHERE student_id=? AND candidate_id=? AND election_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, studentId);
            ps.setString(2, candidateId);
            ps.setInt(3, electionId);

            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // =========================
    // INSERT VOTE (THIS WAS MISSING)
    // =========================
    public void addVote(String studentId, String candidateId, int electionId) {

        String sql = "INSERT INTO VOTE (student_id, candidate_id, election_id, voted_at) " +
                     "VALUES (?, ?, ?, CURRENT_TIMESTAMP)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, studentId);
            ps.setString(2, candidateId);
            ps.setInt(3, electionId);

            ps.executeUpdate();

            System.out.println("✔ Vote inserted: " + studentId + " → " + candidateId);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // =========================
    // CHECK IF STUDENT HAS VOTED AT ALL
    // =========================
    public boolean hasStudentVoted(String studentId) {
        boolean voted = false;
        String sql = "SELECT COUNT(*) FROM VOTE WHERE student_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, studentId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) voted = rs.getInt(1) > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return voted;
    }

    // =========================
    // GET VOTED CANDIDATES
    // =========================
    public List<Candidate> getVotedCandidatesByStudent(String studentId) {
        List<Candidate> list = new ArrayList<>();

        String sql =
            "SELECT c.candidate_id, c.name, c.image_path, co.course_name " +
            "FROM VOTE v " +
            "JOIN CANDIDATE c ON v.candidate_id = c.candidate_id " +
            "JOIN COURSE co ON c.course_id = co.course_id " +
            "WHERE v.student_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, studentId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Candidate c = new Candidate();
                c.setCandidateId(rs.getString("candidate_id"));
                c.setName(rs.getString("name"));
                c.setImagePath(rs.getString("image_path"));
                c.setCourseName(rs.getString("course_name"));
                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // =========================
    // GET VOTE TIME
    // =========================
    public Timestamp getVoteTime(String studentId) {
        String sql = "SELECT MIN(voted_at) FROM VOTE WHERE student_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, studentId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) return rs.getTimestamp(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Map<String, Object>> getCandidateResults() {

    List<Map<String, Object>> list = new ArrayList<>();

    String sql =
        "SELECT c.candidate_id, c.name, c.image_path, co.course_name, " +
        "COUNT(v.vote_id) AS votes " +
        "FROM CANDIDATE c " +
        "LEFT JOIN VOTE v ON c.candidate_id = v.candidate_id " +
        "LEFT JOIN COURSE co ON c.course_id = co.course_id " +
        "GROUP BY c.candidate_id, c.name, c.image_path, co.course_name";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            Map<String, Object> row = new HashMap<>();
            row.put("name", rs.getString("name"));
            row.put("image", rs.getString("image_path"));
            row.put("course", rs.getString("course_name"));
            row.put("votes", rs.getInt("votes"));
            list.add(row);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
    }

    
}
