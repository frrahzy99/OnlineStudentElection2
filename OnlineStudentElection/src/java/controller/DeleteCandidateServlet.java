package controller;

import dao.CandidateDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/DeleteCandidateServlet")
public class DeleteCandidateServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String candidateId = request.getParameter("id");

        CandidateDAO dao = new CandidateDAO();
        dao.deleteCandidate(candidateId);

        response.sendRedirect("manage.jsp");
    }
}
