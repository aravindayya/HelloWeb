<html>
<head>
<style>
body{
    margin:0;
    height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    font-family:Arial, sans-serif;
    background: linear-gradient(135deg,#74ebd5,#ACB6E5);
}

.login-box{
    background:white;
    width:350px;
    padding:35px;
    border-radius:20px;
    box-shadow:0 8px 25px rgba(0,0,0,0.25);
    text-align:center;
    animation: fadeIn 1s ease;
}

h2{
    margin-bottom:25px;
    color:#333;
}

label{
    display:block;
    text-align:left;
    margin-top:12px;
    font-weight:bold;
}

input[type=text],
input[type=password]{
    width:100%;
    padding:12px;
    margin-top:6px;
    border:1px solid #ccc;
    border-radius:8px;
    box-sizing:border-box;
    transition:0.3s;
}

input[type=text]:focus,
input[type=password]:focus{
    border-color:#4CAF50;
    box-shadow:0 0 8px rgba(76,175,80,0.5);
    outline:none;
}

input[type=submit]{
    width:100%;
    margin-top:25px;
    padding:12px;
    background:#4CAF50;
    color:white;
    border:none;
    border-radius:8px;
    font-size:16px;
    cursor:pointer;
    transition:0.3s;
}

input[type=submit]:hover{
    transform:scale(1.05);
    box-shadow:0 5px 15px rgba(0,0,0,0.2);
    background:#45a049;
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

<div class="login-box">
    <h2>Admin Login</h2>

    <form action="adminlogin" method="post">
        <label>Username</label>
        <input type="text" name="username" required>

        <label>Password</label>
        <input type="password" name="password" required>

        <input type="submit" value="Login">
    </form>
</div>

</body>
</html>