<%-- 
    Document   : admin_login
    Created on : Jan 9, 2026, 1:40:20 PM
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Login - Online Student Election</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>

<div class="top-header">
    Online Student Election<br>
    <small>FSKM</small>
</div>

<div class="page-container">
    <div class="card">
        <h2 class="section-title">Admin Log In</h2>

            <div class="form-wrapper">

                <form action="AdminLoginServlet" method="post">

                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" name="email" required>
                    </div>

                    <div class="form-group">
                        <label>Password</label>
                        <input type="password" name="password" required>
                    </div>

                    <button class="btn btn-primary" type="submit">
                        Log In
                    </button>

                </form>

                <%
                    String error = request.getParameter("error");
                    if ("true".equals(error)) {
                %>
                    <p style="color:red; text-align:center;">
                        Invalid admin credentials
                    </p>
                <%
                    }
                %>

                <p class="center-text mt-10">
                    <a href="index.jsp">Back to Student Login</a>
                </p>

            </div>
    </div>
</div>

</body>
</html>

