<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html>
<head>
<title>Login</title>

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
    overflow:hidden;
    background:
        radial-gradient(circle at 20% 20%, rgba(0,255,255,0.18), transparent 25%),
        radial-gradient(circle at 80% 80%, rgba(255,0,255,0.18), transparent 25%),
        radial-gradient(circle at 50% 50%, rgba(255,255,255,0.08), transparent 40%),
        linear-gradient(135deg,#0f172a,#000000);
}

.card{
    width:540px;
    max-width:95%;
    padding:45px;
    border-radius:35px;
    background:rgba(255,255,255,0.06);
    backdrop-filter:blur(24px);
    border:1px solid rgba(255,255,255,0.12);
    box-shadow:
        0 0 40px rgba(255,255,255,0.08),
        0 0 100px rgba(0,255,255,0.08),
        inset 0 0 20px rgba(255,255,255,0.03);
    animation:pop 0.9s ease;
    transition:all 0.4s ease;
}

.card:hover{
    transform:translateY(-6px);
    box-shadow:
        0 0 60px rgba(0,255,255,0.15),
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
    color:white;
    font-size:52px;
    letter-spacing:3px;
    text-shadow:0 0 20px rgba(255,255,255,0.8);
}

.sub{
    text-align:center;
    color:#d1d5db;
    margin-top:12px;
    margin-bottom:35px;
    font-size:18px;
}

.radioBox{
    display:flex;
    justify-content:center;
    gap:20px;
    margin-bottom:28px;
    color:white;
}

.radioBox label{
    padding:12px 18px;
    border-radius:14px;
    background:rgba(255,255,255,0.08);
    backdrop-filter:blur(10px);
    transition:all 0.35s ease;
    font-size:20px;
    cursor:pointer;
}

.radioBox label:hover{
    transform:translateY(-3px) scale(1.05);
    box-shadow:0 0 18px rgba(0,255,255,0.2);
}

input[type=text],
input[type=password]{
    width:100%;
    padding:18px;
    margin:14px 0;
    border:1px solid rgba(255,255,255,0.15);
    border-radius:16px;
    font-size:18px;
    background:rgba(255,255,255,0.08);
    color:white;
    backdrop-filter:blur(12px);
    transition:all 0.35s ease;
}

input::placeholder{
    color:#cbd5e1;
}

input:hover{
    transform:translateY(-2px);
    box-shadow:0 0 15px rgba(0,255,255,0.15);
}

input:focus{
    outline:none;
    border-color:#00e5ff;
    box-shadow:
        0 0 15px #00e5ff,
        0 0 35px rgba(0,229,255,0.25);
}

button{
    width:100%;
    padding:18px;
    margin-top:24px;
    border:none;
    border-radius:16px;
    background:linear-gradient(135deg,#00c6ff,#0072ff);
    color:white;
    font-size:26px;
    font-weight:bold;
    cursor:pointer;
    transition:all 0.35s ease;
}

button:hover{
    transform:translateY(-4px) scale(1.03);
    box-shadow:
        0 0 25px rgba(0,114,255,0.5),
        0 0 50px rgba(0,198,255,0.25);
}

#userLinks{
    margin-top:25px;
}

#userLinks a{
    color:#7dd3fc;
    text-decoration:none;
    font-size:18px;
    transition:all 0.3s ease;
}

#userLinks a:hover{
    color:white;
    text-shadow:0 0 12px #00e5ff;
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

<div class="card">
    <h1>LOGIN</h1>
    <p class="sub">Welcome! Please login to continue</p>

    <form action="login" method="post">

        <div class="radioBox">
            <label>
                <input type="radio" name="type" value="user"
                       checked onclick="toggleLinks()"> User
            </label>

            <label>
                <input type="radio" name="type" value="admin"
                       onclick="toggleLinks()"> Admin
            </label>

            <label>
                <input type="radio" name="type" value="teacher"
                       onclick="toggleLinks()"> Teacher
            </label>
        </div>

        <input type="text" name="username" placeholder="Username" required>

        <input type="password" name="password" placeholder="Password" required>

        <button type="submit">Login</button>

        <div id="userLinks">
            <br><br>
            <center>
                <a href="register.jsp">Don't have account? Register</a>
                <br><br>
                <a href="forgotpassword.jsp">Forgot Password?</a>
            </center>
        </div>

    </form>
</div>

</body>
</html>