<html>
<body>

<h2>Enter Details Password</h2>

<form action="details.jsp" method="post">
    <input type="hidden" name="id"
           value="<%= request.getParameter("id") %>">

    Password:
    <input type="password" name="password" required>

    <input type="submit" value="Open Details">
</form>

</body>
</html>