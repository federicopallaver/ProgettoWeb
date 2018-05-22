<%-- 
    Document   : users
    Created on : 21-apr-2018
    Author     : Stefano Chirico &lt;chirico dot stefano at parcoprogetti dot com&gt;
--%>
<%@page import="java.util.List"%>
<%@page import="it.unitn.aa1718.webprogramming.persistence.utils.dao.exceptions.DAOException"%>
<%@page import="it.unitn.aa1718.webprogramming.lab09.shoppingList.dao.entities.User"%>
<%@page import="it.unitn.aa1718.webprogramming.persistence.utils.dao.exceptions.DAOFactoryException"%>
<%@page import="it.unitn.aa1718.webprogramming.persistence.utils.dao.factories.DAOFactory"%>
<%@page import="it.unitn.aa1718.webprogramming.lab09.shoppingList.dao.UserDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:catch var="ex">
    <!DOCTYPE html>
    <html>
        <head>
            <title>Lab 09: Users List</title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <!-- Latest compiled and minified CSS -->
            <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" crossorigin="anonymous">
            <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.8/css/all.css" crossorigin="anonymous">
            <link rel="stylesheet" href="../css/floating-labels.css">
            <link rel="stylesheet" href="../css/forms.css">
        </head>
        <body>
            <div class="container-fluid">
                <div class="card border-primary">
                    <div class="card-header bg-primary text-white">
                        <h5 class="card-title">Users</h5>
                    </div>
                    <div class="card-body">
                        The following table lists all the users of the application.<br>
                        For each user, you can see the count of shopping-lists shared with him.<br>
                        Clicking on the number of shopping-lists, you can show the collection of shopping-lists shared with &quot;selected&quot; user.
                    </div>

                    <!-- Table -->
                    <div class="table-responsive">
                        <table class="table table-sm table-hover">
                            <thead>
                                <tr>
                                    <th>Email</th>
                                    <th>First name</th>
                                    <th>Last name</th>
                                    <th>Shopping Lists</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="user" items="${userDao.all}">
                                    <tr>
                                        <td>${user.email}</td>
                                        <td>${user.firstName}</td>
                                        <td><${user.lastName}></td>
                                        <td><a href="<c:url context="${contextPath}" value="/restricted/shopping.lists.html?id=${user.id}" />"><span class="badge badge-primary badge-pill">${user.shoppingListsCount}</span></a></td>
                                        <c:choose>
                                            <c:when test="${pageScope.user.email eq sessionScope.user.email}">
                                                <td><a href="<c:url context="${contextPath}" value="/restricted/editUser.html?id=${user.id}}" />" title="edit user" data-toggle="modal" data-target="#myModal"><i class="fas fa-pen-square fa-lg"></i></a></td>
                                            </c:when>
                                            <c:otherwise>
                                                <td></td>
                                            </c:otherwise>
                                        </c:choose>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <div class="card-footer"><span class="float-left">Copyright &copy; 2018 - Stefano Chirico</span><a href="<c:url context="${contextPath}" value="/restricted/logout.handler" />" class="float-right"><button type="button" class="btn btn-primary btn-sm">Logout</button></a></div>
                </div>
            </div>
            <!-- Modal -->
            <form action="<c:url context="${contextPath}" value="/restricted/user.handler" />" method="POST"  enctype="multipart/form-data">
                <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
                    <div class="modal-dialog modal-dialog-centered" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h4 class="modal-title" id="myModalLabel">Configure ${sessionScope.user.email}</h4>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true"><i class="fas fa-window-close red-window-close"></i></span></button>
                            </div>
                            <div class="modal-body">
                                <input type="hidden" name="idUser" value="${sessionScope.user.id}">
                                <div class="form-label-group">
                                    <input type="file" name="avatar" id="avatar" placeholder="Avatar" value="${sessionScope.user.avatarPath}">
                                    <label for="avatar">Avatar</label>
                                    <img src="${avatarPath}" class="img-thumbnail">
                                </div>
                                <div class="form-label-group">
                                    <input type="text" name="lastname" id="lastname" class="form-control" placeholder="Last name" value="${sessionScope.user.lastName}" required autofocus>
                                    <label for="lastname">Last name</label>
                                </div>
                                <div class="form-label-group">
                                    <input type="text" name="firstname" id="firstname" class="form-control" placeholder="First name" value="${sessionScope.user.firstName}" required>
                                    <label for="firstname">Name</label>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="submit" class="btn btn-primary">Save</button>
                                <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
            <!-- Latest compiled and minified JavaScript -->
            <script src="https://code.jquery.com/jquery-3.2.1.min.js" crossorigin="anonymous"></script>
            <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" crossorigin="anonymous"></script>
        </body>
    </html>
</c:catch>
<c:if test="${not empty ex}">
    <jsp:scriptlet>
        response.sendError(500, ((Exception) pageContext.getAttribute("ex")).getMessage());
    </jsp:scriptlet>
</c:if>