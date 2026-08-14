<%@ page import="java.sql.*" %>
<%@ page import="utils.DBConnection" %>

<%
response.setHeader("Cache-Control","no-cache,no-store,must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires",0);

String user=(String)session.getAttribute("user");

if(user==null){
    response.sendRedirect("login.jsp");
    return;
}

String admin=(String)session.getAttribute("admin");
String teacher=(String)session.getAttribute("teacher");
String name=(String)session.getAttribute("name");

String teacherDepartment=(String)session.getAttribute("teacherDepartment");
String teacherSemester=(String)session.getAttribute("teacherSemester");
String teacherSection=(String)session.getAttribute("teacherSection");

int totalStudents=0;
int totalTeachers=0;
int presentToday=0;
int absentToday=0;
%>

<html>
<style>
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:'Segoe UI',Arial,sans-serif;
}

html{
    scroll-behavior:smooth;
}

body{
    padding:30px;
    min-height:100vh;
    background:
        radial-gradient(circle at 10% 20%, rgba(0,255,255,0.18), transparent 25%),
        radial-gradient(circle at 85% 25%, rgba(255,0,255,0.16), transparent 30%),
        radial-gradient(circle at 70% 80%, rgba(0,120,255,0.14), transparent 28%),
        linear-gradient(135deg,#020617,#111827,#000);
    background-attachment:fixed;
}

body::-webkit-scrollbar{
    width:12px;
}

body::-webkit-scrollbar-thumb{
    background:linear-gradient(#00c6ff,#0072ff);
    border-radius:20px;
}

.container{
    width:96%;
    margin:auto;
    padding:45px;
    border-radius:36px;
    background:rgba(255,255,255,0.05);
    backdrop-filter:blur(28px);
    border:1px solid rgba(255,255,255,0.12);
    box-shadow:
        0 0 50px rgba(0,255,255,0.08),
        0 0 120px rgba(255,255,255,0.04),
        inset 0 0 40px rgba(255,255,255,0.03);
    animation:fadeIn 0.8s ease;
}

@keyframes fadeIn{
    from{
        opacity:0;
        transform:translateY(30px);
    }
    to{
        opacity:1;
        transform:translateY(0);
    }
}

h2{
    text-align:center;
    color:white;
    font-size:54px;
    margin:15px 0 25px;
    text-shadow:
        0 0 20px rgba(255,255,255,0.7),
        0 0 50px rgba(0,255,255,0.25);
}

.welcome{
    text-align:center;
    font-size:38px;
    font-weight:700;
    color:white;
    margin-bottom:30px;
    text-shadow:0 0 18px rgba(255,255,255,0.4);
}

.topRightButtons{
    position:absolute;
    top:20px;
    right:30px;
    display:flex;
    gap:18px;
}

.teacherBtn,.logoutBtn,.updateBtn,.deleteBtn,.detailsBtn,.marksBtn,.attBtn,.reportBtn{
    color:white;
    padding:14px 22px;
    border-radius:16px;
    text-decoration:none;
    font-weight:700;
    display:inline-block;
    transition:all .35s ease;
    box-shadow:0 0 15px rgba(255,255,255,0.08);
}

.teacherBtn{background:linear-gradient(135deg,#f7971e,#ffd200);}
.logoutBtn{background:linear-gradient(135deg,#ff416c,#ff4b2b);}
.updateBtn{background:linear-gradient(135deg,#ffb347,#ffcc33);}
.deleteBtn{background:linear-gradient(135deg,#ff0844,#ff6a88);}
.detailsBtn{background:linear-gradient(135deg,#00c6ff,#0072ff);}
.marksBtn{background:linear-gradient(135deg,#8e2de2,#4a00e0);}
.attBtn{background:linear-gradient(135deg,#11998e,#38ef7d);}
.reportBtn{background:linear-gradient(135deg,#434343,#000);}

.teacherBtn:hover,.logoutBtn:hover,.updateBtn:hover,.deleteBtn:hover,
.detailsBtn:hover,.marksBtn:hover,.attBtn:hover,.reportBtn:hover{
    transform:translateY(-5px) scale(1.08);
    box-shadow:
        0 0 25px rgba(255,255,255,0.18),
        0 0 40px rgba(0,255,255,0.15);
}

.searchBox{
    width:340px;
    padding:18px;
    font-size:18px;
    border-radius:18px;
    border:1px solid rgba(255,255,255,0.14);
    outline:none;
    color:white;
    background:rgba(255,255,255,0.08);
    backdrop-filter:blur(12px);
    transition:.3s;
}

.searchBox::placeholder{
    color:#cbd5e1;
}

.searchBox:hover,
.searchBox:focus{
    transform:scale(1.03);
    box-shadow:
        0 0 20px rgba(0,255,255,0.25);
}

.searchBtn{
    padding:18px 28px;
    font-size:18px;
    font-weight:bold;
    color:white;
    border:none;
    border-radius:18px;
    cursor:pointer;
    background:linear-gradient(135deg,#43e97b,#38f9d7);
    transition:.35s;
}

.searchBtn:hover{
    transform:translateY(-3px) scale(1.05);
    box-shadow:0 0 25px rgba(72,255,176,0.35);
}

.dashboard{
    display:flex;
    justify-content:center;
    gap:25px;
    margin:40px 0;
    flex-wrap:wrap;
}

.cardBox{
    width:240px;
    padding:30px 25px;
    border-radius:24px;
    text-align:center;
    background:rgba(255,255,255,0.07);
    backdrop-filter:blur(16px);
    border:1px solid rgba(255,255,255,0.08);
    box-shadow:0 0 25px rgba(255,255,255,0.05);
    transition:all .35s ease;
}

.cardBox:hover{
    transform:translateY(-10px) scale(1.05);
    box-shadow:
        0 0 35px rgba(0,255,255,0.18),
        0 0 80px rgba(255,255,255,0.04);
}

.cardBox h3{
    color:#e5e7eb;
    margin-bottom:18px;
    font-size:24px;
}

.cardBox p{
    font-size:44px;
    font-weight:800;
    color:#00ffff;
    text-shadow:0 0 18px rgba(0,255,255,0.35);
}

table{
    width:100%;
    margin-top:35px;
    border-collapse:collapse;
    overflow:hidden;
    border-radius:26px;
    background:rgba(255,255,255,0.05);
    backdrop-filter:blur(18px);
}

th{
    padding:22px;
    font-size:18px;
    color:white;
    background:linear-gradient(135deg,#1d4ed8,#06b6d4);
    letter-spacing:.5px;
}

td{
    padding:18px;
    text-align:center;
    color:#f8fafc;
}

tr{
    transition:.35s;
    border-bottom:1px solid rgba(255,255,255,0.05);
}

tr:nth-child(even){
    background:rgba(255,255,255,0.03);
}

tr:hover{
    background:rgba(255,255,255,0.11);
    transform:scale(1.005);
}

.noData{
    color:#ff4d6d;
    text-align:center;
    font-size:28px;
    font-weight:bold;
    padding:30px;
    text-shadow:0 0 15px rgba(255,77,109,0.4);
}

.filterBox select{
    padding:15px;
    border-radius:12px;
    font-size:17px;
    width:200px;
    color:white;
    border:1px solid rgba(255,255,255,0.18);
    background:rgba(255,255,255,0.08);
}

.filterBox select option{
    color:black;
}
</style>

<head>
<title>Student Management</title>

<script>
function confirmDelete(){ return confirm("Delete student?"); }
function confirmLogout(){ return confirm("Logout?"); }
</script>
</head>

<body>
<div class="container">

<div class="topRightButtons">
<% if(admin!=null){ %>
<a href="teacherregister.jsp" class="teacherBtn">Teacher Register</a>
<a href="adminAttendance.jsp" class="teacherBtn">Attendance Report</a>
<% } %>
<a href="logout.jsp" class="logoutBtn" onclick="return confirmLogout()">Logout</a>
</div>

<div class="welcome">
Welcome, <%= admin!=null ? "Admin" : (teacher!=null ? "Teacher" : name) %>
</div>

<center>
<%
String search=request.getParameter("search");
if(admin!=null){
%>
<form action="index.jsp" method="get">
<input class="searchBox" type="text" name="search" placeholder="Search Student">
<input class="searchBtn" type="submit" value="Search">
</form>
<% } %>
</center>

<%
try{
Connection c=DBConnection.getConnection();

Statement st1=c.createStatement();
ResultSet r1=st1.executeQuery("SELECT COUNT(*) FROM students");
if(r1.next()) totalStudents=r1.getInt(1);

Statement st2=c.createStatement();
ResultSet r2=st2.executeQuery("SELECT COUNT(*) FROM teachers");
if(r2.next()) totalTeachers=r2.getInt(1);

PreparedStatement p1=c.prepareStatement("SELECT COUNT(*) FROM attendance WHERE att_date=CURDATE() AND status='Present'");
ResultSet r3=p1.executeQuery();
if(r3.next()) presentToday=r3.getInt(1);

PreparedStatement p2=c.prepareStatement("SELECT COUNT(*) FROM attendance WHERE att_date=CURDATE() AND status='Absent'");
ResultSet r4=p2.executeQuery();
if(r4.next()) absentToday=r4.getInt(1);

c.close();
}catch(Exception e){}
%>

<% if(admin!=null){ %>
<div class="dashboard">
<div class="cardBox"><h3>Total Students</h3><p><%= totalStudents %></p></div>
<div class="cardBox"><h3>Total Teachers</h3><p><%= totalTeachers %></p></div>
<div class="cardBox"><h3>Present Today</h3><p><%= presentToday %></p></div>
<div class="cardBox"><h3>Absent Today</h3><p><%= absentToday %></p></div>
</div>
<% } %>

<h2>Student Management System</h2>

<%
String department=request.getParameter("department");
String semester=request.getParameter("semester");
String section=request.getParameter("section");
%>

<% if(admin!=null){ %>
<center class="filterBox">
<form method="get" action="index.jsp" style="margin-bottom:30px;">

<select name="department" required style="width:200px;">
<option value="">Department</option>
<option value="AIML">AIML</option>
<option value="CSE">CSE</option>
<option value="ISE">ISE</option>
<option value="ECE">ECE</option>
<option value="EEE">EEE</option>
<option value="MECH">MECH</option>
<option value="CIVIL">CIVIL</option>
</select>

<select name="semester" style="width:180px;">
<option value="">Semester</option>
<option>1</option>
<option>2</option>
<option>3</option>
<option>4</option>
<option>5</option>
<option>6</option>
<option>7</option>
<option>8</option>
</select>

<select name="section" style="width:170px;">
<option value="">Section</option>
<option>A</option>
<option>B</option>
<option>C</option>
<option>D</option>
<option>E</option>
<option>F</option>
</select>

<% if(search!=null && !search.trim().equals("")){ %>
<input type="hidden" name="search" value="<%= search %>">
<% } %>

<input type="submit" value="Load Students" class="searchBtn">
</form>
</center>
<% } %>

<table border="1">
<tr>
<th>ID</th>
<th>Student Code</th>
<th>Student Name</th>
<th>Details</th>
<th>Marks</th>
<th>Attendance</th>
<% if(admin!=null || teacher!=null){ %><th>Update</th><% } %>
<% if(admin!=null){ %><th>Delete</th><% } %>
</tr>

<%
boolean hasData=false;

try{
Connection con=DBConnection.getConnection();

StringBuilder sql=new StringBuilder();

if(admin!=null){
    sql.append("SELECT s.* FROM students s ");

    boolean filtered=false;

    if(search!=null && !search.trim().equals("")){
        sql.append("JOIN student_details d ON s.student_code=d.student_code WHERE 1=1 ");
        filtered=true;

        if(department!=null && !department.equals("") && semester!=null && !semester.equals("") && section!=null && !section.equals("")){
            sql.append("AND d.department=? AND d.semester=? AND d.section=? ");
        }

        sql.append("AND (s.fullname LIKE ? OR s.student_code LIKE ? OR s.email LIKE ?) ");
    }
    else if(department!=null && !department.equals("") && semester!=null && !semester.equals("") && section!=null && !section.equals("")){
        sql.append("JOIN student_details d ON s.student_code=d.student_code ");
        sql.append("WHERE d.department=? AND d.semester=? AND d.section=? ");
        filtered=true;
    }

    if(!filtered){
        sql.append("WHERE 1=1 ");
    }

    PreparedStatement ps=con.prepareStatement(sql.toString());

    int i=1;

    if(search!=null && !search.trim().equals("")){
        if(department!=null && !department.equals("") && semester!=null && !semester.equals("") && section!=null && !section.equals("")){
            ps.setString(i++,department);
            ps.setString(i++,semester);
            ps.setString(i++,section);
        }
        ps.setString(i++,"%"+search+"%");
        ps.setString(i++,"%"+search+"%");
        ps.setString(i++,"%"+search+"%");
    }
    else if(department!=null && !department.equals("") && semester!=null && !semester.equals("") && section!=null && !section.equals("")){
        ps.setString(i++,department);
        ps.setString(i++,semester);
        ps.setString(i++,section);
    }

    ResultSet rs=ps.executeQuery();

    while(rs.next()){
    hasData=true;
    int id=rs.getInt("id");
    String studentCode=rs.getString("student_code");
    %>
    <tr>
    <td><%= id %></td>
    <td><%= studentCode %></td>
    <td><%= rs.getString("fullname") %></td>

    <td>
    <a class="detailsBtn" href="details.jsp?code=<%= studentCode %>">Details</a>
    </td>

    <td>
    <a class="marksBtn" href="marks.jsp?code=<%= studentCode %>">Marks</a>
    </td>

    <td>
    <a class="reportBtn" href="attendanceReport.jsp?code=<%= studentCode %>">Report</a>
    </td>

    <td>
    <% if(teacher!=null){ %>
    <a class="attBtn" href="attendance.jsp?code=<%= studentCode %>">Attendance</a>
    <% } else { %>
    <a class="updateBtn" href="adddetails.jsp?code=<%= studentCode %>">Update</a>
    <% } %>
    </td>

    <td>
    <a class="deleteBtn" href="delete?code=<%= studentCode %>" onclick="return confirmDelete()">Delete</a>
    </td>
    </tr>
    <%
    }
    rs.close();
    ps.close();
}
else if(teacher!=null){

    PreparedStatement ps=con.prepareStatement(
        "SELECT s.* FROM students s " +
        "JOIN student_details d ON s.student_code=d.student_code " +
        "WHERE d.department=? AND d.semester=? AND d.section=?"
    );

    ps.setString(1, teacherDepartment);
    ps.setString(2, teacherSemester);
    ps.setString(3, teacherSection);

    ResultSet rs=ps.executeQuery();

    while(rs.next()){
    hasData=true;
    int id=rs.getInt("id");
    String studentCode=rs.getString("student_code");
    %>
    <tr>
    <td><%= id %></td>
    <td><%= studentCode %></td>
    <td><%= rs.getString("fullname") %></td>

    <td>
    <a class="detailsBtn" href="details.jsp?code=<%= studentCode %>">Details</a>
    </td>

    <td>
    <a class="marksBtn" href="marks.jsp?code=<%= studentCode %>">Marks</a>
    </td>

    <td>
    <a class="reportBtn" href="attendanceReport.jsp?code=<%= studentCode %>">Report</a>
    </td>

    <td>
    <a class="attBtn" href="attendance.jsp?code=<%= studentCode %>">Attendance</a>
    </td>
    </tr>
    <%
    }
    rs.close();
    ps.close();
}
else{

    String studentCode=(String)session.getAttribute("studentCode");

    PreparedStatement ps=con.prepareStatement(
        "SELECT * FROM students WHERE student_code=?"
    );

    ps.setString(1, studentCode);

    ResultSet rs=ps.executeQuery();

    while(rs.next()){
    hasData=true;
    int id=rs.getInt("id");
    String code=rs.getString("student_code");
    %>
    <tr>
    <td><%= id %></td>
    <td><%= code %></td>
    <td><%= rs.getString("fullname") %></td>

    <td>
    <a class="detailsBtn" href="details.jsp?code=<%= code %>">Details</a>
    </td>

    <td>
    <a class="marksBtn" href="marks.jsp?code=<%= code %>">Marks</a>
    </td>

    <td>
    <a class="reportBtn" href="attendanceReport.jsp?code=<%= code %>">Report</a>
    </td>
    </tr>
    <%
    }
    rs.close();
    ps.close();
}

con.close();
}catch(Exception e){
out.println(e);
}

if(!hasData){
%>
<tr><td colspan="<%= (admin!=null ? 8 : (teacher!=null ? 7 : 6)) %>" class="noData">No student data found</td></tr>
<%
}
%>
</table>
</div>
</body>
</html>
