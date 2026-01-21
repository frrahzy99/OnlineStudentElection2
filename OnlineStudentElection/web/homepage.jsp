<%-- 
    Document   : homepage
    Created on : Jan 17, 2026, 1:24:27 PM
    Author     : User
--%>

<%@ page import="dao.DashboardDAO, dao.VoteDAO, dao.CandidateDAO" %>

<%
    // Student must be logged in
    if (session.getAttribute("studentId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    DashboardDAO d = new DashboardDAO();
    CandidateDAO candidateDAO = new CandidateDAO();


    int totalStudents = d.getTotalStudents();
    int votedStudents = d.getVotedStudents();
    int notVotedStudents = totalStudents - votedStudents;

    int votedPercent = totalStudents == 0 ? 0 : (votedStudents * 100 / totalStudents);
    int notVotedPercent = 100 - votedPercent;
    VoteDAO voteDAO = new VoteDAO();
    boolean hasVoted = voteDAO.hasStudentVoted(
        (String) session.getAttribute("studentId")
    );

    boolean isCandidate = candidateDAO.isStudentCandidate(
        (String) session.getAttribute("studentId")
    );

%>

<!DOCTYPE html>
<html>
<head>
    <title>Home - Online Student Election</title>
    <link rel="stylesheet" href="css/styles.css">

    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>

<!-- NAVBAR -->
<div class="top-header">
    Online Student Election FSKM 2025
    <div class="top-nav">
        <a href="homepage.jsp">Home</a>
        <a href="<%= isCandidate 
            ? "candidate_not_allowed.jsp" 
            : (hasVoted ? "voted_success.jsp" : "votepage.jsp") %>">
    Vote Now
</a>

        <a href="index.jsp">Logout</a>
    </div>
</div>

<!-- CONTENT -->
<div class="page-container">
    <div class="card center-text">

        <h2>Student Participation</h2>

        <p><strong>Total Registered Students:</strong> <%= totalStudents %></p>
        <p><strong>Already Voted:</strong> <%= votedStudents %> (<%= votedPercent %>%)</p>
        <p><strong>Haven't Voted Yet:</strong> <%= notVotedStudents %> (<%= notVotedPercent %>%)</p>

        <div style="width:300px; margin:30px auto;">
            <canvas id="voteChart"></canvas>
        </div>

        <button class="btn btn-green mt-20"
            onclick="window.location.href='<%= isCandidate 
                ? "candidate_not_allowed.jsp" 
                : (hasVoted ? "voted_success.jsp" : "votepage.jsp") %>'">
            Vote Now
        </button>


    </div>
</div>

<script>
const ctx = document.getElementById('voteChart');

new Chart(ctx, {
    type: 'pie',
    data: {
        labels: ['Already Voted', 'Not Voted'],
        datasets: [{
            data: [<%= votedStudents %>, <%= notVotedStudents %>],
            backgroundColor: ['#4CAF50', '#F44336']
        }]
    }
});
</script>

</body>
</html>

