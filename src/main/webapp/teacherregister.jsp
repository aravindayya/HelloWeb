<%
response.setHeader("Cache-Control","no-cache,no-store,must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires",0);

String user=(String)session.getAttribute("user");
String admin=(String)session.getAttribute("admin");

if(user==null || admin==null){
    response.sendRedirect("login.jsp");
    return;
}
%>

<html>
<head>
<title>Teacher Registration</title>

<style>
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:Arial,sans-serif;
}

body{
    min-height:100vh;
    padding:40px 0;
    background:
        radial-gradient(circle at 20% 20%, rgba(0,255,255,0.15), transparent 30%),
        radial-gradient(circle at 80% 80%, rgba(255,0,255,0.12), transparent 30%),
        linear-gradient(135deg,#0f172a,#000);
}

.card{
    width:700px;
    max-width:95%;
    margin:auto;
    padding:45px;
    border-radius:30px;
    background:rgba(255,255,255,0.06);
    backdrop-filter:blur(25px);
    border:1px solid rgba(255,255,255,0.15);
    box-shadow:0 0 40px rgba(0,255,255,0.12);
}

h1{
    text-align:center;
    color:white;
    margin-bottom:30px;
    font-size:42px;
    text-shadow:0 0 20px rgba(255,255,255,0.7);
}

label{
    display:block;
    margin-top:18px;
    margin-bottom:7px;
    color:white;
    font-weight:bold;
    font-size:18px;
}

.required{
    color:red;
}

input,select{
    width:100%;
    height:55px;
    padding:0 18px;
    border-radius:14px;
    border:1px solid rgba(255,255,255,0.18);
    background:rgba(255,255,255,0.08);
    color:white;
    font-size:16px;
    transition:0.3s;
}

input:hover,select:hover{
    box-shadow:0 0 18px rgba(0,255,255,0.15);
}

input:focus,select:focus{
    outline:none;
    border-color:#00e5ff;
    box-shadow:0 0 18px #00e5ff;
}

select option{
    color:black;
}

.passwordBox{
    position:relative;
}

.showBtn{
    position:absolute;
    right:10px;
    top:50%;
    transform:translateY(-50%);
    width:70px;
    height:38px;
    border:none;
    border-radius:20px;
    background:linear-gradient(135deg,#8e2de2,#4a00e0);
    color:white;
    font-weight:bold;
    cursor:pointer;
}

.showBtn:hover{
    box-shadow:0 0 18px rgba(142,45,226,0.5);
}

.ruleBox{
    display:none;
    margin-top:12px;
    padding:16px;
    border-radius:14px;
    background:rgba(255,255,255,0.08);
    color:white;
}

#strengthMsg,#phoneMsg,#emailMsg,#adminMsg{
    margin-top:8px;
    font-weight:bold;
}

.mainBtn{
    width:100%;
    height:58px;
    margin-top:30px;
    border:none;
    border-radius:16px;
    background:linear-gradient(135deg,#43e97b,#38f9d7);
    color:white;
    font-size:22px;
    font-weight:bold;
    cursor:pointer;
}

.mainBtn:hover{
    transform:translateY(-3px);
    box-shadow:0 0 25px rgba(72,255,176,0.4);
}

.backBtn{
    display:block;
    text-align:center;
    margin-top:18px;
    padding:15px;
    text-decoration:none;
    color:white;
    font-size:18px;
    font-weight:bold;
    border-radius:14px;
    background:linear-gradient(135deg,#36d1dc,#5b86e5);
}
</style>

<script>
function validateForm(){
    let pass=document.getElementById("password").value;
    let confirm=document.getElementById("confirm").value;
    if(pass!==confirm){
        alert("Password mismatch");
        return false;
    }
    return true;
}

function togglePassword(){
    let pass=document.getElementById("password");
    let btn=document.getElementById("show1");

    if(pass.type==="password"){
        pass.type="text";
        btn.innerHTML="Hide";
    }else{
        pass.type="password";
        btn.innerHTML="Show";
    }
}

function toggleConfirmPassword(){
    let pass=document.getElementById("confirm");
    let btn=document.getElementById("show2");

    if(pass.type==="password"){
        pass.type="text";
        btn.innerHTML="Hide";
    }else{
        pass.type="password";
        btn.innerHTML="Show";
    }
}

function updateRule(id, ok){
    document.getElementById(id).style.color=ok?"lime":"red";
}

function checkStrength(){
    let pass=document.getElementById("password").value;
    let msg=document.getElementById("strengthMsg");
    let rules=document.getElementById("passwordRules");

    let upper=/[A-Z]/.test(pass);
    let lower=/[a-z]/.test(pass);
    let number=/[0-9]/.test(pass);
    let special=/[@$!%*?&]/.test(pass);
    let length=pass.length>=8;

    if(pass.length==0){
        rules.style.display="none";
        msg.innerHTML="";
        return;
    }

    rules.style.display="block";

    updateRule("upper",upper);
    updateRule("lower",lower);
    updateRule("number",number);
    updateRule("special",special);
    updateRule("length",length);

    if(upper && lower && number && special && length){
        msg.innerHTML="Strong Password";
        msg.style.color="lime";
    }else{
        msg.innerHTML="Weak Password";
        msg.style.color="red";
    }
}

function checkPhone(){
    let phone=document.getElementById("phone").value;
    let msg=document.getElementById("phoneMsg");

    if(phone==""){ msg.innerHTML=""; }
    else if(/^[6-9][0-9]{9}$/.test(phone)){
        msg.innerHTML="Valid Number";
        msg.style.color="lime";
    }else{
        msg.innerHTML="Invalid Number";
        msg.style.color="red";
    }
}

function checkEmail(){
    let email=document.getElementById("email").value;
    let msg=document.getElementById("emailMsg");
    let regex=/^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if(email==""){ msg.innerHTML=""; }
    else if(regex.test(email)){
        msg.innerHTML="Valid Email";
        msg.style.color="lime";
    }else{
        msg.innerHTML="Invalid Email";
        msg.style.color="red";
    }
}

function checkAdminPassword(){
    let pass=document.getElementById("adminpass").value;
    let msg=document.getElementById("adminMsg");

    if(pass==""){ msg.innerHTML=""; }
    else if(pass=="admin123"){
        msg.innerHTML="Valid Admin Password";
        msg.style.color="lime";
    }else{
        msg.innerHTML="Wrong Admin Password";
        msg.style.color="red";
    }
}
</script>
</head>

<body>
<div class="card">
<h1>Teacher Registration</h1>

<form action="teacherregister" method="post" onsubmit="return validateForm()">

<label>Full Name <span class="required">*</span></label>
<input type="text" name="fullname" required>

<label>Username <span class="required">*</span></label>
<input type="text" name="username" required>

<label>Department <span class="required">*</span></label>
<select name="department" required>
<option value="">Select Department</option>
<option>AIML</option><option>CSE</option><option>ISE</option>
<option>ECE</option><option>EEE</option><option>MECH</option><option>CIVIL</option>
</select>

<label>Semester <span class="required">*</span></label>
<select name="semester" required>
<option value="">Select Semester</option>
<option value="1">1</option><option value="2">2</option><option value="3">3</option>
<option value="4">4</option><option value="5">5</option><option value="6">6</option>
<option value="7">7</option><option value="8">8</option>
</select>

<label>Section <span class="required">*</span></label>
<select name="section" required>
<option value="">Select Section</option>
<option>A</option><option>B</option><option>C</option>
<option>D</option><option>E</option><option>F</option>
</select>

<label>Password <span class="required">*</span></label>
<div class="passwordBox">
<input type="password" id="password" name="password" onkeyup="checkStrength()" required>
<button type="button" class="showBtn" id="show1" onclick="togglePassword()">Show</button>
</div>

<div id="strengthMsg"></div>
<div id="passwordRules" class="ruleBox">
<div id="length">Minimum 8 characters</div>
<div id="upper">1 Capital Letter</div>
<div id="lower">1 Small Letter</div>
<div id="number">1 Number</div>
<div id="special">1 Special Character</div>
</div>

<label>Confirm Password <span class="required">*</span></label>
<div class="passwordBox">
<input type="password" id="confirm" name="confirm" required>
<button type="button" class="showBtn" id="show2" onclick="toggleConfirmPassword()">Show</button>
</div>

<label>Admin Password <span class="required">*</span></label>
<input type="password" id="adminpass" name="adminpass" onkeyup="checkAdminPassword()" required>
<div id="adminMsg"></div>

<label>Phone Number <span class="required">*</span></label>
<input type="text" id="phone" name="phone" maxlength="10" onkeyup="checkPhone()" required>
<div id="phoneMsg"></div>

<label>Email <span class="required">*</span></label>
<input type="email" id="email" name="email" onkeyup="checkEmail()" required>
<div id="emailMsg"></div>

<button type="submit" class="mainBtn">Register Teacher</button>

</form>

<a href="index.jsp" class="backBtn">Back</a>
</div>
</body>
</html>
