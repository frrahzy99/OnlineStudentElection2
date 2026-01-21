package controller;

import dao.VoteDAO;
import dao.CandidateDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/SubmitVoteServlet")
public class SubmitVoteServlet extends HttpServlet {

    private static final int ELECTION_ID = 1; // hardcode for now

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
       
        HttpSession session = request.getSession();
        String studentId = (String) session.getAttribute("studentId");

        if (studentId == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        CandidateDAO candidateDAO = new CandidateDAO();
        VoteDAO voteDAO = new VoteDAO();

        // ❌ Candidate cannot vote
        if (candidateDAO.isStudentCandidate(studentId)) {
            response.sendRedirect("candidate_not_allowed.jsp");
            return;
        }

        // ❌ Student already voted
        if (voteDAO.hasStudentVoted(studentId)) {
            response.sendRedirect("voted_success.jsp");
            return;
        }


        String[] candidateIds = request.getParameterValues("candidateIds");
        
        // 🔍 DEBUG START
        System.out.println("Student ID: " + studentId);

        if (candidateIds != null) {
            System.out.println("Number of candidates selected: " + candidateIds.length);
            for (String id : candidateIds) {
                System.out.println("Candidate selected: " + id);
            }
        } else {
            System.out.println("candidateIds is NULL");
        }
        // 🔍 DEBUG END

        if (candidateIds == null || candidateIds.length == 0) {
            response.sendRedirect("votepage.jsp");
            return;
        }

        int currentVotes = voteDAO.getVoteCount(studentId, ELECTION_ID);

        if (currentVotes + candidateIds.length > 2) {
            response.sendRedirect("vote_limit_exceeded.jsp");
            return;
        }

        for (String candidateId : candidateIds) {
            if (!voteDAO.hasVotedCandidate(studentId, candidateId, ELECTION_ID)) {
                voteDAO.addVote(studentId, candidateId, ELECTION_ID);
            }
        }

        session.setAttribute("hasVoted", true);
        response.sendRedirect(request.getContextPath() + "/voted_success.jsp");

    }
}
