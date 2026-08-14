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

String code = request.getParameter("code");

boolean isAdmin = session.getAttribute("admin") != null;
boolean isTeacher = session.getAttribute("teacher") != null;
String myCode = (String) session.getAttribute("studentCode");

if(code==null || code.trim().equals("")){
    response.sendRedirect("index.jsp");
    return;
}

if(!isAdmin && !isTeacher && (myCode==null || !myCode.equals(code))){
    response.sendRedirect("index.jsp");
    return;
}

String reg="", name="", college="", department="", semester="";
String section="", dob="", blood="", gender="";
String mobile="", phone="", address="", category="";
String nationality="", year="", parentName="";
String parentPhone="", parentBlood="";

try{
    Connection con = DBConnection.getConnection();

    PreparedStatement ps =
        con.prepareStatement("SELECT * FROM student_details WHERE student_code=?");

    ps.setString(1, code);

    ResultSet rs = ps.executeQuery();

    if(rs.next()){
        reg = rs.getString("reg_no");
        name = rs.getString("name");
        college = rs.getString("college_name");
        department = rs.getString("department");
        semester = rs.getString("semester");
        section = rs.getString("section");
        dob = rs.getString("dob");
        blood = rs.getString("blood_group");
        gender = rs.getString("gender");
        mobile = rs.getString("mobile");
        phone = rs.getString("phone");
        address = rs.getString("address");
        category = rs.getString("category");
        nationality = rs.getString("nationality");
        year = rs.getString("admission_year");
        parentName = rs.getString("parent_name");
        parentPhone = rs.getString("parent_phone");
        parentBlood = rs.getString("parent_blood_group");
    }

    rs.close();
    ps.close();
    con.close();
}catch(Exception e){
    out.println(e);
}
%>

<html>
<head>
<title>Add Details</title>

<style>
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:Arial,sans-serif;
}

body{
    padding:30px 0;
    min-height:100vh;
    background:
        radial-gradient(circle at top left, rgba(255,255,255,0.15), transparent 35%),
        radial-gradient(circle at bottom right, rgba(255,255,255,0.12), transparent 35%),
        linear-gradient(135deg,#111827,#000000);
}

.container{
    width:720px;
    max-width:95%;
    margin:30px auto;
    padding:40px;
    border-radius:30px;
    background:rgba(255,255,255,0.06);
    backdrop-filter:blur(20px);
    border:1px solid rgba(255,255,255,0.12);
}

h2{
    text-align:center;
    margin-bottom:28px;
    font-size:38px;
    color:white;
}

label{
    display:block;
    margin-top:16px;
    margin-bottom:6px;
    font-weight:bold;
    color:white;
}

input,select{
    width:100%;
    padding:14px 16px;
    border-radius:14px;
    border:1px solid rgba(255,255,255,0.20);
    background:rgba(255,255,255,0.10);
    color:white;
    font-size:16px;
}

select option{
    color:black;
}

input[type=date]::-webkit-calendar-picker-indicator{
    filter:invert(1);
}

#mobileMsg,#phoneMsg{
    margin-top:5px;
    font-weight:bold;
}

