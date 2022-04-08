<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
    <title>Pay My Buddy</title>
    <!-- css -->
    <link rel="stylesheet" href="bootstrap.min.css">
    <link rel="stylesheet" href="register.css">
</head>
<body>

<div class="container-fluid">
    <div class="container">
        <section>
            <p><em>Register</em></p>
            <form method="post" action="/newuser">
            <p><input type="text" placeholder="Firstname" id="firstname" name="firstname"></p>
            <p><input type="text" placeholder="Lastname" id="lastname" name="lastname"></p>
            <p><input type="email" style="background-image: url(/email.png);background-position: left; background-repeat: no-repeat" placeholder="Email" id="email" name="email"></p>
            <p><input type="password" style="background-image: url(/password.png); background-position: left; background-repeat: no-repeat" placeholder="Password" id="password" name="password"></p>
            <p><button class="login" type="submit">Register</button></p>
            </form>
        </section>
    </div>
</div>
</body>
</html>