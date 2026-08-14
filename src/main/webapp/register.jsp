<html>
<head>
<title>User Registration</title>

<style>
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:Arial,sans-serif;
}
body{
    min-height:100vh;
    padding:30px 0;
    background:
        radial-gradient(circle at 20% 20%, rgba(0,255,255,0.15), transparent 25%),
        radial-gradient(circle at 80% 80%, rgba(255,0,255,0.15), transparent 25%),
        radial-gradient(circle at center, rgba(255,255,255,0.08), transparent 40%),
        linear-gradient(135deg,#0f172a,#000000);
}
.mainBtn:disabled{

    background:#777;
    cursor:not-allowed;
    opacity:.6;

}

.mainBtn:not(:disabled){

    background:linear-gradient(135deg,#43e97b,#38f9d7);
    box-shadow:
    0 0 20px rgba(67,233,123,.5);

}
.card{
    width:560px;
    max-width:95%;
    margin:auto;
    padding:42px;
    border-radius:32px;
    background:rgba(255,255,255,0.06);
    backdrop-filter:blur(24px);
}
h1{
    text-align:center;
    margin-bottom:28px;
    font-size:42px;
    color:white;
}
label{
    display:block;
    margin-top:15px;
    margin-bottom:6px;
    font-weight:bold;
    color:white;
}
.required{
    color:#ff416c;
}
input{
    width:100%;
    padding:16px;
    border-radius:16px;
    border:1px solid rgba(255,255,255,0.18);
    background:rgba(255,255,255,0.08);
    color:white;
}
.mainBtn{
    width:100%;
    padding:17px;
    margin-top:30px;
    background:linear-gradient(135deg,#43e97b,#38f9d7);
    color:white;
    border:none;
    border-radius:16px;
    font-size:22px;
    font-weight:bold;
    cursor:pointer;
}
.showBtn{
    position:absolute;
    right:8px;
    top:8px;
    width:65px;
    height:38px;
    border:none;
    border-radius:20px;
}
.loginLink{
    text-align:center;
    margin-top:22px;
    color:white;
}
.loginLink a{
    color:#7dd3fc;
    text-decoration:none;
}
.phoneRow{
    display:flex;
    gap:10px;
    align-items:center;
}
.phoneRow input{
    flex:1;
}
.removePhone{
    width:46px;
    height:50px;
    border:none;
    border-radius:14px;
    background:linear-gradient(135deg,#ff416c,#ff4b2b);
    color:white;
    font-size:22px;
    font-weight:bold;
    cursor:pointer;
    flex-shrink:0;
    transition:all .3s ease;
}
.removePhone:hover{
    transform:scale(1.08);
    box-shadow:0 0 18px rgba(255,75,43,.5);
}
.addPhone{
    width:100%;
    margin-top:10px;
    padding:12px;
    border:2px dashed rgba(255,255,255,0.25);
    border-radius:14px;
    background:transparent;
    color:#7dd3fc;
    font-size:15px;
    font-weight:bold;
    cursor:pointer;
    transition:all .3s ease;
}
.addPhone:hover{
    background:rgba(255,255,255,0.06);
    border-color:#7dd3fc;
    color:white;
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
function validateName(){

    let name=document.getElementById("fullname").value.trim();

    let msg=document.getElementById("nameMsg");

    let pattern=/^([A-Z][a-z]+)(\s[A-Z][a-z]+)*$/;

    if(name.length==0){

        msg.innerHTML="";
        return false;

    }

    if(name.length<3){

        msg.innerHTML="Minimum 3 letters";
        msg.style.color="red";
        return false;

    }

    if(!pattern.test(name)){

    	msg.innerHTML='Each word must start with a capital letter &(Not allowed numbers)(Example: <font color="#00ff66">Aravindayya</font>)';        msg.style.color="red";
        return false;

    }

    msg.innerHTML="Valid Name";
    msg.style.color="#00ff99";

    return true;
}
function validateUsername(){

    let username=document.getElementById("username").value.trim();

    let msg=document.getElementById("usernameMsg");

    let pattern=/^[A-Za-z0-9_]+$/;

    if(username.length==0){

        msg.innerHTML="";
        checkForm();
        return false;

    }

    if(username.length<5){

        msg.innerHTML="Username must contain at least 5 characters";
        msg.style.color="red";
        checkForm();
        return false;

    }

    if(!pattern.test(username)){

        msg.innerHTML="Only letters, numbers and underscore (_) are allowed";
        msg.style.color="red";
        checkForm();
        return false;

    }

    let xhttp=new XMLHttpRequest();

    xhttp.onreadystatechange=function(){

        if(this.readyState==4 && this.status==200){

            if(this.responseText.trim()=="exists"){

                msg.innerHTML="Username already exists";
                msg.style.color="red";

            }else{

                msg.innerHTML="Username available";
                msg.style.color="#00ff66";

            }

            checkForm();

        }

    };

    xhttp.open("GET","checkUsername?username="+username,true);

    xhttp.send();

    return true;

}
function checkPassword(){

    let pass=document.getElementById("password").value;

    let rules=document.getElementById("passwordRules");

    let strength=document.getElementById("strength");

    if(pass.length==0){

        rules.style.display="none";

        strength.innerHTML="";

        return false;

    }

    rules.style.display="block";

    let hasUpper=/[A-Z]/.test(pass);

    let hasLower=/[a-z]/.test(pass);

    let hasNumber=/[0-9]/.test(pass);

    let hasSpecial=/[^A-Za-z0-9]/.test(pass);

    let hasLength=pass.length>=8;

    document.getElementById("upper").style.color=
    hasUpper?"#00ff66":"red";

    document.getElementById("lower").style.color=
    hasLower?"#00ff66":"red";

    document.getElementById("number").style.color=
    hasNumber?"#00ff66":"red";

    document.getElementById("special").style.color=
    hasSpecial?"#00ff66":"red";

    document.getElementById("length").style.color=
    hasLength?"#00ff66":"red";

    let score=0;

    if(hasUpper)score++;

    if(hasLower)score++;

    if(hasNumber)score++;

    if(hasSpecial)score++;

    if(hasLength)score++;

    if(score<=2){

        strength.innerHTML="Weak Password";

        strength.style.color="red";

    }

    else if(score<=4){

        strength.innerHTML="Medium Password";

        strength.style.color="orange";

    }

    else{

        strength.innerHTML="Strong Password";

        strength.style.color="#00ff66";

        rules.style.display="none";

    }

    return score==5;
}
function checkConfirmPassword(){

    let password=document.getElementById("password").value;

    let confirm=document.getElementById("confirm").value;

    let msg=document.getElementById("confirmMsg");

    if(confirm.length==0){

        msg.innerHTML="";
        return false;

    }

    if(password===confirm){

        msg.innerHTML="Password Matched";
        msg.style.color="#00ff66";

        return true;

    }

    msg.innerHTML="Password Does Not Match";
    msg.style.color="red";

    return false;

}
function validatePhone(el){

    let phone=el.value.trim();

    let msg=el.closest(".phoneRow").nextElementSibling;

    if(phone.length==0){

        msg.innerHTML="";
        checkForm();
        return false;

    }

    if(!/^\d*$/.test(phone)){

        msg.innerHTML="Only numbers are allowed";
        msg.style.color="red";
        checkForm();
        return false;

    }

    if(phone.length<10){

        msg.innerHTML="Phone number must contain 10 digits";
        msg.style.color="red";
        checkForm();
        return false;

    }

    if(!/^[6-9]/.test(phone)){

        msg.innerHTML="Phone number Invalid";
        msg.style.color="red";
        checkForm();
        return false;

    }

    msg.innerHTML="Valid Phone Number";
    msg.style.color="#00ff66";

    checkForm();

    return true;
}
function validateAllPhones(){

    let inputs=document.querySelectorAll("input.phoneInput");

    let filled=0;
    let invalid=0;

    for(let i=0;i<inputs.length;i++){

        let v=inputs[i].value.trim();

        if(v.length==0) continue;

        filled++;

        if(/^[6-9][0-9]{9}$/.test(v)){

            inputs[i].closest(".phoneRow").nextElementSibling.innerHTML="Valid Phone Number";

            inputs[i].closest(".phoneRow").nextElementSibling.style.color="#00ff66";

        }else{

            invalid++;

        }

    }

    if(filled<1) return false;

    return invalid==0;

}
function addPhone(){

    let wrap=document.getElementById("phoneList");

    let row=document.createElement("div");

    row.className="phoneRow";

    row.style.marginTop="10px";

    row.innerHTML=

        '<input type="tel" name="altphone" class="phoneInput" maxlength="10" '+

        'placeholder="Alternate phone" '+

        'onkeypress="return event.charCode>=48 && event.charCode<=57" '+

        'onkeyup="validatePhone(this)">'+

        '<button type="button" class="removePhone" onclick="removePhone(this)">-</button>';

    let msg=document.createElement("div");

    msg.className="phoneMsg";

    msg.style.cssText="margin-top:5px;font-size:14px;font-weight:bold;";

    wrap.appendChild(row);

    wrap.appendChild(msg);

    row.scrollIntoView({behavior:"smooth",block:"center"});

    row.querySelector("input").focus();

}
function removePhone(btn){

    let row=btn.closest(".phoneRow");

    let msg=row.nextElementSibling;

    row.remove();

    if(msg && msg.classList.contains("phoneMsg")) msg.remove();

    checkForm();

}
function validateEmail(){

    let email=document.getElementById("email").value.trim();

    let msg=document.getElementById("emailMsg");

    if(email.length==0){

        msg.innerHTML="";
        return false;

    }

    let pattern=/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;

    if(!pattern.test(email)){

        msg.innerHTML="Invalid Email Address";
        msg.style.color="red";

        return false;

    }

    msg.innerHTML="Valid Email Address";
    msg.style.color="#00ff66";

    return true;

}
function checkForm(){

    let ok=
    validateName() &&
    validateUsername() &&
    checkPassword() &&
    checkConfirmPassword() &&
    validateAllPhones() &&
    validateEmail();

    document.getElementById("registerBtn").disabled=!ok;

}
</script>
</head>

<body>
<div class="card">
<h1>Student Registration</h1>

<form action="register" method="post" onsubmit="return validateForm()">

<label>Full Name <span class="required">*</span></label>

<input
type="text"
id="fullname"
name="name"
onkeyup="validateName()"
required>

<div id="nameMsg"
style="margin-top:5px;font-size:14px;font-weight:bold;"></div>

<label>Username <span class="required">*</span></label>

<input
type="text"
id="username"
name="username"
onkeyup="validateUsername()"
required>

<div id="usernameMsg"
style="margin-top:5px;font-size:14px;font-weight:bold;"></div>

<label>Password <span class="required">*</span></label>

<div style="position:relative;">
   <input
type="password"
id="password"
name="password"
onkeyup="checkPassword();checkConfirmPassword();"
required>

    <button
        type="button"
        class="showBtn"
        id="show1"
        onclick="togglePassword()">
        Show
    </button>
</div>

<div id="passwordRules"
style="
display:none;
margin-top:10px;
font-size:15px;
line-height:28px;">

<div id="length" style="color:red;">Minimum 8 characters</div>

<div id="upper" style="color:red;">1 Capital Letter</div>

<div id="lower" style="color:red;">1 Small Letter</div>

<div id="number" style="color:red;">1 Number</div>

<div id="special" style="color:red;">1 Special Character</div>

</div>

<div
id="strength"
style="
margin-top:10px;
font-size:17px;
font-weight:bold;">
</div>

<label>Confirm Password <span class="required">*</span></label>

<div style="position:relative;">
    <input
        type="password"
        id="confirm"
        name="confirm"
        onkeyup="checkConfirmPassword()"
        required>

    <button
        type="button"
        class="showBtn"
        id="show2"
        onclick="toggleConfirmPassword()">
        Show
    </button>
</div>

<div id="confirmMsg"
style="
margin-top:8px;
font-size:15px;
font-weight:bold;">
</div>

<label>Phone Number <span class="required">*</span></label>

<div id="phoneList">
<div class="phoneRow">
    <input
    type="tel"
    id="phone"
    name="phone"
    class="phoneInput"
    maxlength="10"
    onkeypress="return event.charCode>=48 && event.charCode<=57"
    onkeyup="validatePhone(this)"
    required>
</div>

<div id="phoneMsg"
style="
margin-top:8px;
font-size:15px;
font-weight:bold;">
</div>
</div>

<button type="button" class="addPhone" onclick="addPhone()">+ Add Another Phone</button>

<label>Email <span class="required">*</span></label>

<input
type="email"
id="email"
name="email"
onkeyup="validateEmail()"
required>

<div id="emailMsg"
style="
margin-top:8px;
font-size:15px;
font-weight:bold;">
</div>

<button
type="submit"
class="mainBtn"
id="registerBtn"
disabled>

Register

</button>
</form>

<div class="loginLink">
Already have account?
<a href="login.jsp">Login</a>
</div>

</div>
</body>
</html>