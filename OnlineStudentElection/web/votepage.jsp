<%@ page import="java.util.*, dao.CandidateDAO, model.Candidate" %>

<%@ page import="dao.CandidateDAO, dao.VoteDAO" %>

<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);
%>

<%  
    if (session.getAttribute("studentId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String studentId = (String) session.getAttribute("studentId");

    CandidateDAO candidateDAO = new CandidateDAO();
    VoteDAO voteDAO = new VoteDAO();

    //  Candidate cannot vote
    if (candidateDAO.isStudentCandidate(studentId)) {
        response.sendRedirect("candidate_not_allowed.jsp");
        return;
    }
    
    // DATABASE check ONLY
    if (voteDAO.hasStudentVoted(studentId)) {
        response.sendRedirect("voted_success.jsp");
        return;
    }
    // Load candidates
    List<Candidate> candidates = candidateDAO.getAllCandidates();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Vote Page</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>

<div class="top-header">
    Online Student Election FSKM 2025
    <div class="top-nav">
        <a href="homepage.jsp">Home</a>
        <a href="index.jsp">Log Out</a>
    </div>
</div>

<div class="page-container">
    <div class="card">

        <p class="center-text">
            Welcome, <strong><%= session.getAttribute("fullname") %></strong>
        </p>

        <h2 class="section-title mt-10">Vote Your Future Leaders!</h2>
        <p class="center-text muted">Max: 2 candidates</p>

        <form action="<%= request.getContextPath() %>/SubmitVoteServlet" method="post">


            <div class="candidate-grid">

                <% for (Candidate c : candidates) { %>
                <div class="candidate-card">
                    <span class="badge">Selected</span>

                    <img src="<%= request.getContextPath() %>/images/<%= c.getImagePath() %>">

                    <div class="candidate-name"><%= c.getName() %></div>
                    <div class="candidate-course"><%= c.getCourseName() %></div>

       
                    
                    <input type="checkbox"
                        name="candidateIds"
                        value="<%= c.getCandidateId() %>"
                        class="vote-checkbox hidden">
                    

                </div>
                <% } %>

            </div>

            <div class="center-text mt-20">
                <button type="submit" class="btn btn-green">
                    Submit Vote
                </button>

                <p class="muted mt-10" id="voteHint">Select up to 2 candidates.</p>
            </div>

        </form>

    </div>

</div>

<script>
const cards = document.querySelectorAll('.candidate-card');
const hint = document.getElementById('voteHint');

let selectedCount = 0;

cards.forEach(card => {
    card.addEventListener('click', () => {
        const checkbox = card.querySelector('.vote-checkbox');

        if (checkbox.checked) {
            checkbox.checked = false;
            card.classList.remove('selected');
            selectedCount--;
        } else {
            if (selectedCount >= 2) {
                alert('You can only select up to 2 candidates');
                return;
            }
            checkbox.checked = true;
            card.classList.add('selected');
            selectedCount++;
        }

        hint.textContent = `Selected: ${selectedCount}/2`;
    });
});
</script>





</body>
</html>
