package dao;

import java.sql.*;
import java.util.*;
import model.Course;
import util.DBConnection;

public class CourseDAO {

    public List<Course> getAllCourses() {
        List<Course> list = new ArrayList<Course>();

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT course_id, course_name FROM COURSE";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Course c = new Course();
                c.setCourseId(rs.getInt("course_id"));
                c.setCourseName(rs.getString("course_name"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
