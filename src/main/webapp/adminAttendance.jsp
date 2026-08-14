<%@ page import="java.sql.*" %>
<%@ page import="utils.DBConnection" %>
<%@ page import="java.util.*" %>
<%
String user=(String)session.getAttribute("user");
String admin=(String)session.getAttribute("admin");

if(user==null || admin==null){
    response.sendRedirect("login.jsp");
    return;
}

String dept=request.getParameter("department");
String sem=request.getParameter("semester");
String sec=request.getParameter("section");
String dateParam=request.getParameter("date");

boolean filtered=(dept!=null && !dept.trim().equals("") && sem!=null && !sem.trim().equals(""));
boolean withDate=(dateParam!=null && !dateParam.trim().equals(""));
boolean withSec=(sec!=null && !sec.trim().equals(""));

List<String> departments=new ArrayList<>();
List<String> semesters=new ArrayList<>();
List<String> sections=new ArrayList<>();
%>
<html>
<head>
<title>Admin Attendance Report</title>
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

.filterCard{
    max-width:900px;
    margin:0 auto 35px;
    padding:30px;
    border-radius:22px;
    background:rgba(255,255,255,0.05);
    border:1px solid rgba(255,255,255,0.14);
    box-shadow:0 0 25px rgba(0,198,255,.15);
    text-align:center;
}

select,input[type=date]{
    min-width:200px;
    padding:15px 20px;
    margin:8px;
    border-radius:15px;
    font-size:16px;
    color:white;
    border:1px solid rgba(255,255,255,0.18);
    background:rgba(255,255,255,0.08);
}

select option{color:black;}

input[type=date]::-webkit-calendar-picker-indicator{
    filter:invert(1);
}

