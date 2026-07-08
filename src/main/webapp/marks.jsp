<%@ page import="java.sql.*" %>
<%@ page import="utils.DBConnection" %>

<%
response.setHeader("Cache-Control","no-cache,no-store,must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires",0);

String user=(String)session.getAttribute("user");
String admin=(String)session.getAttribute("admin");

if(user==null){
    response.sendRedirect("login.jsp");
    return;
}
%>

<html>
<head>
<title>Marks Card</title>

<style>
*{box-sizing:border-box;}

body{
    margin:0;
    padding:40px;
    font-family:Arial,sans-serif;
    min-height:100vh;
    background:
        radial-gradient(circle at top left, rgba(255,255,255,0.15), transparent 35%),
        radial-gradient(circle at bottom right, rgba(255,255,255,0.12), transparent 35%),
        linear-gradient(135deg,#111827,#000000);
}

.card{
    width:600px;
    max-width:95%;
    margin:auto;
    padding:35px;
    border-radius:30px;
    background:rgba(255,255,255,0.06);
    backdrop-filter:blur(20px);
    border:1px solid rgba(255,255,255,0.12);
    box-shadow:
        0 0 40px rgba(255,255,255,0.10),
        inset 0 0 20px rgba(255,255,255,0.04);
}

h2{
    text-align:center;
    color:white;
    font-size:38px;
    margin-bottom:20px;
}

table{
    width:100%;
    border-collapse:collapse;
    border-radius:18px;
    overflow:hidden;
}

td{
    padding:16px;
    border-bottom:1px solid rgba(255,255,255,0.1);
}

.subject{
    font-weight:bold;
    color:white;
}

.mark{
    color:#38f9d7;
    font-weight:bold;
    text-align:center;
}

.download,.updateBtn,.backBtn{
    display:block;
    width:200px;
    margin:18px auto;
    text-align:center;
    padding:14px;
    color:white;
    text-decoration:none;
    border-radius:14px;
    font-weight:bold;
}

.download{background:linear-gradient(135deg,#43e97b,#38f9d7);}
.updateBtn{background:linear-gradient(135deg,#f7971e,#ffd200);}
.backBtn{background:linear-gradient(135deg,#36d1dc,#5b86e5);}

.result-pass{
    color:#43e97b;
    font-size:34px;
    text-align:center;
}

.result-fail{
    color:#ff416c;
    font-size:34px;
    text-align:center;
}
</style>
</head>

<body>

<div class="card">
<h2>Student Marks Card</h2>

<%
String code = request.getParameter("code");

try{
    Connection con = DBConnection.getConnection();

    PreparedStatement ps =
        con.prepareStatement("SELECT * FROM marks_card WHERE student_code=?");

    ps.setString(1,code);

    ResultSet rs = ps.executeQuery();

    if(rs.next()){

        int s1 = rs.getInt("sub1");
        int s2 = rs.getInt("sub2");
        int s3 = rs.getInt("sub3");
        int s4 = rs.getInt("sub4");
        int s5 = rs.getInt("sub5");
        int s6 = rs.getInt("sub6");

        int total = s1+s2+s3+s4+s5+s6;
        double percentage = total/6.0;
        double sgpa = percentage/10.0;

        boolean pass =
            (s1>=36 && s2>=36 && s3>=36 &&
             s4>=36 && s5>=36 && s6>=36);
%>

<table>
<tr><td class="subject">Student Code</td><td class="mark"><%= code %></td></tr>

<tr><td class="subject">ENGLISH</td><td class="mark"><%= s1 %> <%= s1>=36?"P":"F" %></td></tr>
<tr><td class="subject">KANNADA</td><td class="mark"><%= s2 %> <%= s2>=36?"P":"F" %></td></tr>
<tr><td class="subject">HINDI</td><td class="mark"><%= s3 %> <%= s3>=36?"P":"F" %></td></tr>
<tr><td class="subject">SOCIAL</td><td class="mark"><%= s4 %> <%= s4>=36?"P":"F" %></td></tr>
<tr><td class="subject">SCIENCE</td><td class="mark"><%= s5 %> <%= s5>=36?"P":"F" %></td></tr>
<tr><td class="subject">MATHS</td><td class="mark"><%= s6 %> <%= s6>=36?"P":"F" %></td></tr>

<tr><td class="subject">TOTAL</td><td class="mark"><%= total %>/600</td></tr>
<tr><td class="subject">PERCENTAGE</td><td class="mark"><%= String.format("%.2f",percentage) %>%</td></tr>
<tr><td class="subject">SGPA</td><td class="mark"><%= String.format("%.2f",sgpa) %></td></tr>
</table>

<% if(pass){ %>
<h2 class="result-pass">PASS</h2>
<% } else { %>
<h2 class="result-fail">FAIL</h2>
<% } %>

<% if(admin != null){ %>
<a class="updateBtn" href="addmarks.jsp?code=<%= code %>">
Update Marks
</a>
<% } %>

<a class="download" href="javascript:window.print()">Download PDF</a>
<a href="index.jsp" class="backBtn">Back</a>

<%
    } else {
%>

<h2 style="color:red;">No marks found</h2>
<a href="index.jsp" class="backBtn">Back</a>

<% if(admin != null){ %>
<a class="updateBtn" href="addmarks.jsp?code=<%= code %>">
Add Marks
</a>
<% } %>

<%
    }

    con.close();

}catch(Exception e){
    out.println(e);
}
%>

</div>
</body>
</html>