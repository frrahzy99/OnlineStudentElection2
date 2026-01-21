<%-- 
    Document   : voted_success
    Created on : Jan 9, 2026, 1:35:57 PM
    Author     : User
--%>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);
%>

<%@ page import="java.util.*, java.sql.Timestamp, dao.VoteDAO, model.Candidate" %>

<%
    if (session.getAttribute("studentId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String studentId = (String) session.getAttribute("studentId");
    VoteDAO voteDAO = new VoteDAO();

    List<Candidate> votedCandidates = voteDAO.getVotedCandidatesByStudent(studentId);
    Timestamp votedAt = voteDAO.getVoteTime(studentId);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Your Voted Future Leaders</title>
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

        <h2 class="section-title mt-10">Your Voted Future Leaders</h2>

        <p class="voted-time">
            Voted at: <%= votedAt %>
        </p>

        <div class="candidate-grid mt-20">

            <% for (Candidate c : votedCandidates) { %>
                <div class="candidate-card">
                    <img src="<%= request.getContextPath() %>/images/<%= c.getImagePath() %>">
                    <div class="candidate-name"><%= c.getName() %></div>
                    <div class="candidate-course"><%= c.getCourseName() %></div>
                </div>
            <% } %>

        </div>

    </div>
</div>

</body>
</html>