.mainBtn{
    width:100%;
    padding:16px;
    margin-top:28px;
    background:linear-gradient(135deg,#43e97b,#38f9d7);
    color:white;
    border:none;
    border-radius:14px;
    font-size:22px;
    font-weight:bold;
    cursor:pointer;
}

.mainbtn1{
    display:block;
    text-align:center;
    margin-top:18px;
    padding:15px;
    text-decoration:none;
    color:white;
    font-size:20px;
    font-weight:bold;
    border-radius:14px;
    background:linear-gradient(135deg,#36d1dc,#5b86e5);
}
</style>

<script>
function checkMobile(){
    let phone=document.getElementById("mobile").value;
    let msg=document.getElementById("mobileMsg");

    if(phone==""){
        msg.innerHTML="";
    }
    else if(/^[6-9][0-9]{9}$/.test(phone)){
        msg.innerHTML="Valid Number";
        msg.style.color="green";
    }else{
        msg.innerHTML="Invalid Number";
        msg.style.color="red";
    }
}

function checkPhone(){
    let phone=document.getElementById("phone").value;
    let msg=document.getElementById("phoneMsg");

    if(phone==""){
        msg.innerHTML="";
    }
    else if(/^[0-9]{10}$/.test(phone)){
        msg.innerHTML="Valid Number";
        msg.style.color="green";
    }else{
        msg.innerHTML="Invalid Number";
        msg.style.color="red";
    }
}
</script>

</head>
<body>

<div class="container">
<h2>Add / Update Student Details</h2>

<form action="adddetails" method="post">

<input type="hidden" name="studentCode" value="<%= code %>">

<label>Reg Number</label>
<input type="text" name="reg" value="<%= reg %>" required>

<label>Name</label>
<input type="text" name="name" value="<%= name %>" required>

<label>College</label>
<input type="text" name="college" value="<%= college %>" required>

<label>Department *</label>
<select name="department" required>
<option value="AIML" <%= department.equals("AIML")?"selected":"" %>>AIML</option>
<option value="CSE"  <%= department.equals("CSE")?"selected":"" %>>CSE</option>
<option value="ISE"  <%= department.equals("ISE")?"selected":"" %>>ISE</option>
<option value="ECE"  <%= department.equals("ECE")?"selected":"" %>>ECE</option>
<option value="EEE"  <%= department.equals("EEE")?"selected":"" %>>EEE</option>
<option value="MECH" <%= department.equals("MECH")?"selected":"" %>>MECH</option>
<option value="CIVIL"<%= department.equals("CIVIL")?"selected":"" %>>CIVIL</option>
</select>

<label>Semester</label>
<select name="semester">
<option value="1" <%= semester.equals("1")?"selected":"" %>>1</option>
<option value="2" <%= semester.equals("2")?"selected":"" %>>2</option>
<option value="3" <%= semester.equals("3")?"selected":"" %>>3</option>
<option value="4" <%= semester.equals("4")?"selected":"" %>>4</option>
<option value="5" <%= semester.equals("5")?"selected":"" %>>5</option>
<option value="6" <%= semester.equals("6")?"selected":"" %>>6</option>
<option value="7" <%= semester.equals("7")?"selected":"" %>>7</option>
<option value="8" <%= semester.equals("8")?"selected":"" %>>8</option>
</select>

<label>Section</label>
<select name="section">
<option value="A" <%= section.equals("A")?"selected":"" %>>A</option>
<option value="B" <%= section.equals("B")?"selected":"" %>>B</option>
<option value="C" <%= section.equals("C")?"selected":"" %>>C</option>
<option value="D" <%= section.equals("D")?"selected":"" %>>D</option>
<option value="E" <%= section.equals("E")?"selected":"" %>>E</option>
<option value="F" <%= section.equals("F")?"selected":"" %>>F</option>
</select>

<label>DOB</label>
<input type="date" name="dob" value="<%= dob %>">

<label>Blood Group</label>
<select name="blood">
<option <%= blood.equals("A+")?"selected":"" %>>A+</option>
<option <%= blood.equals("A-")?"selected":"" %>>A-</option>
<option <%= blood.equals("B+")?"selected":"" %>>B+</option>
<option <%= blood.equals("B-")?"selected":"" %>>B-</option>
<option <%= blood.equals("AB+")?"selected":"" %>>AB+</option>
<option <%= blood.equals("AB-")?"selected":"" %>>AB-</option>
<option <%= blood.equals("O+")?"selected":"" %>>O+</option>
<option <%= blood.equals("O-")?"selected":"" %>>O-</option>
</select>

<label>Gender</label>
<select name="gender">
<option <%= gender.equals("Male")?"selected":"" %>>Male</option>
<option <%= gender.equals("Female")?"selected":"" %>>Female</option>
<option <%= gender.equals("Other")?"selected":"" %>>Other</option>
</select>

<label>Mobile</label>
<input id="mobile" type="text" name="mobile" value="<%= mobile %>" onkeyup="checkMobile()" required>
<div id="mobileMsg"></div>

<label>Phone</label>
<input id="phone" type="text" name="phone" value="<%= phone %>" onkeyup="checkPhone()">
<div id="phoneMsg"></div>

<label>Address</label>
<input type="text" name="address" value="<%= address %>" required>

<label>Category</label>
<select name="category">
<option <%= category.equals("GM")?"selected":"" %>>GM</option>
<option <%= category.equals("SC")?"selected":"" %>>SC</option>
<option <%= category.equals("ST")?"selected":"" %>>ST</option>
<option <%= category.equals("OBC")?"selected":"" %>>OBC</option>
<option <%= category.equals("2A")?"selected":"" %>>2A</option>
<option <%= category.equals("2B")?"selected":"" %>>2B</option>
<option <%= category.equals("3A")?"selected":"" %>>3A</option>
<option <%= category.equals("3B")?"selected":"" %>>3B</option>
</select>

<label>Nationality</label>
<input list="countries" name="nationality" value="<%= nationality %>">

<datalist id="countries">
<option>India</option>
<option>USA</option>
<option>UK</option>
<option>Canada</option>
<option>Australia</option>
</datalist>

<label>Admission Year</label>
<input type="number" min="2000" max="2050" name="year" value="<%= year %>">

<label>Parent Name</label>
<input type="text" name="parentName" value="<%= parentName %>">

<label>Parent Mobile</label>
<input type="text" name="parentPhone" value="<%= parentPhone %>">

<label>Parent Blood Group</label>
<select name="parentBlood">
<option <%= parentBlood.equals("A+")?"selected":"" %>>A+</option>
<option <%= parentBlood.equals("A-")?"selected":"" %>>A-</option>
<option <%= parentBlood.equals("B+")?"selected":"" %>>B+</option>
<option <%= parentBlood.equals("B-")?"selected":"" %>>B-</option>
<option <%= parentBlood.equals("AB+")?"selected":"" %>>AB+</option>
<option <%= parentBlood.equals("AB-")?"selected":"" %>>AB-</option>
<option <%= parentBlood.equals("O+")?"selected":"" %>>O+</option>
<option <%= parentBlood.equals("O-")?"selected":"" %>>O-</option>
</select>

<button type="submit" class="mainBtn">Save Details</button>
<a href="index.jsp" class="mainbtn1">Back</a>

</form>
</div>

</body>
</html>
