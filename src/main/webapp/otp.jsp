<html>
<head>
<title>Verify OTP</title>

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
    padding:42px;
    border-radius:32px;
    background:rgba(255,255,255,0.06);
    backdrop-filter:blur(24px);
    border:1px solid rgba(255,255,255,0.12);
    box-shadow:
        0 0 40px rgba(255,255,255,0.08),
        0 0 100px rgba(0,255,255,0.08),
        inset 0 0 20px rgba(255,255,255,0.03);
    animation:pop 0.7s ease;
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
        transform:scale(0.8);
    }
    to{
        opacity:1;
        transform:scale(1);
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
    margin-bottom:10px;
    font-weight:bold;
    color:white;
}

input{
    width:100%;
    padding:16px;
    border:1px solid rgba(255,255,255,0.18);
    border-radius:16px;
    font-size:18px;
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

.msg{
    margin-top:8px;
    font-weight:bold;
}

.mainBtn{
    width:100%;
    padding:17px;
    margin-top:24px;
    background:linear-gradient(135deg,#43e97b,#38f9d7);
    color:white;
    border:none;
    border-radius:16px;
    font-size:22px;
    font-weight:bold;
    cursor:pointer;
    transition:all 0.35s ease;
}

.mainBtn:hover{
    transform:translateY(-4px) scale(1.03);
    box-shadow:
        0 0 22px rgba(72,255,176,0.45),
        0 0 45px rgba(72,255,176,0.25);
}

.backBtn{
    display:block;
    text-align:center;
    margin-top:18px;
    padding:14px;
    background:linear-gradient(135deg,#36d1dc,#5b86e5);
    color:white;
    text-decoration:none;
    border-radius:16px;
    font-weight:bold;
    transition:all 0.35s ease;
}

.backBtn:hover{
    transform:translateY(-4px) scale(1.03);
    box-shadow:
        0 0 20px rgba(91,134,229,0.45),
        0 0 40px rgba(54,209,220,0.25);
}
</style>

<script>
function checkOtp(){
    let otp=document.getElementById("otp").value;
    let msg=document.getElementById("otpMsg");

    if(otp.length==0){
        msg.innerHTML="";
    }
    else if(otp.length<6){
        msg.innerHTML="OTP must be 6 digits";
        msg.style.color="red";
    }
    else if(/^[0-9]{6}$/.test(otp)){
        msg.innerHTML="Valid OTP";
        msg.style.color="green";
    }
    else{
        msg.innerHTML="Invalid OTP";
        msg.style.color="red";
    }
}

function validateForm(){
    let otp=document.getElementById("otp").value;

    if(!/^[0-9]{6}$/.test(otp)){
        alert("Enter valid 6 digit OTP");
        return false;
    }
    return true;
}
</script>

</head>
<body>

<div class="card">
<h1>Verify OTP</h1>

<form action="verifyotp" method="post" onsubmit="return validateForm()">

<label>Enter OTP</label>
<input type="text"
       id="otp"
       name="otp"
       maxlength="6"
       onkeyup="checkOtp()"
       required>

<div id="otpMsg" class="msg"></div>

<button type="submit" class="mainBtn">Verify OTP</button>
</form>

<a href="forgotpassword.jsp" class="backBtn">Back</a>

</div>
</body>
</html>