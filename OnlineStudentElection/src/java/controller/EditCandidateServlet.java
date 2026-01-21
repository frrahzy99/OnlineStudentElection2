package controller;

import dao.CandidateDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.Paths;

@WebServlet("/EditCandidateServlet")
@MultipartConfig
public class EditCandidateServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "C:/OnlineStudentElectionUploads/images";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("candidateId");
        String name = request.getParameter("candidateName");
        int courseId = Integer.parseInt(request.getParameter("courseId"));

        Part imagePart = request.getPart("image");
        String imagePath = null;

        if (imagePart != null && imagePart.getSize() > 0) {
            String fileName = Paths.get(imagePart.getSubmittedFileName())
                    .getFileName().toString();

            File dir = new File(UPLOAD_DIR);
            if (!dir.exists()) dir.mkdirs();

            File file = new File(dir, fileName);
            imagePart.write(file.getAbsolutePath());

            imagePath = fileName;
        }

        CandidateDAO dao = new CandidateDAO();
        dao.updateCandidate(id, name, courseId, imagePath);

        response.sendRedirect("manage.jsp");
    }
}
