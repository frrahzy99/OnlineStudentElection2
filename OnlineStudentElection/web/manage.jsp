<%-- 
    Document   : manage
    Created on : Jan 9, 2026
--%>

<%@ page import="java.util.*, dao.CandidateDAO, dao.CourseDAO, model.Candidate, model.Course" %>

<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }

    CandidateDAO candidateDAO = new CandidateDAO();
    List<Candidate> candidates = candidateDAO.getAllCandidates();

    CourseDAO courseDAO = new CourseDAO();
    List<Course> courses = courseDAO.getAllCourses();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Candidates - Online Student Election FSKM 2025</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>

<!-- HEADER -->
<div class="top-header">
    Online Student Election FSKM 2025
    <div class="top-nav">
        <a href="dashboard.jsp">Dashboard</a>
        <a href="manage.jsp">Manage Candidates</a>
        <a href="admin_login.jsp">Log Out</a>
    </div>
</div>

<!-- CONTENT -->
<div class="page-container">
    <div class="card">

        <h2 class="section-title">Candidates List</h2>

        <div class="manage-toolbar">
            <div class="left">
                <button class="btn btn-primary" onclick="openAddPopup()">+ Add Candidate</button>
            </div>

            <div class="right">
                <input id="searchInput" class="search-input" type="text" placeholder="Search by ID or name">

                <!-- COURSE FILTER -->
                <select id="courseFilter">
                    <option value="all">All courses</option>
                    <% for (Course c : courses) { %>
                        <option value="<%= c.getCourseName() %>">
                            <%= c.getCourseName() %>
                        </option>
                    <% } %>
                </select>
            </div>
        </div>

        <!-- CANDIDATE GRID -->
        <div class="manage-grid mt-20" id="candidateGrid">
            <% for (Candidate c : candidates) { %>
                <div class="manage-card"
                     data-id="<%= c.getCandidateId() %>"
                     data-name="<%= c.getName() %>"
                     data-course="<%= c.getCourseName() %>">

                    <img src="<%= request.getContextPath() %>/images/<%= c.getImagePath() %>">

                    <div class="candidate-name"><%= c.getName() %></div>
                    <div class="candidate-course"><%= c.getCourseName() %></div>

                    <div class="manage-actions">
                        <button class="btn btn-yellow"
                            onclick="openEditPopup(
                                '<%= c.getCandidateId() %>',
                                '<%= c.getName() %>',
                                '<%= c.getCourseId() %>'
                            )">
                            Edit
                        </button>

                 <button class="btn btn-red"
                    onclick="if(confirm('Delete this candidate?')) {
                        window.location.href='DeleteCandidateServlet?id=<%= c.getCandidateId() %>';
                    }">
                    Delete
                </button>

                    </div>
                </div>
            <% } %>
        </div>

    </div>
</div>

<!-- ================= ADD POPUP ================= -->
<div id="addPopup" class="popup-bg hidden">
    <div class="popup-box">
        <form action="AddCandidateServlet" method="post" enctype="multipart/form-data">

            <div class="popup-title">Add Candidate</div>

            <div class="form-group">
                <label>Candidate ID</label>
                <input type="text" name="candidateId" required>
            </div>

            <div class="form-group">
                <label>Candidate Name</label>
                <input type="text" name="candidateName" required>
            </div>

            <div class="form-group">
                <label>Course</label>
                <select name="courseId" required>
                    <% for (Course c : courses) { %>
                        <option value="<%= c.getCourseId() %>">
                            <%= c.getCourseName() %>
                        </option>
                    <% } %>
                </select>
            </div>

            <div class="form-group">
                <label>Image</label>
                <input type="file" name="image">
            </div>

            <div class="popup-actions">
                <button type="button" class="btn btn-outline" onclick="closeAddPopup()">Cancel</button>
                <button type="submit" class="btn btn-primary">Save</button>
            </div>
        </form>
    </div>
</div>

<!-- ================= EDIT POPUP ================= -->
<div id="editPopup" class="popup-bg hidden">
    <div class="popup-box">
        <form action="EditCandidateServlet" method="post" enctype="multipart/form-data">

            <div class="popup-title">Edit Candidate</div>

            <input type="hidden" id="editCandidateId" name="candidateId">

            <div class="form-group">
                <label>Candidate Name</label>
                <input type="text" id="editName" name="candidateName" required>
            </div>

            <div class="form-group">
                <label>Course</label>
                <select id="editCourse" name="courseId">
                    <% for (Course c : courses) { %>
                        <option value="<%= c.getCourseId() %>">
                            <%= c.getCourseName() %>
                        </option>
                    <% } %>
                </select>
            </div>

            <div class="form-group">
                <label>Change Image</label>
                <input type="file" name="image">
            </div>

            <div class="popup-actions">
                <button type="button" class="btn btn-outline" onclick="closeEditPopup()">Cancel</button>
                <button type="submit" class="btn btn-primary">Update</button>
            </div>
        </form>
    </div>
</div>

<!-- ================= JS ================= -->
<script>
function openAddPopup() {
    document.getElementById("addPopup").classList.remove("hidden");
}

function closeAddPopup() {
    document.getElementById("addPopup").classList.add("hidden");
}

function openEditPopup(id, name, courseId) {
    document.getElementById("editCandidateId").value = id;
    document.getElementById("editName").value = name;
    document.getElementById("editCourse").value = courseId;
    document.getElementById("editPopup").classList.remove("hidden");
}

function closeEditPopup() {
    document.getElementById("editPopup").classList.add("hidden");
}

document.getElementById("searchInput").addEventListener("input", filter);
document.getElementById("courseFilter").addEventListener("change", filter);

function filter() {
    const term = document.getElementById("searchInput").value.toLowerCase();
    const course = document.getElementById("courseFilter").value;

    document.querySelectorAll(".manage-card").forEach(card => {
        const matchText =
            card.dataset.name.toLowerCase().includes(term) ||
            card.dataset.id.toLowerCase().includes(term);

        const matchCourse = course === "all" || card.dataset.course === course;

        card.style.display = (matchText && matchCourse) ? "block" : "none";
    });
}
</script>

</body>
</html>
