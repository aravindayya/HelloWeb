<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html>
<head>
<title>Login</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<style>
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:'Poppins',Arial,sans-serif;
}

body{
    min-height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    overflow:hidden;
    background:
        radial-gradient(circle at 15% 20%, rgba(0,255,255,0.16), transparent 30%),
        radial-gradient(circle at 85% 80%, rgba(255,0,180,0.14), transparent 30%),
        radial-gradient(circle at 60% 10%, rgba(120,80,255,0.12), transparent 25%),
        linear-gradient(135deg,#020617,#0b1120,#000000);
    animation:bgShift 14s ease-in-out infinite alternate;
}

@keyframes bgShift{
    from{background-position:0 0;}
    to{background-position:100% 100%;}
}

.orb{
    position:fixed;
    border-radius:50%;
    filter:blur(70px);
    opacity:0.35;
    pointer-events:none;
    animation:float 12s ease-in-out infinite;
}

.orb1{
    width:380px;height:380px;
    left:-90px;top:-90px;
    background:radial-gradient(circle,#00c6ff,transparent 70%);
}

.orb2{
    width:420px;height:420px;
    right:-110px;bottom:-110px;
    background:radial-gradient(circle,#ff2e88,transparent 70%);
    animation-delay:2s;
}

.orb3{
    width:260px;height:260px;
    left:55%;top:-80px;
    background:radial-gradient(circle,#8e2de2,transparent 70%);
    animation-delay:4s;
}

@keyframes float{
    0%,100%{transform:translateY(0) scale(1);}
    50%{transform:translateY(-35px) scale(1.08);}
}

.card{
    position:relative;
    width:560px;
    max-width:95%;
    padding:48px 44px 34px;
    border-radius:30px;
    background:rgba(15,23,42,0.55);
    backdrop-filter:blur(26px);
    -webkit-backdrop-filter:blur(26px);
    border:1px solid rgba(255,255,255,0.14);
    box-shadow:
        0 30px 80px rgba(0,0,0,0.6),
        0 0 60px rgba(0,198,255,0.10),
        inset 0 0 40px rgba(255,255,255,0.03);
    animation:pop 0.8s cubic-bezier(0.18,1.25,0.4,1);
    transition:all 0.4s ease;
    overflow:hidden;
}

.card::before{
    content:'';
    position:absolute;
    top:-60%;
    left:-20%;
    width:140%;
    height:60%;
    background:linear-gradient(115deg,transparent 40%,rgba(255,255,255,0.12) 50%,transparent 60%);
    transform:rotate(8deg);
    animation:shine 6s ease-in-out infinite;
    pointer-events:none;
}

@keyframes shine{
    0%,55%{transform:translateX(-60%) rotate(8deg);}
    100%{transform:translateX(60%) rotate(8deg);}
}

.card::after{
    content:'';
    position:absolute;
    inset:0;
    border-radius:30px;
    padding:1.5px;
    background:linear-gradient(135deg,#00c6ff,rgba(255,255,255,0.2),#ff2e88);
    -webkit-mask:linear-gradient(#fff 0 0) content-box,linear-gradient(#fff 0 0);
    -webkit-mask-composite:xor;
    mask-composite:exclude;
    pointer-events:none;
    opacity:0.7;
}

.card:hover{
    transform:translateY(-6px);
    box-shadow:
        0 40px 90px rgba(0,0,0,0.7),
        0 0 80px rgba(0,198,255,0.18),
        inset 0 0 40px rgba(255,255,255,0.04);
}

@keyframes pop{
    from{opacity:0;transform:scale(0.82) translateY(30px);}
    to{opacity:1;transform:scale(1) translateY(0);}
}

.logo{
    width:74px;height:74px;
    margin:0 auto 16px;
    display:flex;align-items:center;justify-content:center;
    border-radius:22px;
    background:linear-gradient(135deg,#00c6ff,#8e2de2);
    box-shadow:0 12px 34px rgba(0,198,255,0.45), inset 0 0 14px rgba(255,255,255,0.25);
    font-size:34px;
    font-weight:800;
    color:white;
    text-shadow:0 2px 6px rgba(0,0,0,0.4);
    animation:pop 0.9s ease;
}

h1{
    text-align:center;
    font-size:40px;
    letter-spacing:4px;
    font-weight:800;
    background:linear-gradient(90deg,#fff,#9ae6ff,#fff);
    -webkit-background-clip:text;
    background-clip:text;
    -webkit-text-fill-color:transparent;
    filter:drop-shadow(0 0 18px rgba(0,229,255,0.45));
}

.sub{
    text-align:center;
    color:#94a3b8;
    margin-top:8px;
    margin-bottom:30px;
    font-size:16px;
}

.segmented{
    display:flex;
    justify-content:center;
    gap:8px;
    margin-bottom:26px;
    padding:7px;
    border-radius:16px;
    background:rgba(255,255,255,0.06);
    border:1px solid rgba(255,255,255,0.1);
}

.segmented label{
    flex:1;
    text-align:center;
    padding:12px 10px;
    border-radius:12px;
    font-size:16px;
    font-weight:600;
    color:#cbd5e1;
    cursor:pointer;
    transition:all 0.35s ease;
    border:1px solid transparent;
    user-select:none;
}

.segmented label:hover{
    color:white;
    background:rgba(255,255,255,0.07);
}

.segmented input[type=radio]{
    display:none;
}

.segmented input[type=radio]:checked + span{
    color:white;
    background:linear-gradient(135deg,#00c6ff,#0072ff);
    box-shadow:0 8px 22px rgba(0,114,255,0.5), inset 0 0 10px rgba(255,255,255,0.2);
}

.segmented span{
    display:block;
    padding:12px 10px;
    border-radius:11px;
    transition:all 0.35s ease;
}

.field{
    position:relative;
    margin:14px 0;
}

.field input{
    width:100%;
    padding:18px 20px 18px 52px;
    border:1px solid rgba(255,255,255,0.15);
    border-radius:15px;
    font-size:16px;
    background:rgba(255,255,255,0.07);
    color:white;
    backdrop-filter:blur(10px);
    transition:all 0.35s ease;
}

.field input::placeholder{
    color:#94a3b8;
}

.field .icon{
    position:absolute;
    left:18px;
    top:50%;
    transform:translateY(-50%);
    font-size:19px;
    color:#7dd3fc;
    opacity:0.85;
    pointer-events:none;
}

.field input:hover{
    background:rgba(255,255,255,0.1);
    box-shadow:0 0 18px rgba(0,229,255,0.15);
}

.field input:focus{
    outline:none;
    border-color:#00e5ff;
    box-shadow:0 0 0 1px #00e5ff, 0 0 26px rgba(0,229,255,0.35);
    background:rgba(255,255,255,0.09);
}

.btn{
    position:relative;
    width:100%;
    padding:18px;
    margin-top:22px;
    border:none;
    border-radius:15px;
    background:linear-gradient(135deg,#00c6ff,#0072ff);
    color:white;
    font-size:19px;
    font-weight:700;
    letter-spacing:1px;
    cursor:pointer;
    overflow:hidden;
    transition:all 0.35s ease;
    box-shadow:0 12px 30px rgba(0,114,255,0.4);
}

.btn::before{
    content:'';
    position:absolute;
    top:0;left:-75%;
    width:50%;height:100%;
    background:linear-gradient(115deg,transparent,rgba(255,255,255,0.4),transparent);
    animation:shimmer 2.8s ease-in-out infinite;
}

@keyframes shimmer{
    0%{left:-75%;}
    60%,100%{left:125%;}
}

.btn:hover{
    transform:translateY(-3px);
    box-shadow:0 16px 40px rgba(0,114,255,0.6);
}

.btn:active{
    transform:translateY(0) scale(0.99);
}

#userLinks{
    margin-top:22px;
    text-align:center;
}

#userLinks a{
    color:#7dd3fc;
    text-decoration:none;
    font-size:15px;
    font-weight:500;
    transition:all 0.3s ease;
}

#userLinks a:hover{
    color:white;
    text-shadow:0 0 12px #00e5ff;
}

.credit{
    margin-top:26px;
    text-align:center;
    font-size:12px;
    color:#22c55e;
    letter-spacing:0.5px;
    opacity:0.9;
}
</style>

<script>
function toggleLinks() {
    let user = document.querySelector('input[value="user"]').checked;
    let links = document.getElementById("userLinks");

    if(user){
        links.style.display = "block";
    }else{
        links.style.display = "none";
    }
}

window.onload = toggleLinks;
</script>

</head>

<body>

<div class="orb orb1"></div>
<div class="orb orb2"></div>
<div class="orb orb3"></div>

<div class="card">

    <div class="logo">LO</div>
    <h1>LOGIN</h1>
    <p class="sub">Welcome! Please login to continue</p>

    <form action="login" method="post">

        <div class="segmented">
            <label>
                <input type="radio" name="type" value="user" checked onclick="toggleLinks()">
                <span>User</span>
            </label>
            <label>
                <input type="radio" name="type" value="admin" onclick="toggleLinks()">
                <span>Admin</span>
            </label>
            <label>
                <input type="radio" name="type" value="teacher" onclick="toggleLinks()">
                <span>Teacher</span>
            </label>
        </div>

        <div class="field">
            <span class="icon">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
            </span>
            <input type="text" name="username" placeholder="Username" required>
        </div>

        <div class="field">
            <span class="icon">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
            </span>
            <input type="password" name="password" placeholder="Password" required>
        </div>

        <button type="submit" class="btn">Login</button>

        <div id="userLinks">
            <br>
            <a href="register.jsp">Don't have account? Register</a>
            <br><br>
            <a href="forgotpassword.jsp">Forgot Password?</a>
        </div>

    </form>

    <div class="credit">Created by KM Aravindayya</div>
</div>

</body>
</html>
