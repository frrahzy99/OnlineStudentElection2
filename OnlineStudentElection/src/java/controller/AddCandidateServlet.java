package controller;

import dao.CandidateDAO;
import model.Candidate;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.Paths;

@WebServlet("/AddCandidateServlet")
@MultipartConfig
public class AddCandidateServlet extends HttpServlet {

    private static final String UPLOAD_DIR =
            "C:/OnlineStudentElectionUploads/images";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 🔹 READ FORM DATA
        String candidateId = request.getParameter("candidateId");
        String candidateName = request.getParameter("candidateName");
        String studentId = request.getParameter("studentId"); // ✅ NEW
        int courseId = Integer.parseInt(request.getParameter("courseId"));

        // 🔹 IMAGE UPLOAD
        Part imagePart = request.getPart("image");
        String fileName = "placeholder.jpg";

        if (imagePart != null && imagePart.getSize() > 0) {
            fileName = Paths.get(imagePart.getSubmittedFileName())
                    .getFileName().toString();

            File uploadDir = new File(UPLOAD_DIR);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            File file = new File(uploadDir, fileName);

            try (InputStream input = imagePart.getInputStream();
                 FileOutputStream output = new FileOutputStream(file)) {

                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = input.read(buffer)) != -1) {
                    output.write(buffer, 0, bytesRead);
                }
            }
        }

        // 🔹 BUILD CANDIDATE OBJECT
        Candidate c = new Candidate();
        c.setCandidateId(candidateId);
        c.setName(candidateName);
        c.setStudentId(studentId);   // ✅ IMPORTANT
        c.setCourseId(courseId);
        c.setImagePath(fileName);

        // 🔹 SAVE TO DATABASE
        CandidateDAO dao = new CandidateDAO();
        dao.addCandidate(c);

        response.sendRedirect("manage.jsp");
    }
}