button{
    padding:15px 30px;
    margin:10px;
    border:none;
    border-radius:15px;
    font-size:16px;
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

.secNote{
    color:#9ae6ff;
    font-size:16px;
    margin-top:8px;
}

.stats{
    display:flex;
    justify-content:center;
    gap:22px;
    flex-wrap:wrap;
    margin:0 0 30px;
}

.statCard{
    min-width:160px;
    padding:20px 26px;
    border-radius:20px;
    text-align:center;
    background:rgba(255,255,255,0.07);
    border:1px solid rgba(255,255,255,0.14);
}

.statCard .num{
    font-size:34px;
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
.yellow{box-shadow:0 0 25px rgba(255,200,60,.35);}
.pink{box-shadow:0 0 25px rgba(255,80,200,.35);}

.secTitle{
    color:white;
    font-size:24px;
    margin:0 0 15px;
    font-weight:700;
    text-align:center;
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
    padding:17px;
    background:linear-gradient(135deg,#00c6ff,#8e2de2);
    color:white;
    font-size:17px;
    font-weight:700;
}

td{
    padding:15px;
    text-align:center;
    color:white;
    font-size:16px;
}

tr:nth-child(even){background:rgba(255,255,255,0.025);}
tr:hover{background:rgba(0,255,255,0.08);}

.present{color:#43e97b;font-weight:700;}
.absent{color:#ff4d6d;font-weight:700;}
.notMarked{color:#ffc83c;font-weight:700;}

.emptyMsg{
    color:#ff4d6d;
    font-size:19px;
    font-weight:bold;
    padding:25px;
    text-align:center;
}
</style>
<body>

<%
try{
    Connection con=DBConnection.getConnection();

    PreparedStatement psD=con.prepareStatement(
        "SELECT DISTINCT department FROM student_details WHERE department IS NOT NULL AND department<>'' ORDER BY department");
    ResultSet rsD=psD.executeQuery();
    while(rsD.next()) departments.add(rsD.getString("department"));
    rsD.close();
    psD.close();

    PreparedStatement psS=con.prepareStatement(
        "SELECT DISTINCT semester FROM student_details WHERE semester IS NOT NULL AND semester<>'' ORDER BY CAST(semester AS UNSIGNED)");
    ResultSet rsS=psS.executeQuery();
    while(rsS.next()) semesters.add(rsS.getString("semester"));
    rsS.close();
    psS.close();

    PreparedStatement psC=con.prepareStatement(
        "SELECT DISTINCT section FROM student_details WHERE section IS NOT NULL AND section<>'' ORDER BY section");
    ResultSet rsC=psC.executeQuery();
    while(rsC.next()) sections.add(rsC.getString("section"));
    rsC.close();
    psC.close();

    con.close();
}catch(Exception e){}
%>

<div class="topBar">
<a href="index.jsp" class="backBtn">&#8592; Back to Admin Dashboard</a>
<a href="logout.jsp" class="navBtn">Logout</a>
</div>

<div class="card">

<h2>Admin Attendance Report</h2>

<div class="filterCard">
<form method="get" action="adminAttendance.jsp">

<select name="department" required>
<option value="">-- Department (Required) --</option>
<% for(String d: departments){ %>
<option value="<%= d %>" <%= d.equals(dept) ? "selected" : "" %>><%= d %></option>
<% } %>
</select>

<select name="semester" required>
<option value="">-- Semester (Required) --</option>
<% for(String s: semesters){ %>
<option value="<%= s %>" <%= s.equals(sem) ? "selected" : "" %>><%= s %></option>
<% } %>
</select>

<select name="section">
<option value="">-- Section (Optional) --</option>
<% for(String sc: sections){ %>
<option value="<%= sc %>" <%= sc.equals(sec) ? "selected" : "" %>><%= sc %></option>
<% } %>
</select>

<input type="date" name="date" value="<%= dateParam==null ? "" : dateParam %>">

<br>
<button type="submit">Show Attendance Report</button>
<div class="secNote">Department &amp; Semester are required. Section is optional - leave empty to see all sections.</div>

</form>
</div>

<%
if(filtered){
%>

<%
Connection con=null;
try{
    con=DBConnection.getConnection();

    String baseFrom=" FROM student_details s ";
    String where=" WHERE s.department=? AND s.semester=? ";
    List<String> params=new ArrayList<>();

    if(withDate){
        params.add(dateParam);
    }

    params.add(dept);
    params.add(sem);

    if(withSec){
        where+="AND s.section=? ";
        params.add(sec);
    }

    if(withDate){
        baseFrom+="LEFT JOIN attendance a ON a.student_code=s.student_code AND a.att_date=? ";
    }else{
        baseFrom+="LEFT JOIN attendance a ON a.student_code=s.student_code ";
    }

    StringBuilder sql=new StringBuilder();

    if(withDate){
        sql.append("SELECT s.student_code,s.name,s.section,IFNULL(a.status,'Not Marked') AS status ");
        sql.append(baseFrom);
        sql.append(where);
        sql.append("ORDER BY s.section,s.name");
    }else{
        sql.append("SELECT s.student_code,s.name,s.section,a.att_date,IFNULL(a.status,'-') AS status,a.marked_by ");
        sql.append(baseFrom);
        sql.append(where);
        sql.append("ORDER BY s.section,s.name,a.att_date DESC");
    }

    PreparedStatement ps=con.prepareStatement(sql.toString());

    int i=1;
    for(String p: params){
        ps.setString(i++,p);
    }

    ResultSet rs=ps.executeQuery();

    List<String[]> rows=new ArrayList<>();
    int total=0,present=0,absent=0,notMarked=0;

    while(rs.next()){

        String st=rs.getString("status");

        if(withDate){

            total++;

            if(st.equals("Present")) present++;
            else if(st.equals("Absent")) absent++;
            else notMarked++;

            rows.add(new String[]{rs.getString("student_code"),rs.getString("name"),
                rs.getString("section"),st,""});

        }else{

            rows.add(new String[]{rs.getString("student_code"),rs.getString("name"),
                rs.getString("section"),String.valueOf(rs.getDate("att_date")),st,
                rs.getString("marked_by")});

            if(st.equals("Present")) present++;
            else if(st.equals("Absent")) absent++;
        }
    }

    rs.close();
    ps.close();

    String scopeLabel="Department : "+dept+" , Semester : "+sem+(withSec?(" , Section : "+sec):" , All Sections");

    if(withDate){
        scopeLabel+=" , Date : "+dateParam;
    }

    int totalRecords=(withDate?total:rows.size());
    int pct=(totalRecords==0)?0:(int)Math.round(present*100.0/totalRecords);
%>

<div class="secTitle"><%= scopeLabel %></div>

<div class="stats">
<div class="statCard cyan"><div class="num"><%= totalRecords %></div><div class="lbl"><%= withDate ? "Students" : "Total Records" %></div></div>
<div class="statCard green"><div class="num"><%= present %></div><div class="lbl">Present</div></div>
<div class="statCard red"><div class="num"><%= absent %></div><div class="lbl">Absent</div></div>
<% if(withDate){ %>
<div class="statCard yellow"><div class="num"><%= notMarked %></div><div class="lbl">Not Marked</div></div>
<% } %>
<div class="statCard pink"><div class="num"><%= pct %>%</div><div class="lbl">Attendance %</div></div>
</div>

<% if(rows.isEmpty()){ %>
<div class="emptyMsg">No students found for the selected filters.</div>
<% }else{ %>

<table>
<% if(withDate){ %>
<tr><th>Student Code</th><th>Name</th><th>Section</th><th>Status</th></tr>
<% }else{ %>
<tr><th>Student Code</th><th>Name</th><th>Section</th><th>Date</th><th>Status</th><th>Marked By</th></tr>
<% } %>

<%
    for(String[] r: rows){
        String st = withDate ? r[3] : r[4];
        String css=(st.equals("Present"))?"present":(st.equals("Absent")?"absent":(st.equals("Not Marked")?"notMarked":""));
%>
<tr>
<td><%= r[0] %></td>
<td><%= r[1] %></td>
<td><%= r[2] %></td>
<% if(!withDate){ %><td><%= r[3] %></td><% } %>
<td class="<%= css %>"><%= st %></td>
<% if(!withDate){ %><td><%= r[5] %></td><% } %>
</tr>
<% } %>
</table>

<% } %>

<%
}catch(Exception e){
    out.println("<div class='emptyMsg'>Error : "+e+"</div>");
}finally{
    if(con!=null){
        try{ con.close(); }catch(Exception ex){}
    }
}
%>

<% } %>

</div>
</body>
</html>
