<%-- 
    Document   : dashboard
    Created on : Jan 9, 2026, 1:38:02 PM
    Author     : User
--%>

<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }
%>

<%@ page import="dao.DashboardDAO, dao.VoteDAO, java.util.*" %>
<%
DashboardDAO d = new DashboardDAO();
int total = d.getTotalStudents();
int voted = d.getVotedStudents();
int candidates = d.getTotalCandidates();
int percent = total == 0 ? 0 : (voted * 100 / total);
VoteDAO voteDAO = new VoteDAO();
List<Map<String, Object>> results = voteDAO.getCandidateResults();

%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Online Student Election FSKM 2025</title>
    <<link rel="stylesheet" href="css/styles.css">
</head>
<body>

<div class="top-header">
    Online Student Election FSKM 2025
    <div class="top-nav">
        <a href="dashboard.jsp">Dashboard</a>
        <a href="manage.jsp">Manage Candidates</a>
        <a href="admin_login.jsp">Log Out</a>
    </div>
</div>

<div class="page-container">

<div class="card">

        <!-- TOP CARD -->
        <div class="dashboard-top-card">
            <div class="dashboard-stat red-card">
                <div class="dashboard-stat-title">Total Registered Students</div>
                <div class="dashboard-stat-number">
                    <span class="big-number"><%= total %></span>
                    <span class="small-number">/100</span>
                </div>
            </div>
        </div>

        <!-- BOTTOM TWO CARDS -->
        <div class="dashboard-bottom-cards">

            <div class="dashboard-stat yellow-card">
                <div class="dashboard-stat-title">Students Voted</div>
                <div class="dashboard-stat-number">
                    <span class="big-number"><%= voted %></span>
                    <span class="small-number">/100</span>
                </div>
            </div>

            <div class="dashboard-stat green-card">
                <div class="dashboard-stat-title">Total Candidates</div>
                <div class="dashboard-stat-number">
                    <span class="big-number"><%= candidates %></span>
                </div>
            </div>

        </div>



        <div class="result-title">Candidates Result</div>

        <div id="resultsArea">

        <%
        for (Map<String, Object> r : results) {
            int votes = ((Number) r.get("votes")).intValue();
            int percentVote = total == 0 ? 0 : (votes * 100 / total);
        %>

            <div class="result-row">
                <img src="<%= request.getContextPath() %>/images/<%= r.get("image") %>">

                <div style="flex:1;">
                    <div class="result-name"><%= r.get("name") %></div>
                    <div class="result-meta"><%= r.get("course") %></div>
                </div>

                <div class="result-percent"><%= percentVote %>%</div>
            </div>

        <% } %>

        </div>


        <div class="course-summary-list">

        <%
        Map<String, Integer> courseMap = new HashMap<String, Integer>();

        for (Map<String, Object> r : results) {
            String course = (String) r.get("course");

            Integer count = courseMap.get(course);
            if (count == null) {
                courseMap.put(course, 1);
            } else {
                courseMap.put(course, count + 1);
            }
        }


        for (String course : courseMap.keySet()) {
        %>
            <div class="course-badge">
                <%= course %>: <%= courseMap.get(course) %> candidate(s)
            </div>
        <% } %>

        </div>

    </div>

</div>


</body>
</html>

