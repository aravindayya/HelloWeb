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

boolean isTeacher=(teacher!=null);
boolean isAdmin=(admin!=null);

String code=request.getParameter("code");
if(code==null || code.trim().equals("")){
    code=studentCode;
}

String dateParam=request.getParameter("date");

boolean seeAll=(dateParam==null || dateParam.trim().equals(""));

String selectedDate=dateParam;

if(!seeAll && (selectedDate==null || selectedDate.trim().equals(""))){
    selectedDate=LocalDate.now().toString();
}
%>
<html>
<head>
<title>Attendance Report</title>
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

.backBtn{
    display:inline-block;
    background:linear-gradient(135deg,#43e97b,#38f9d7);
    color:#003322;
    text-decoration:none;
    padding:15px 30px;
    border-radius:15px;
    font-size:20px;
    font-weight:800;
    box-shadow:0 0 20px rgba(67,233,123,.45);
    transition:all .3s ease;
}

.backBtn:hover{
    transform:translateY(-4px) scale(1.06);
    box-shadow:0 0 30px rgba(67,233,123,.8);
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
    font-size:44px;
    margin-bottom:25px;
    font-weight:800;
    text-shadow:0 0 25px rgba(255,255,255,.85), 0 0 50px rgba(0,255,255,.25);
}

.formArea{
    text-align:center;
    margin-bottom:30px;
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

.allBtn{
    display:inline-block;
    padding:16px 34px;
    margin:10px;
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

.stats{
    display:flex;
    justify-content:center;
    gap:22px;
    flex-wrap:wrap;
    margin:20px 0 35px;
}

.statCard{
    min-width:170px;
    padding:20px 26px;
    border-radius:20px;
    text-align:center;
    background:rgba(255,255,255,0.07);
    border:1px solid rgba(255,255,255,0.14);
}

.statCard .num{
    font-size:36px;
    font-weight:800;
    color:white;
}

.statCard .lbl{
    color:#a5b4c2;
    font-size:15px;
    margin-top:6px;
}

.green{box-shadow:0 0 25px rgba(67,233,123,.35);}
.red{box-shadow:0 0 25px rgba(255,77,109,.35);}
.cyan{box-shadow:0 0 25px rgba(0,198,255,.35);}
.pink{box-shadow:0 0 25px rgba(255,80,200,.35);}

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

.present{color:#43e97b;font-weight:700;}
.absent{color:#ff4d6d;font-weight:700;}

.emptyMsg{
    color:#ff4d6d;
    font-size:19px;
    font-weight:bold;
    padding:25px;
    text-align:center;
}
</style>
<body>

<div class="topBar">
<a href="attendance.jsp<%= (code!=null && studentCode!=null) ? "?code="+code : "" %>" class="backBtn">&#8592; Back to Dashboard</a>
<a href="index.jsp" class="navBtn">Home</a>
<a href="logout.jsp" class="navBtn">Logout</a>
</div>

<div class="card">

<h2>Attendance Report</h2>

<div class="formArea">
<form method="get" action="attendanceReport.jsp">
<% if(code!=null){ %>
<input type="hidden" name="code" value="<%= code %>">
<% } %>
<input type="date" name="date" value="<%= seeAll ? "" : selectedDate %>">
<button type="submit">Load Date</button>
</form>
<a href="attendanceReport.jsp<%= (code!=null) ? "?code="+code : "" %>" class="allBtn">See All A/P</a>
</div>

<%
Connection con=null;

try{
    con=DBConnection.getConnection();

    String baseSelect =
        "SELECT a.att_date,a.student_code,s.name,s.department,s.semester,s.section,a.status,a.marked_by " +
        "FROM attendance a JOIN student_details s ON a.student_code=s.student_code ";

    PreparedStatement ps;
    String where="";
    String order="";

    if(isAdmin){

        if(code!=null && !code.equals("")){

            if(seeAll){
                where="WHERE a.student_code=?";
                order="ORDER BY a.att_date DESC,s.name";
            }else{
                where="WHERE a.att_date=? AND a.student_code=?";
                order="ORDER BY s.name";
            }

        }else{

            if(seeAll){
                where="WHERE 1=1";
                order="ORDER BY a.att_date DESC,s.department,s.semester,s.section,s.name";
            }else{
                where="WHERE a.att_date=?";
                order="ORDER BY s.department,s.semester,s.section,s.name";
            }
        }

    }else if(isTeacher){

        String tSem=(String)session.getAttribute("teacherSemester");
        String tSec=(String)session.getAttribute("teacherSection");
        String tDept=(String)session.getAttribute("teacherDepartment");

        if(code!=null && !code.equals("")){

            if(seeAll){
                where="WHERE a.student_code=?";
                order="ORDER BY a.att_date DESC,s.name";
            }else{
                where="WHERE a.att_date=? AND a.student_code=?";
                order="ORDER BY s.name";
            }

        }else{

            if(seeAll){
                where="WHERE s.department=? AND s.semester=? AND s.section=?";
                order="ORDER BY a.att_date DESC,s.name";
            }else{
                where="WHERE a.att_date=? AND s.department=? AND s.semester=? AND s.section=?";
                order="ORDER BY s.name";
            }
        }

    }else{

        if(seeAll){
            where="WHERE a.student_code=?";
            order="ORDER BY a.att_date DESC";
        }else{
            where="WHERE a.att_date=? AND a.student_code=?";
            order="ORDER BY a.att_date DESC";
        }
    }

    ps=con.prepareStatement(baseSelect+where+" "+order);

    int idx=1;

    if(seeAll){

        if(isTeacher && code==null){
            ps.setString(idx++,(String)session.getAttribute("teacherDepartment"));
            ps.setString(idx++,(String)session.getAttribute("teacherSemester"));
            ps.setString(idx++,(String)session.getAttribute("teacherSection"));
        }else if(!isAdmin || code!=null){
            ps.setString(idx++,code!=null?code:studentCode);
        }

    }else{

        ps.setString(idx++,selectedDate);

        if(isTeacher && code==null){
            ps.setString(idx++,(String)session.getAttribute("teacherDepartment"));
            ps.setString(idx++,(String)session.getAttribute("teacherSemester"));
            ps.setString(idx++,(String)session.getAttribute("teacherSection"));
        }else if(code!=null || !isAdmin){
            ps.setString(idx++,code!=null?code:studentCode);
        }
    }

    ResultSet rs=ps.executeQuery();

    List<String[]> rows=new ArrayList<>();
    int total=0,present=0,absent=0;

    while(rs.next()){

        String status=rs.getString("status");
        rows.add(new String[]{
            String.valueOf(rs.getDate("att_date")),
            rs.getString("student_code"),
            rs.getString("name"),
            rs.getString("department"),
            rs.getString("semester"),
            rs.getString("section"),
            status,
            rs.getString("marked_by")
        });

        total++;

        if(status.equals("Present")){
            present++;
        }else{
            absent++;
        }
    }

    rs.close();
    ps.close();
%>

<% if(seeAll){ %>
<div class="stats">
<div class="statCard cyan"><div class="num"><%= total %></div><div class="lbl">Total Records</div></div>
<div class="statCard green"><div class="num"><%= present %></div><div class="lbl">Present</div></div>
<div class="statCard red"><div class="num"><%= absent %></div><div class="lbl">Absent</div></div>
<div class="statCard pink"><div class="num"><%= (total==0)?0:(int)Math.round(present*100.0/total) %>%</div><div class="lbl">Attendance %</div></div>
</div>
<h2 style="font-size:28px;text-shadow:0 0 15px rgba(255,255,255,.5);margin-bottom:15px;">All Present / Absent Records</h2>
<% }else{ %>
<h2 style="font-size:28px;text-shadow:0 0 15px rgba(255,255,255,.5);margin-bottom:15px;">Records For <%= selectedDate %></h2>
<% } %>

<table>
<tr>
<th>Date</th>
<th>Student Code</th>
<th>Name</th>
<th>Department</th>
<th>Semester</th>
<th>Section</th>
<th>Status</th>
<th>Marked By</th>
</tr>

<%
    if(rows.isEmpty()){
%>
<tr><td colspan="8" class="emptyMsg"><%= seeAll ? "No attendance records found." : "No Attendance Found For "+selectedDate %></td></tr>
<%
    }else{
        for(String[] r: rows){
%>
<tr>
<td><%= r[0] %></td>
<td><%= r[1] %></td>
<td><%= r[2] %></td>
<td><%= r[3] %></td>
<td><%= r[4] %></td>
<td><%= r[5] %></td>
<td class="<%= r[6].equals("Present") ? "present" : "absent" %>"><%= r[6] %></td>
<td><%= r[7] %></td>
</tr>
<% } } %>

</table>

<%
}catch(Exception e){
    out.println("<div class='emptyMsg'>Error : "+e+"</div>");
}finally{
    if(con!=null){
        try{ con.close(); }catch(Exception ex){}
    }
}
%>

</div>
</body>
</html>
