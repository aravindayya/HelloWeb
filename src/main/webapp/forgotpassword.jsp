<html>
<head>
<title>Send OTP</title>

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
        radial-gradient(circle at center, rgba(255,255,255,0.08), transparent 40%),
        linear-gradient(135deg,#0f172a,#000000);
}

.card{
    width:470px;
    max-width:95%;
    padding:40px;
    border-radius:32px;
    background:rgba(255,255,255,0.06);
    backdrop-filter:blur(24px);
    border:1px solid rgba(255,255,255,0.12);
    box-shadow:
        0 0 40px rgba(255,255,255,0.08),
        0 0 100px rgba(0,255,255,0.08),
        inset 0 0 20px rgba(255,255,255,0.03);
    animation:pop 0.8s ease;
    transition:all 0.4s ease;
}

.card:hover{
    transform:translateY(-6px);
    box-shadow:
        0 0 60px rgba(0,255,255,0.14),
        0 0 140px rgba(255,255,255,0.08);
}

@keyframes pop{
    from{
        opacity:0;
        transform:translateY(40px) scale(0.9);
    }
    to{
        opacity:1;
        transform:translateY(0) scale(1);
    }
}

h1{
    text-align:center;
    margin-bottom:28px;
    color:white;
    font-size:42px;
    text-shadow:0 0 20px rgba(255,255,255,0.7);
}

label{
    display:block;
    margin-top:16px;
    margin-bottom:8px;
    font-weight:bold;
    color:white;
}

input{
    width:100%;
    padding:16px;
    border:1px solid rgba(255,255,255,0.18);
    border-radius:16px;
    font-size:16px;
    background:rgba(255,255,255,0.08);
    color:white;
    backdrop-filter:blur(12px);
    transition:all 0.35s ease;
}

input:hover{
    transform:translateY(-2px);
    box-shadow:0 0 15px rgba(0,255,255,0.15);
}

input:focus{
    outline:none;
    border-color:#00e5ff;
    box-shadow:
        0 0 14px #00e5ff,
        0 0 30px rgba(0,229,255,0.25);
}

button{
    width:100%;
    padding:17px;
    margin-top:30px;
    border:none;
    border-radius:16px;
    background:linear-gradient(135deg,#43e97b,#38f9d7);
    color:white;
    font-size:22px;
    font-weight:bold;
    cursor:pointer;
    transition:all 0.35s ease;
}

button:hover{
    transform:translateY(-4px) scale(1.03);
    box-shadow:
        0 0 22px rgba(72,255,176,0.45),
        0 0 45px rgba(72,255,176,0.25);
}

.msg{
    margin-top:8px;
    font-weight:bold;
    font-size:14px;
}
</style>

<script>
function checkUsername(){
    let user=document.getElementById("username").value;
    let msg=document.getElementById("userMsg");

    if(user.length==0){
        msg.innerHTML="";
    }
    else if(user.length<3){
        msg.innerHTML="Username too short";
        msg.style.color="red";
    }
    else{
        msg.innerHTML="Valid Username";
        msg.style.color="green";
    }
}

function checkPhone(){
    let phone=document.getElementById("phone").value;
    let msg=document.getElementById("phoneMsg");

    if(phone.length==0){
        msg.innerHTML="";
    }
    else if(phone.length<10){
        msg.innerHTML="Weak Number";
        msg.style.color="red";
    }
    else if(/^[6-9][0-9]{9}$/.test(phone)){
        msg.innerHTML="Valid Number";
        msg.style.color="green";
    }
    else{
        msg.innerHTML="Invalid Number";
        msg.style.color="red";
    }
}

function validateForm(){
    let phone=document.getElementById("phone").value;

    if(!/^[6-9][0-9]{9}$/.test(phone)){
        alert("Enter valid phone number");
        return false;
    }
    return true;
}
</script>

</head>
<body>

<div class="card">
<h1>Send OTP</h1>

<form action="sendotp" method="post" onsubmit="return validateForm()">

<label>Username</label>
<input type="text"
       id="username"
       name="username"
       onkeyup="checkUsername()"
       required>
<div id="userMsg" class="msg"></div>

<label>Phone</label>
<input type="text"
       id="phone"
       name="phone"
       maxlength="10"
       onkeyup="checkPhone()"
       required>
<div id="phoneMsg" class="msg"></div>

<button type="submit">Send OTP</button>

</form>
</div>

</body>
</html>