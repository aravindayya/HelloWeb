<%@ page import="java.sql.*" %>
<%@ page import="utils.DBConnection" %>

<%
String user=(String)session.getAttribute("user");
String admin=(String)session.getAttribute("admin");
String teacher=(String)session.getAttribute("teacher");
String studentCode=(String)session.getAttribute("studentCode");

if(user==null){
    response.sendRedirect("login.jsp");
    return;
}

String selectedDate=request.getParameter("date");
String code=request.getParameter("code");

if(code==null && studentCode!=null){
    code=studentCode;
}
%>

<html>
<head>
<title>Attendance Report</title>

<style>
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:Arial;
}

body{
    min-height:100vh;
    background:black;
    color:white;
    padding:30px;
    animation:bgGlow 4s infinite alternate;
}

@keyframes bgGlow{
    from{box-shadow:inset 0 0 80px white;}
    to{box-shadow:inset 0 0 150px #aaa;}
}

.card{
    width:95%;
    margin:auto;
    padding:30px;
    border-radius:25px;
    background:rgba(255,255,255,0.08);
    backdrop-filter:blur(15px);
    border:1px solid rgba(255,255,255,0.3);
    box-shadow:0 0 25px rgba(255,255,255,0.4);
}

h1{
    text-align:center;
    margin-bottom:25px;
    text-shadow:0 0 15px white;
}

input,button{
    padding:14px;
    border:none;
    border-radius:12px;
    font-size:16px;
}

button{
    background:white;
    color:black;
    cursor:pointer;
    font-weight:bold;
}

table{
    width:100%;
    border-collapse:collapse;
    margin-top:30px;
    background:rgba(255,255,255,0.08);
}

th{
    background:white;
    color:black;
    padding:14px;
}

td{
    padding:14px;
    text-align:center;
    border-bottom:1px solid rgba(255,255,255,0.2);
}

.present{
    color:#00ff88;
    font-weight:bold;
    text-shadow:0 0 10px #00ff88;
}

.absent{
    color:#ff4d4d;
    font-weight:bold;
    text-shadow:0 0 10px red;
}
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
}

.logout:hover{
    transform:translateY(-4px) scale(1.06);
    background:linear-gradient(135deg,#ff416c,#ff4b2b);
    box-shadow:
        0 0 25px rgba(255,90,90,.65),
        0 0 50px rgba(255,90,90,.35);
}
</style>
</head>

<body>

<div class="card">

<h1>Attendance Report</h1>

<form method="get" action="attendanceReport.jsp">
<center>
<input type="hidden" name="code" value="<%= code==null ? "" : code %>">
<input type="date" name="date" required>
<button type="submit">Load Report</button>
<a href="logout.jsp" class="logout">Logout</a>
</center>
</form>

<%
if(selectedDate!=null){

try{
    Connection con=DBConnection.getConnection();
    PreparedStatement ps;

    if(admin!=null){

        if(code!=null && !code.equals("")){

            ps=con.prepareStatement(
                "SELECT a.*,s.name,s.department,s.semester,s.section " +
                "FROM attendance a " +
                "JOIN student_details s ON a.student_code=s.student_code " +
                "WHERE a.att_date=? AND a.student_code=?"
            );

            ps.setString(1,selectedDate);
            ps.setString(2,code);

        }else{

            ps=con.prepareStatement(
                "SELECT a.*,s.name,s.department,s.semester,s.section " +
                "FROM attendance a " +
                "JOIN student_details s ON a.student_code=s.student_code " +
                "WHERE a.att_date=?"
            );

            ps.setString(1,selectedDate);
        }

    }else if(teacher!=null){

        String teacherSemester=(String)session.getAttribute("teacherSemester");
        String teacherSection=(String)session.getAttribute("teacherSection");
        String teacherDepartment=(String)session.getAttribute("teacherDepartment");

        if(code!=null && !code.equals("")){

            ps=con.prepareStatement(
                "SELECT a.*,s.name,s.department,s.semester,s.section " +
                "FROM attendance a " +
                "JOIN student_details s ON a.student_code=s.student_code " +
                "WHERE a.att_date=? AND a.student_code=?"
            );

            ps.setString(1,selectedDate);
            ps.setString(2,code);

        }else{

            ps=con.prepareStatement(
                "SELECT a.*,s.name,s.department,s.semester,s.section " +
                "FROM attendance a " +
                "JOIN student_details s ON a.student_code=s.student_code " +
                "WHERE a.att_date=? AND s.department=? AND s.semester=? AND s.section=?"
            );

            ps.setString(1,selectedDate);
            ps.setString(2,teacherDepartment);
            ps.setString(3,teacherSemester);
            ps.setString(4,teacherSection);
        }

    }else{

        ps=con.prepareStatement(
            "SELECT a.*,s.name,s.department,s.semester,s.section " +
            "FROM attendance a " +
            "JOIN student_details s ON a.student_code=s.student_code " +
            "WHERE a.att_date=? AND a.student_code=?"
        );

        ps.setString(1,selectedDate);
        ps.setString(2,studentCode);
    }

    ResultSet rs=ps.executeQuery();
%>

<table>

<tr>
<th>Attendance ID</th>
<th>Student Code</th>
<th>Student Name</th>
<th>Department</th>
<th>Semester</th>
<th>Section</th>
<th>Date</th>
<th>Status</th>
<th>Marked By</th>
</tr>

<%
if(rs.next()){

    do{

        String status = rs.getString("status");
%>

<tr>
<td><%= rs.getInt("attendance_id") %></td>
<td><%= rs.getString("student_code") %></td>
<td><%= rs.getString("name") %></td>
<td><%= rs.getString("department") %></td>
<td><%= rs.getString("semester") %></td>
<td><%= rs.getString("section") %></td>
<td><%= rs.getDate("att_date") %></td>

<td class="<%= status.equals("Present") ? "present" : "absent" %>">
<%= status %>
</td>

<td><%= rs.getString("marked_by") %></td>
</tr>

<%
    }while(rs.next());

}else{
%>

<tr>
<td colspan="9" style="color:red;font-size:22px;font-weight:bold;text-align:center;padding:25px;">
No Attendance Found For Selected Date
</td>
</tr>

<%
}
%>

</table>
<%
    rs.close();
    ps.close();
    con.close();

}catch(Exception e){
    out.println(e);
}

}
%>

</div>

</body>
</html>