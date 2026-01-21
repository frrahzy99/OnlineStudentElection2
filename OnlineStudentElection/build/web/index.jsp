<%-- 
    Document   : index
    Created on : Jan 9, 2026, 1:32:14 PM
    Author     : User
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Login - Online Student Election</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>

    <div class="top-header">
        Online Student Election<br>
        <small>FSKM</small>
    </div>

    <div class="page-container">
        <div class="card">
            <h2 class="section-title">Student Login</h2>

            <div class="form-wrapper">

                <form action="LoginServlet" method="post">

                    <div class="form-group">
                        <label>Student ID</label>
                        <input type="text" name="studentId" required>
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
                        Invalid Student ID or Password
                    </p>
                <%
                    }
                %>

                <p class="center-text mt-10">
                    Don’t have an account?
                    <a href="signup.jsp">Sign Up</a>
                </p>

                <p class="center-text mt-10">
                    <a href="admin_login.jsp">Admin Log In</a>
                </p>

            </div>
        </div>
    </div>

</body>
</html>


