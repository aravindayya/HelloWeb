<%@ page import="java.sql.*" %>

<%
String code = request.getParameter("code");
%>

<%
if(session.getAttribute("user") != null){
%>
<a class="updateBtn" href="adddetails.jsp?code=<%= code %>">
    Update Details
</a>
<%
}
%>

<html>
<head>
<title>Student Details</title>

<style>
body{
    margin:0;
    padding:30px;
    font-family:Arial,sans-serif;
    min-height:100vh;
    background:
    radial-gradient(circle at top left, rgba(255,255,255,0.15), transparent 35%),
    radial-gradient(circle at bottom right, rgba(255,255,255,0.12), transparent 35%),
    linear-gradient(135deg,#111827,#000000);
}

.container{
    width:760px;
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
    transition:all 0.4s ease;
}

.container:hover{
    box-shadow:
        0 0 60px rgba(0,255,255,0.12),
        0 0 100px rgba(255,255,255,0.08);
}

.updateBtn{
    display:inline-block;
    margin:20px;
    padding:14px 22px;
    background:linear-gradient(135deg,#f7971e,#ffd200);
    color:white;
    text-decoration:none;
    border-radius:12px;
    font-weight:bold;
    transition:all 0.35s ease;
}

.updateBtn:hover{
    transform:translateY(-4px) scale(1.06);
}

h2{
    text-align:center;
    color:white;
    font-size:40px;
    margin-bottom:30px;
}

.details-row{
    display:flex;
    justify-content:space-between;
    padding:16px 20px;
    margin:12px 0;
    background:rgba(255,255,255,0.08);
    border-left:5px solid #00e5ff;
    border-radius:14px;
}

.label{
    font-weight:bold;
    color:white;
}

.value{
    color:#e0e0e0;
}

.btn{
    display:block;
    width:180px;
    margin:30px auto 0;
    text-align:center;
    background:linear-gradient(135deg,#43e97b,#38f9d7);
    color:white;
    padding:14px;
    text-decoration:none;
    border-radius:12px;
    font-weight:bold;
}

.no-data{
    text-align:center;
    color:#ff4b4b;
    font-size:24px;
    font-weight:bold;
}
</style>
</head>

<body>
<div class="container">
<h2>Student Details</h2>

<%
try{
    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/studentdb1",
        "root",
        "Aravind@1727"
    );

    PreparedStatement ps = con.prepareStatement(
        "SELECT * FROM student_details WHERE student_code=?"
    );

    ps.setString(1, code);
    ResultSet rs = ps.executeQuery();

    if(rs.next()){
%>

<div class="details-row">
<span class="label">Student Code:</span>
<span class="value"><%= rs.getString("student_code") %></span>
</div>

<div class="details-row">
<span class="label">Reg Number:</span>
<span class="value"><%= rs.getString("reg_no") %></span>
</div>

<div class="details-row">
<span class="label">Name:</span>
<span class="value"><%= rs.getString("name") %></span>
</div>

<div class="details-row">
<span class="label">College Name:</span>
<span class="value"><%= rs.getString("college_name") %></span>
</div>

<div class="details-row">
<span class="label">Department:</span>
<span class="value"><%= rs.getString("department") %></span>
</div>

<div class="details-row">
<span class="label">Semester:</span>
<span class="value"><%= rs.getString("semester") %></span>
</div>

<div class="details-row">
<span class="label">Section:</span>
<span class="value"><%= rs.getString("section") %></span>
</div>

<div class="details-row">
<span class="label">DOB:</span>
<span class="value"><%= rs.getString("dob") %></span>
</div>

<div class="details-row">
<span class="label">Blood Group:</span>
<span class="value"><%= rs.getString("blood_group") %></span>
</div>

<div class="details-row">
<span class="label">Gender:</span>
<span class="value"><%= rs.getString("gender") %></span>
</div>

<div class="details-row">
<span class="label">Mobile:</span>
<span class="value"><%= rs.getString("mobile") %></span>
</div>

<div class="details-row">
<span class="label">Phone:</span>
<span class="value"><%= rs.getString("phone") %></span>
</div>

<div class="details-row">
<span class="label">Address:</span>
<span class="value"><%= rs.getString("address") %></span>
</div>

<div class="details-row">
<span class="label">Category:</span>
<span class="value"><%= rs.getString("category") %></span>
</div>

<div class="details-row">
<span class="label">Nationality:</span>
<span class="value"><%= rs.getString("nationality") %></span>
</div>

<div class="details-row">
<span class="label">Admission Year:</span>
<span class="value"><%= rs.getString("admission_year") %></span>
</div>

<div class="details-row">
<span class="label">Parent Name:</span>
<span class="value"><%= rs.getString("parent_name") %></span>
</div>

<div class="details-row">
<span class="label">Parent Phone:</span>
<span class="value"><%= rs.getString("parent_phone") %></span>
</div>

<div class="details-row">
<span class="label">Parent Blood Group:</span>
<span class="value"><%= rs.getString("parent_blood_group") %></span>
</div>

<%
    } else {
%>

<div class="no-data">No Details Found</div>
<a class="btn" href="adddetails.jsp?code=<%= code %>">Add Details</a>

<%
    }

    rs.close();
    ps.close();
    con.close();

}catch(Exception e){
    out.println("Error: " + e.getMessage());
}
%>

<a class="btn" href="index.jsp">Back</a>

</div>
</body>
</html>