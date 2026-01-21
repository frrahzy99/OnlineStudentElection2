<%-- 
    Document   : signup
    Created on : Jan 9, 2026, 1:32:39 PM
    Author     : User
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sign Up - Online Student Election</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>

    <div class="top-header">
        Online Student Election<br>
        <small>FSKM</small>
    </div>

    <div class="page-container">
        <div class="card">
            <h2 class="section-title">Sign Up Form</h2>
            
            <div class="form-wrapper">

            <form action="SignupServlet" method="post">

                <div class="form-group">
                    <label>Student ID</label>
                    <input type="text" name="studentId" required>
                </div>

                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="fullname" required>
                </div>

                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" required>
                </div>

                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" required>
                </div>

                <button class="btn btn-primary" type="submit">
                    Sign Up
                </button>

            </form>

            <p class="center-text mt-10">
                Already have an account? <a href="index.jsp">Log In</a>
            </p>

            </div>
        </div>
    </div>

</body>
</html>


