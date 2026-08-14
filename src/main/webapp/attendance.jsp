<%@ page import="java.sql.*" %>
<%@ page import="utils.DBConnection" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.util.*" %>
<%
String user=(String)session.getAttribute("user");

if(user==null){
    response.sendRedirect("login.jsp");
    return;
}

String teacher=(String)session.getAttribute("teacher");
String admin=(String)session.getAttribute("admin");
String studentCode=(String)session.getAttribute("studentCode");

boolean isTeacher = (teacher!=null);
boolean isAdmin = (admin!=null);

String code=request.getParameter("code");
if(code==null || code.trim().equals("")){
    code=studentCode;
}

String today = LocalDate.now().toString();
String selectedDate=request.getParameter("date");
if(selectedDate==null || selectedDate.trim().equals("")){
    selectedDate=today;
}

String msg=request.getParameter("msg");
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

.topBar{
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-bottom:25px;
    gap:10px;
    flex-wrap:wrap;
}

.navBtn{
    background:rgba(0,0,0,0.78);
    color:white;
    text-decoration:none;
    padding:15px 28px;
    border-radius:15px;
    font-size:20px;
    font-weight:bold;
    border:1px solid rgba(255,255,255,0.15);
    box-shadow:0 0 15px rgba(255,120,0,.4);
    transition:.3s;
}

