<%@ page import="java.sql.*" %>
<%@ page import="utils.DBConnection" %>

<%
int id = Integer.parseInt(request.getParameter("id"));

Connection con = DBConnection.getConnection();

PreparedStatement ps =
    con.prepareStatement("SELECT * FROM students WHERE id=?");

ps.setInt(1,id);

ResultSet rs = ps.executeQuery();

if(!rs.next()){
    out.println("Student not found");
    return;
}
%>

<html>
<head>
<style>
body{
    margin:0;
    font-family:Arial;
    background:linear-gradient(135deg,#74ebd5,#ACB6E5);
}

.card{
    width:700px;
    margin:120px auto;
    background:#fff;
    padding:40px;
    border-radius:25px;
    box-shadow:0 8px 30px rgba(0,0,0,0.25);
}

h2{
    text-align:center;
    font-size:50px;
}

input{
    width:100%;
    padding:15px;
    margin:10px 0;
    border:1px solid #ccc;
    border-radius:10px;
    font-size:20px;
}

button{
    width:100%;
    padding:16px;
    margin-top:20px;
    background:orange;
    color:white;
    border:none;
    border-radius:10px;
    font-size:24px;
}
</style>
</head>
<body>

<div class="card">
<h2>Update Details</h2>

<form action="updatedetails" method="post">

<input type="hidden" name="id" value="<%= id %>">

<input type="text"
       name="fullname"
       value="<%= rs.getString("fullname") %>"
       required>

<input type="text"
       name="phone"
       value="<%= rs.getString("phone") %>"
       required>

<input type="email"
       name="email"
       value="<%= rs.getString("email") %>"
       required>

<input type="text"
       name="regno"
       value="<%= rs.getString("regno") %>"
       required>

<button type="submit">Update</button>

</form>
</div>

</body>
</html>