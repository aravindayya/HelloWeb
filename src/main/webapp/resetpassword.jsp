<html>
<head>
<title>Reset Password</title>

<style>
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:Arial,sans-serif;
}

body{
    min-height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    background:
        radial-gradient(circle at 20% 20%, rgba(0,255,255,0.15), transparent 25%),
        radial-gradient(circle at 80% 80%, rgba(255,0,255,0.15), transparent 25%),
        linear-gradient(135deg,#0f172a,#000000);
}

.card{
    width:430px;
    max-width:95%;
    padding:40px;
    border-radius:30px;
    background:rgba(255,255,255,0.06);
    backdrop-filter:blur(20px);
    border:1px solid rgba(255,255,255,0.12);
    box-shadow:0 0 40px rgba(255,255,255,0.08);
}

h2{
    text-align:center;
    color:white;
    margin-bottom:25px;
    font-size:34px;
}

label{
    color:white;
    font-weight:bold;
    display:block;
    margin-top:12px;
    margin-bottom:6px;
}

input{
    width:100%;
    padding:16px;
    margin-bottom:8px;
    border-radius:14px;
    border:1px solid rgba(255,255,255,0.18);
    background:rgba(255,255,255,0.08);
    color:white;
    font-size:16px;
}

input:focus{
    outline:none;
    border-color:#00e5ff;
    box-shadow:0 0 12px #00e5ff;
}

button{
    width:100%;
    padding:16px;
    margin-top:20px;
    border:none;
    border-radius:14px;
    background:linear-gradient(135deg,#43e97b,#38f9d7);
    color:white;
    font-size:20px;
    font-weight:bold;
    cursor:pointer;
}

.msg{
    font-weight:bold;
    margin-bottom:8px;
    font-size:14px;
}

.rules{
    margin-top:10px;
    padding:12px;
    border-radius:12px;
    background:rgba(255,255,255,0.08);
}

.rules div{
    margin:5px 0;
    color:red;
}
</style>

<script>
function updateRule(id, valid){
    let x=document.getElementById(id);
    x.style.color = valid ? "lime" : "red";
}

function checkPassword(){
    let pass=document.getElementById("newpass").value;
    let msg=document.getElementById("passMsg");

    let upper=/[A-Z]/.test(pass);
    let lower=/[a-z]/.test(pass);
    let number=/[0-9]/.test(pass);
    let special=/[@$!%*?&]/.test(pass);
    let length=pass.length>=8;

    updateRule("upper",upper);
    updateRule("lower",lower);
    updateRule("number",number);
    updateRule("special",special);
    updateRule("length",length);

    if(pass.length==0){
        msg.innerHTML="";
        return;
    }

    if(upper && lower && number && special && length){
        msg.innerHTML="Strong Password";
        msg.style.color="lime";
    }else{
        msg.innerHTML="Weak Password";
        msg.style.color="red";
    }

    checkConfirm();
}

function checkConfirm(){
    let pass=document.getElementById("newpass").value;
    let confirm=document.getElementById("confirmpass").value;
    let msg=document.getElementById("confirmMsg");

    if(confirm.length==0){
        msg.innerHTML="";
        return;
    }

    if(pass===confirm){
        msg.innerHTML="Password Matched";
        msg.style.color="lime";
    }else{
        msg.innerHTML="Password Not Matched";
        msg.style.color="red";
    }
}

function validateForm(){
    let pass=document.getElementById("newpass").value;
    let confirm=document.getElementById("confirmpass").value;

    let strong=/^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[@$!%*?&]).{8,}$/;

    if(!strong.test(pass)){
        alert("Password is weak");
        return false;
    }

    if(pass!==confirm){
        alert("Password mismatch");
        return false;
    }

    return true;
}
</script>
</head>

<body>

<div class="card">
<h2>Reset Password</h2>

<form action="resetpassword" method="post" onsubmit="return validateForm()">

<label>New Password</label>
<input type="password" id="newpass" name="newpass" onkeyup="checkPassword()" required>

<div id="passMsg" class="msg"></div>

<div class="rules">
<div id="length">Minimum 8 characters</div>
<div id="upper">1 Capital Letter</div>
<div id="lower">1 Small Letter</div>
<div id="number">1 Number</div>
<div id="special">1 Special Character</div>
</div>

<label>Confirm Password</label>
<input type="password" id="confirmpass" name="confirmpass" onkeyup="checkConfirm()" required>

<div id="confirmMsg" class="msg"></div>

<button type="submit">Update Password</button>

</form>
</div>

</body>
</html>