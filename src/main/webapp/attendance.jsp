<%@ page import="java.sql.*" %>
<%@ page import="utils.DBConnection" %>

<%
String user=(String)session.getAttribute("user");
String teacher=(String)session.getAttribute("teacher");
String admin=(String)session.getAttribute("admin");

if(user==null || (teacher==null && admin==null)){
    response.sendRedirect("login.jsp");
    return;
}

String teacherSemester=(String)session.getAttribute("teacherSemester");
String teacherSection=(String)session.getAttribute("teacherSection");
String teacherDepartment=(String)session.getAttribute("teacherDepartment");

String date=request.getParameter("date");
%>
<%@ page import="java.time.LocalDate" %>

<%
String today = LocalDate.now().toString();
%>

<html>
<head>
<title>Attendance Dashboard</title>
</head>

<style>
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:'Segoe UI',Arial,sans-serif;
}

body{
    min-height:100vh;
    padding:35px;
    background:
        radial-gradient(circle at 10% 20%, rgba(0,255,255,0.18), transparent 25%),
        radial-gradient(circle at 85% 85%, rgba(255,0,255,0.15), transparent 25%),
        linear-gradient(135deg,#020617,#000000);
}

/* Logout */
.logout{
    position:fixed;
    top:25px;
    right:25px;
    z-index:99999;
    background:rgba(0,0,0,0.78);
    color:white;
    padding:16px 30px;
    border-radius:16px;
    text-decoration:none;
    font-size:22px;
    font-weight:700;
    border:1px solid rgba(255,255,255,0.15);
    backdrop-filter:blur(16px);
    box-shadow:
        0 0 18px rgba(255,255,255,0.15),
        0 0 30px rgba(0,0,0,0.7);
    transition:all .35s ease;
rgb(128, 255, 0)}

.logout:hover{
    transform: translateY(-4px) scale(1.06);
background: linear-gradient(135deg,#00c853,#00e676);
box-shadow:
    0 0 25px rgba(0,230,118,.65),
    0 0 50px rgba(0,230,118,.35);
}
.logout1{
padding:15px 28px;
background:linear-gradient(135deg,#ff9800,#ff5722);
background:rgba(0,0,0,0.78);
    color:white;text-decoration:none;
border-radius:15px;
font-size:20px;
font-weight:bold;
box-shadow:0 0 15px rgba(255,120,0,.4);
transition:.3s;
"
}
.logout1:hover{
 transform:translateY(-4px) scale(1.06);
    background:linear-gradient(135deg,#ff416c,#ff4b2b);
    box-shadow:
        0 0 25px rgba(255,90,90,.65),
        0 0 50px rgba(255,90,90,.35);
}

/* Main Card */
.card{
    width:96%;
    max-width:1550px;
    margin:auto;
    padding:55px;
    border-radius:34px;
    background:rgba(255,255,255,0.06);
    backdrop-filter:blur(26px);
    border:1px solid rgba(255,255,255,0.12);
    box-shadow:
        0 0 55px rgba(0,255,255,0.08),
        inset 0 0 22px rgba(255,255,255,0.04);
}

h2{
    text-align:center;
    color:white;
    font-size:62px;
    margin-bottom:40px;
    font-weight:800;
    text-shadow:
        0 0 25px rgba(255,255,255,.85),
        0 0 50px rgba(0,255,255,.25);
}

.formArea{
    text-align:center;
    margin-bottom:45px;
}

/* Inputs */
select,input{
    min-width:220px;
    padding:18px 22px;
    margin:10px;
    border-radius:18px;
    font-size:18px;
    color:white;
    border:1px solid rgba(255,255,255,0.18);
    background:rgba(255,255,255,0.08);
    backdrop-filter:blur(12px);
    transition:all .35s ease;
}

select option{
    color:black;
}

input[type=date]::-webkit-calendar-picker-indicator{
    filter:invert(1);
}

select:hover,
input:hover{
    transform:translateY(-4px);
    border-color:#00e5ff;
    box-shadow:
        0 0 20px rgba(0,229,255,0.35),
        inset 0 0 12px rgba(255,255,255,0.04);
}

select:focus,
input:focus{
    outline:none;
    border-color:#00e5ff;
    box-shadow:
        0 0 20px rgba(0,229,255,.5),
        0 0 40px rgba(0,229,255,.22);
}

/* Buttons */
button{
    padding:18px 30px;
    margin:10px;
    border:none;
    border-radius:18px;
    font-size:18px;
    font-weight:700;
    color:white;
    cursor:pointer;
    background:linear-gradient(135deg,#00c6ff,#0072ff);
    transition:all .35s ease;
}

button:hover{
    transform:translateY(-4px) scale(1.05);
    box-shadow:
        0 0 25px rgba(0,198,255,.5),
        0 0 45px rgba(0,114,255,.25);
}

center button[type=submit]{
    min-width:260px;
    font-size:22px;
    padding:18px 35px;
    background:linear-gradient(135deg,#43e97b,#38f9d7);
}

/* Table */
table{
    width:100%;
    border-collapse:collapse;
    overflow:hidden;
    border-radius:24px;
    background:rgba(255,255,255,0.05);
    box-shadow:
        0 0 30px rgba(255,255,255,0.04);
}

th{
    padding:22px;
    background:linear-gradient(135deg,#00c6ff,#8e2de2);
    color:white;
    font-size:20px;
    font-weight:700;
}

td{
    padding:20px;
    text-align:center;
    color:white;
    font-size:17px;
}

tr{
    transition:all .35s ease;
}

tr:nth-child(even){
    background:rgba(255,255,255,0.025);
}

tr:hover{
    background:rgba(0,255,255,0.08);
    box-shadow:inset 0 0 24px rgba(0,255,255,0.14);
}

/* Radio */
input[type=radio]{
    width:22px;
    height:22px;
    accent-color:#00e5ff;
    cursor:pointer;
}

</style>
<body>

<div style="
display:flex;
justify-content:space-between;
align-items:center;
margin-bottom:30px;
">

<a href="logout.jsp" class="logout1">
Logout
</a>

<a href="attendanceReport.jsp" class="logout">
Show Attendance Report
</a>

</div>
<div class="card">
<h2>Attendance Dashboard</h2>

<div class="formArea">
<form method="get" action="attendance.jsp">



<input type="hidden" name="date" value="<%= today %>">
<h3 style="color:white;">
Today's Date :
<%= today %>
</h3>

<div id="clock"
     style="color:#00ffcc;
            font-size:24px;
            font-weight:bold;
            margin:15px;">
</div>

<script>
function updateClock(){
    const now = new Date();

    document.getElementById("clock").innerHTML =
        now.toLocaleTimeString();
}

setInterval(updateClock,1000);
updateClock();
</script>
<button type="submit">Load Students</button>
</form>
</div>

<%
if(date!=null){
%>

<form action="saveattendance" method="post">
<input type="hidden" name="semester" value="<%= teacherSemester %>">
<input type="hidden" name="section" value="<%= teacherSection %>">
<input type="hidden" name="department" value="<%= teacherDepartment %>">
<input type="hidden" name="date" value="<%= date %>">

<table>
<tr>
<th>ID</th>
<th>Student Code</th>
<th>Name</th>
<th>Present</th>
<th>Absent</th>
</tr>

<%
try{
    Connection con=DBConnection.getConnection();

    PreparedStatement ps=con.prepareStatement(
    	    "SELECT id,student_code,name FROM student_details WHERE semester=? AND section=? AND department=?"
    	);

    	ps.setString(1, teacherSemester);
    	ps.setString(2, teacherSection);
    	ps.setString(3, teacherDepartment);

    ResultSet rs=ps.executeQuery();

    while(rs.next()){
        int id=rs.getInt("id");
        String code=rs.getString("student_code");
%>

<tr>
<td><%= id %></td>
<td><%= code %></td>
<td><%= rs.getString("name") %></td>
<td><input type="radio" name="status_<%= code %>" value="Present" required></td>
<td><input type="radio" name="status_<%= code %>" value="Absent"></td>
</tr>

<%
    }
    con.close();
}catch(Exception e){
    out.println("<h3 style='color:red'>"+e+"</h3>");
}
%>

</table>

<br><center>

<button type="submit"
onclick="return confirm('Do you want to save attendance?')">
Save Attendance
</button>



</center>

</form>

<%
}
%>

</div>
</body>
</html>