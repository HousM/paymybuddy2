<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
    <title>Pay My Buddy</title>
    <!-- css -->
    <link rel="stylesheet" type="text/css" href="bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="login.css">
</head>
<body>

<div class="container-fluid">
    <div class="container">
        <section>
            <p><em>Pay My Buddy</em></p>
            <form method="post" action="/login">
            <p><input type="email" style="background-image: url(/email.png);background-position: left; background-repeat: no-repeat" placeholder="Email" id="email" name="email"></p>
            <p><input type="password" style="background-image: url(/pwd.png); background-position: left; background-repeat: no-repeat" placeholder="Password" id="password" name="password"></p>
            <p><input type="checkbox" id="remember" name="Remember me">
                <label for="remember">Remember me</label></p>
            <p><button class="login" type="submit">Login</button></p>
            </form>
        </section>
    </div>
</div>
</body>
</html>