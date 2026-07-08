<%@ page import="java.sql.*" %>
<%@ page import="utils.DBConnection" %>

<%
String user=(String)session.getAttribute("user");
String admin=(String)session.getAttribute("admin");

if(user==null || admin==null){
    response.sendRedirect("login.jsp");
    return;
}

int id=Integer.parseInt(request.getParameter("id"));
String fullname="";

try{
    Connection con=DBConnection.getConnection();

    PreparedStatement ps=
        con.prepareStatement("SELECT fullname FROM students WHERE id=?");

    ps.setInt(1,id);

    ResultSet rs=ps.executeQuery();

    if(rs.next()){
        fullname=rs.getString("fullname");
    }

    con.close();

}catch(Exception e){
    out.println(e);
}
%>

<html>
<head>
<title>Update Student</title>

<style>
*{
    box-sizing:border-box;
}

body{
    margin:0;
    font-family:Arial,sans-serif;
    min-height:100vh;
    background:
        radial-gradient(circle at top left, rgba(255,255,255,0.15), transparent 35%),
        radial-gradient(circle at bottom right, rgba(255,255,255,0.12), transparent 35%),
        linear-gradient(135deg,#111827,#000000);
    display:flex;
    justify-content:center;
    align-items:center;
}

.card{
    width:460px;
    max-width:95%;
    padding:35px;
    border-radius:30px;
    text-align:center;
    background:rgba(255,255,255,0.06);
    backdrop-filter:blur(20px);
    border:1px solid rgba(255,255,255,0.12);
    box-shadow:
        0 0 40px rgba(255,255,255,0.10),
        inset 0 0 20px rgba(255,255,255,0.04);
    transition:all 0.4s ease;
}

.card:hover{
    box-shadow:
        0 0 60px rgba(0,255,255,0.12),
        0 0 100px rgba(255,255,255,0.08);
}

h2{
    color:white;
    font-size:36px;
    margin-bottom:25px;
    text-shadow:0 0 18px rgba(255,255,255,0.7);
}

input[type=text]{
    width:100%;
    padding:15px;
    margin-top:20px;
    border-radius:14px;
    border:1px solid rgba(255,255,255,0.20);
    background:rgba(255,255,255,0.10);
    color:white;
    backdrop-filter:blur(10px);
    font-size:18px;
    transition:all 0.35s ease;
}

input[type=text]:hover{
    transform:translateY(-2px);
    box-shadow:0 0 16px rgba(0,255,255,0.20);
}

input[type=text]:focus{
    outline:none;
    border-color:#00e5ff;
    box-shadow:
        0 0 12px #00e5ff,
        0 0 30px rgba(0,229,255,0.35);
}

input[type=submit]{
    width:100%;
    margin-top:25px;
    padding:15px;
    background:linear-gradient(135deg,#f7971e,#ffd200);
    color:white;
    border:none;
    border-radius:14px;
    font-size:18px;
    font-weight:bold;
    cursor:pointer;
    transition:all 0.35s ease;
}

input[type=submit]:hover{
    transform:translateY(-4px) scale(1.03);
    box-shadow:
        0 0 20px rgba(255,210,0,0.45),
        0 0 40px rgba(247,151,30,0.25);
}

.mainbtn1{
    display:block;
    margin-top:18px;
    padding:15px;
    text-decoration:none;
    color:white;
    font-weight:bold;
    border-radius:14px;
    background:linear-gradient(135deg,#36d1dc,#5b86e5);
    transition:all 0.35s ease;
}

.mainbtn1:hover{
    transform:translateY(-4px) scale(1.03);
    box-shadow:
        0 0 20px rgba(91,134,229,0.45),
        0 0 40px rgba(54,209,220,0.25);
}
</style>
</head>

<body>

<div class="card">
<h2>Update Student Name</h2>

<form action="update" method="post">
    <input type="hidden" name="id" value="<%= id %>">

    <input type="text"
           name="msg"
           value="<%= fullname %>"
           required>

    <input type="submit" value="Update" >
    <a href="index.jsp" class="mainbtn1">Back</a>
    
</form>
</div>

</body>
</html>