.navBtn:hover{
    transform:translateY(-4px) scale(1.06);
    background:linear-gradient(135deg,#ff416c,#ff4b2b);
    box-shadow:0 0 25px rgba(255,90,90,.65);
}

.card{
    width:96%;
    max-width:1550px;
    margin:auto;
    padding:45px;
    border-radius:34px;
    background:rgba(255,255,255,0.06);
    backdrop-filter:blur(26px);
    border:1px solid rgba(255,255,255,0.12);
    box-shadow:0 0 55px rgba(0,255,255,0.08), inset 0 0 22px rgba(255,255,255,0.04);
}

h2{
    text-align:center;
    color:white;
    font-size:52px;
    margin-bottom:10px;
    font-weight:800;
    text-shadow:0 0 25px rgba(255,255,255,.85), 0 0 50px rgba(0,255,255,.25);
}

.subtitle{
    text-align:center;
    color:#9ae6ff;
    font-size:20px;
    margin-bottom:30px;
}

.formArea{
    text-align:center;
    margin-bottom:35px;
}

input[type=date]{
    min-width:220px;
    padding:16px 22px;
    margin:10px;
    border-radius:16px;
    font-size:17px;
    color:white;
    border:1px solid rgba(255,255,255,0.18);
    background:rgba(255,255,255,0.08);
}

input[type=date]::-webkit-calendar-picker-indicator{
    filter:invert(1);
}

button{
    padding:16px 30px;
    margin:10px;
    border:none;
    border-radius:16px;
    font-size:17px;
    font-weight:700;
    color:white;
    cursor:pointer;
    background:linear-gradient(135deg,#00c6ff,#0072ff);
    transition:all .35s ease;
}

button:hover{
    transform:translateY(-4px) scale(1.05);
    box-shadow:0 0 25px rgba(0,198,255,.5);
}

.stats{
    display:flex;
    justify-content:center;
    gap:22px;
    flex-wrap:wrap;
    margin-bottom:40px;
}

.statCard{
    min-width:180px;
    padding:22px 28px;
    border-radius:20px;
    text-align:center;
    background:rgba(255,255,255,0.07);
    border:1px solid rgba(255,255,255,0.14);
    box-shadow:0 0 20px rgba(0,0,0,0.35);
}

.statCard .num{
    font-size:38px;
    font-weight:800;
    color:white;
}

.statCard .lbl{
    color:#a5b4c2;
    font-size:16px;
    margin-top:6px;
}

.green{box-shadow:0 0 25px rgba(67,233,123,.35);}
.red{box-shadow:0 0 25px rgba(255,77,109,.35);}
.cyan{box-shadow:0 0 25px rgba(0,198,255,.35);}
.yellow{box-shadow:0 0 25px rgba(255,200,60,.35);}
.pink{box-shadow:0 0 25px rgba(255,80,200,.35);}

.secTitle{
    color:white;
    font-size:26px;
    margin:35px 0 15px;
    font-weight:700;
    text-shadow:0 0 15px rgba(0,255,255,.4);
}

table{
    width:100%;
    border-collapse:collapse;
    border-radius:20px;
    overflow:hidden;
    background:rgba(255,255,255,0.05);
    box-shadow:0 0 30px rgba(255,255,255,0.04);
}

th{
    padding:18px;
    background:linear-gradient(135deg,#00c6ff,#8e2de2);
    color:white;
    font-size:18px;
    font-weight:700;
}

td{
    padding:16px;
    text-align:center;
    color:white;
    font-size:16px;
}

tr:nth-child(even){background:rgba(255,255,255,0.025);}
tr:hover{background:rgba(0,255,255,0.08);}

input[type=radio]{
    width:20px;
    height:20px;
    accent-color:#00e5ff;
    cursor:pointer;
}

.present{color:#43e97b;font-weight:700;}
.absent{color:#ff4d6d;font-weight:700;}

.linkBtn{
    display:inline-block;
    padding:9px 18px;
    border-radius:12px;
    color:white;
    text-decoration:none;
    background:linear-gradient(135deg,#00c6ff,#0072ff);
    font-weight:700;
    transition:.3s;
}

.linkBtn:hover{transform:scale(1.08);box-shadow:0 0 18px rgba(0,198,255,.6);}

.emptyMsg{
    color:#ff4d6d;
    font-size:19px;
    font-weight:bold;
    padding:25px;
    text-align:center;
}

.saveBtn{
    background:linear-gradient(135deg,#43e97b,#38f9d7);
    min-width:260px;
    font-size:20px;
}

.allBtn{
    display:inline-block;
    padding:16px 34px;
    margin:5px;
    border-radius:16px;
    font-size:18px;
    font-weight:800;
    color:white;
    text-decoration:none;
    background:linear-gradient(135deg,#ff416c,#ff4b2b);
    box-shadow:0 0 20px rgba(255,65,108,.5);
    transition:all .35s ease;
}

.allBtn:hover{
    transform:translateY(-4px) scale(1.06);
    box-shadow:0 0 35px rgba(255,65,108,.85);
}
</style>
<body>

<% if(msg!=null && !msg.trim().equals("")){ %>
<script>alert('<%= msg.replace("'","") %>');</script>
<% } %>

<div class="topBar">
<a href="index.jsp" class="navBtn">Home</a>
<a href="attendanceReport.jsp<%= (code!=null && studentCode!=null) ? "?code="+code : "" %>" class="navBtn">Full Report</a>
<a href="logout.jsp" class="navBtn">Logout</a>
</div>

<div class="card">

<h2>Attendance Dashboard</h2>

<%
String subtitle="";
if(isTeacher){
    subtitle="Class : " + session.getAttribute("teacherDepartment") + " - Semester " + session.getAttribute("teacherSemester") + " - Section " + session.getAttribute("teacherSection");
}else if(studentCode!=null){
    subtitle="Student : " + studentCode;
}else{
    subtitle="Admin Overview";
}
%>
<div class="subtitle"><%= subtitle %></div>

<div class="formArea">
<form method="get" action="attendance.jsp">
<% if(code!=null && studentCode!=null){ %>
<input type="hidden" name="code" value="<%= code %>">
<% } %>
<input type="date" name="date" value="<%= selectedDate %>">
<button type="submit">Load Date</button>
</form>
<br>
<a href="attendanceReport.jsp<%= (code!=null) ? "?code="+code : "" %>" class="allBtn">See All A/P</a>
<div style="color:#00ffcc;font-weight:bold;font-size:20px;">
Today : <%= today %>
</div>
</div>

<%
Connection con=null;
try{
    con=DBConnection.getConnection();

    if(isTeacher){
        String tSem=(String)session.getAttribute("teacherSemester");
        String tSec=(String)session.getAttribute("teacherSection");
        String tDept=(String)session.getAttribute("teacherDepartment");

        List<String[]> students=new ArrayList<>();
        PreparedStatement ps=con.prepareStatement(
            "SELECT student_code,name FROM student_details WHERE semester=? AND section=? AND department=? ORDER BY name");
        ps.setString(1,tSem);
        ps.setString(2,tSec);
        ps.setString(3,tDept);
        ResultSet rs=ps.executeQuery();
        while(rs.next()){
            students.add(new String[]{rs.getString("student_code"),rs.getString("name")});
        }
        rs.close();
        ps.close();

        Map<String,String> statusMap=new HashMap<>();
        ps=con.prepareStatement(
            "SELECT student_code,status FROM attendance WHERE att_date=? AND semester=? AND section=? AND department=?");
        ps.setString(1,selectedDate);
        ps.setString(2,tSem);
        ps.setString(3,tSec);
        ps.setString(4,tDept);
        rs=ps.executeQuery();
        while(rs.next()){
            statusMap.put(rs.getString("student_code"),rs.getString("status"));
        }
        rs.close();
        ps.close();

        int total=students.size();
        int present=0,absent=0;
        for(String st: statusMap.values()){
            if(st.equalsIgnoreCase("Present")) present++;
            else if(st.equalsIgnoreCase("Absent")) absent++;
        }
        int notMarked=total-present-absent;
        int pct=(total==0)?0:(int)Math.round(present*100.0/total);
%>

<div class="stats">
<div class="statCard cyan"><div class="num"><%= total %></div><div class="lbl">Total Students</div></div>
<div class="statCard green"><div class="num"><%= present %></div><div class="lbl">Present on <%= selectedDate %></div></div>
<div class="statCard red"><div class="num"><%= absent %></div><div class="lbl">Absent on <%= selectedDate %></div></div>
<div class="statCard yellow"><div class="num"><%= notMarked %></div><div class="lbl">Not Marked</div></div>
<div class="statCard pink"><div class="num"><%= pct %>%</div><div class="lbl">Attendance %</div></div>
</div>

<% if(total==0){ %>
<div class="emptyMsg">No students found for your class.</div>
<% }else{ %>
<div class="secTitle">Mark Attendance - <%= selectedDate %></div>
<form action="saveattendance" method="post" onsubmit="return confirm('Save attendance for <%= selectedDate %>?');">
<input type="hidden" name="semester" value="<%= tSem %>">
<input type="hidden" name="section" value="<%= tSec %>">
<input type="hidden" name="department" value="<%= tDept %>">
<input type="hidden" name="date" value="<%= selectedDate %>">
<table>
<tr><th>#</th><th>Student Code</th><th>Name</th><th>Present</th><th>Absent</th></tr>
<%
        int i=0;
        for(String[] st: students){
            i++;
            String sc=st[0];
            String savedStatus=statusMap.get(sc);
%>
<tr>
<td><%= i %></td>
<td><%= sc %></td>
<td><%= st[1] %></td>
<td><input type="radio" name="status_<%= sc %>" value="Present" <%= "Present".equalsIgnoreCase(savedStatus)?"checked":"" %> required></td>
<td><input type="radio" name="status_<%= sc %>" value="Absent" <%= "Absent".equalsIgnoreCase(savedStatus)?"checked":"" %>></td>
</tr>
<% } %>
</table>
<center><button type="submit" class="saveBtn">Save Attendance</button></center>
</form>
<% } %>

<div class="secTitle">Latest Attendance Summary</div>
<%
        PreparedStatement psDays=con.prepareStatement(
            "SELECT DISTINCT att_date FROM attendance WHERE semester=? AND section=? AND department=? ORDER BY att_date DESC LIMIT 10");
        psDays.setString(1,tSem);
        psDays.setString(2,tSec);
        psDays.setString(3,tDept);
        ResultSet rsDays=psDays.executeQuery();
        List<String> days=new ArrayList<>();
        while(rsDays.next()){
            days.add(rsDays.getString("att_date"));
        }
        rsDays.close();
        psDays.close();

        if(days.isEmpty()){
%>
<div class="emptyMsg">No attendance recorded yet. Mark today's attendance above.</div>
<% }else{ %>
<table>
<tr><th>Date</th><th>Present</th><th>Absent</th><th>Attendance %</th><th>Action</th></tr>
<%
            for(String d: days){
                int dp=0,da=0,dt=0;
                psDays=con.prepareStatement(
                    "SELECT status,COUNT(*) AS c FROM attendance WHERE att_date=? AND semester=? AND section=? AND department=? GROUP BY status");
                psDays.setString(1,d);
                psDays.setString(2,tSem);
                psDays.setString(3,tSec);
                psDays.setString(4,tDept);
                rsDays=psDays.executeQuery();
                while(rsDays.next()){
                    dt+=rsDays.getInt("c");
                    if(rsDays.getString("status").equalsIgnoreCase("Present")){
                        dp=rsDays.getInt("c");
                    }else{
                        da=rsDays.getInt("c");
                    }
                }
                rsDays.close();
                psDays.close();
                int dpct=(dt==0)?0:(int)Math.round(dp*100.0/dt);
%>
<tr>
<td><%= d %></td>
<td><%= dp %></td>
<td><%= da %></td>
<td><%= dpct %>%</td>
<td><a class="linkBtn" href="attendance.jsp?date=<%= d %>">View</a></td>
</tr>
<% } %>
</table>
<% } %>

<% } else if(studentCode!=null){ %>

<%
        PreparedStatement ps=con.prepareStatement(
            "SELECT att_date,status,marked_by FROM attendance WHERE student_code=? ORDER BY att_date DESC");
        ps.setString(1,studentCode);
        ResultSet rs=ps.executeQuery();
        List<String[]> records=new ArrayList<>();
        int present=0,absent=0;
        while(rs.next()){
            String st=rs.getString("status");
            records.add(new String[]{rs.getString("att_date"),st,rs.getString("marked_by")});
            if(st.equalsIgnoreCase("Present")) present++;
            else absent++;
        }
        rs.close();
        ps.close();
        int total=records.size();
        int pct=(total==0)?0:(int)Math.round(present*100.0/total);
%>

<div class="stats">
<div class="statCard cyan"><div class="num"><%= total %></div><div class="lbl">Days Recorded</div></div>
<div class="statCard green"><div class="num"><%= present %></div><div class="lbl">Present</div></div>
<div class="statCard red"><div class="num"><%= absent %></div><div class="lbl">Absent</div></div>
<div class="statCard pink"><div class="num"><%= pct %>%</div><div class="lbl">Attendance %</div></div>
</div>

<div class="secTitle">My Attendance Records</div>
<% if(total==0){ %>
<div class="emptyMsg">No attendance records found for your code.</div>
<% }else{ %>
<table>
<tr><th>#</th><th>Date</th><th>Status</th><th>Marked By</th></tr>
<%
        int i=0;
        for(String[] rec: records){
            i++;
%>
<tr>
<td><%= i %></td>
<td><%= rec[0] %></td>
<td class="<%= rec[1].equalsIgnoreCase("Present")?"present":"absent" %>"><%= rec[1] %></td>
<td><%= rec[2] %></td>
</tr>
<% } %>
</table>
<% } %>

<% } else if(isAdmin){ %>

<%
        PreparedStatement ps=con.prepareStatement(
            "SELECT s.student_code,s.name,s.department,s.semester,s.section,a.status " +
            "FROM student_details s " +
            "LEFT JOIN attendance a ON a.student_code=s.student_code AND a.att_date=? " +
            "ORDER BY s.department,s.semester,s.section,s.name");
        ps.setString(1,selectedDate);
        ResultSet rs=ps.executeQuery();
        List<String[]> rows=new ArrayList<>();
        int present=0,absent=0,marked=0;
        while(rs.next()){
            String st=rs.getString("status");
            rows.add(new String[]{rs.getString("student_code"),rs.getString("name"),
                rs.getString("department"),rs.getString("semester"),rs.getString("section"),
                st==null?"-":st});
            if(st!=null){
                marked++;
                if(st.equalsIgnoreCase("Present")) present++;
                else absent++;
            }
        }
        rs.close();
        ps.close();
        int total=rows.size();
        int notMarked=total-marked;
        int pct=(marked==0)?0:(int)Math.round(present*100.0/marked);
%>

<div class="stats">
<div class="statCard cyan"><div class="num"><%= total %></div><div class="lbl">Students</div></div>
<div class="statCard green"><div class="num"><%= present %></div><div class="lbl">Present on <%= selectedDate %></div></div>
<div class="statCard red"><div class="num"><%= absent %></div><div class="lbl">Absent on <%= selectedDate %></div></div>
<div class="statCard yellow"><div class="num"><%= notMarked %></div><div class="lbl">Not Marked</div></div>
<div class="statCard pink"><div class="num"><%= pct %>%</div><div class="lbl">Attendance %</div></div>
</div>

<div class="secTitle">Attendance Overview - <%= selectedDate %></div>
<table>
<tr><th>Student Code</th><th>Name</th><th>Department</th><th>Semester</th><th>Section</th><th>Status</th></tr>
<%
        for(String[] r: rows){
%>
<tr>
<td><%= r[0] %></td>
<td><%= r[1] %></td>
<td><%= r[2] %></td>
<td><%= r[3] %></td>
<td><%= r[4] %></td>
<td class="<%= r[5].equals("Present")?"present":(r[5].equals("Absent")?"absent":"") %>"><%= r[5] %></td>
</tr>
<% } %>
</table>

<% } %>

<%
}catch(Exception e){
    out.println("<div class='emptyMsg'>Error : "+e+"</div>");
}finally{
    if(con!=null){
        try{ con.close(); }catch(Exception e){}
    }
}
%>

</div>
</body>
</html>
