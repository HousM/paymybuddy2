<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
    <title>Pay My Buddy</title>
    <!-- css -->
    <link rel="stylesheet" href="bootstrap.min.css">
    <link rel="stylesheet" href="profil.css">

</head>
<header>
    <section id="entete">
        <p><em>Pay My Buddy</em></p>
        <div id="liens" style="float: right">
            <a href="/login">Home</a>
            <a href="/transfer">Transfert</a>
            <a href="/profil">Profil</a>
            <a href="/contact">Contact</a>
            <a href="/logoff">Log off</a></br>
        </div>
    </section>
    <p id="pages">Home / Profil</p>
</header>
<body>
<h5>My Profile</h5>
<div id="data">
<table id="table-firstname">
    <thead>
            <tr class="text-white">
                <th>Firstname : </th>
            </tr>
    </thead>
    <tbody>
    <c:catch var="userDetails">
        <tr>
            <td>${userDetails.firstname}</td>
        </tr>
    </c:catch>
    </tbody>
</table>
</br>
<table id="table-lastname">
    <thead>
        <tr class="text-white">
            <th>Lastname : </th>
        </tr>
    </thead>
    <tbody>
    <c:catch var="userDetails">
        <tr>
            <td>${userDetails.lastname}</td>
        </tr>
    </c:catch>
    </tbody>
</table>
</br>
<table id="table-email">
    <thead>
    <tr class="text-white">
        <th>Email : </th>
    </tr>
    </thead>
    <tbody>
    <c:catch var="userDetails">
        <tr>
            <td>${userDetails.email}</td>
        </tr>
    </c:catch>
    </tbody>
</table>
</br>
</div>
</body>
</html>