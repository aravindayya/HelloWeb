<%
String user=(String)session.getAttribute("user");
String admin=(String)session.getAttribute("admin");
String teacher=(String)session.getAttribute("teacher");

if(user==null || (admin==null && teacher==null)){
    response.sendRedirect("login.jsp");
    return;
}
%>

<html>
<head>
<title>Add Marks</title>

<style>
*{
    box-sizing:border-box;
}

body{
    margin:0;
    padding:0;
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

.container{
    width:460px;
    max-width:95%;
    padding:35px;
    border-radius:30px;
    background:rgba(255,255,255,0.06);
    backdrop-filter:blur(20px);
    border:1px solid rgba(255,255,255,0.12);
    box-shadow:
        0 0 40px rgba(255,255,255,0.10),
        inset 0 0 20px rgba(255,255,255,0.04);
    animation:fadeIn 0.8s ease;
}

h2{
    text-align:center;
    color:white;
    font-size:36px;
    margin-bottom:25px;
}

label{
    display:block;
    margin-top:14px;
    font-weight:bold;
    color:white;
}

input[type=number]{
    width:100%;
    padding:14px;
    margin-top:8px;
    border-radius:12px;
    border:1px solid rgba(255,255,255,0.20);
    background:rgba(255,255,255,0.10);
    color:white;
}

input[type=submit]{
    width:100%;
    margin-top:28px;
    padding:15px;
    background:linear-gradient(135deg,#43e97b,#38f9d7);
    color:white;
    border:none;
    border-radius:14px;
    font-size:18px;
    font-weight:bold;
    cursor:pointer;
}

.backBtn{
    display:block;
    text-align:center;
    margin-top:18px;
    text-decoration:none;
    color:white;
    padding:14px;
    border-radius:14px;
    font-weight:bold;
    background:linear-gradient(135deg,#36d1dc,#5b86e5);
}

@keyframes fadeIn{
    from{
        opacity:0;
        transform:translateY(-40px);
    }
    to{
        opacity:1;
        transform:translateY(0);
    }
}
</style>
</head>

<body>

<div class="container">
<h2>Add Student Marks</h2>

<form action="savemarks" method="post">

<input type="hidden"
       name="studentCode"
       value="<%= request.getParameter("code") %>">

<label>ENGLISH</label>
<input type="number" name="sub1" min="0" max="100" required>

<label>KANNADA</label>
<input type="number" name="sub2" min="0" max="100" required>

<label>HINDI</label>
<input type="number" name="sub3" min="0" max="100" required>

<label>SOCIAL</label>
<input type="number" name="sub4" min="0" max="100" required>

<label>SCIENCE</label>
<input type="number" name="sub5" min="0" max="100" required>

<label>MATHS</label>
<input type="number" name="sub6" min="0" max="100" required>

<input type="submit" value="Save Marks">

</form>

<a class="backBtn" href="index.jsp">Back</a>

</div>

</body>
</html>