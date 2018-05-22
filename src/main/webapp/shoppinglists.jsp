<%-- 
    Document   : shoppinglists
    Created on : 21-apr-2018
    Author     : Stefano Chirico &lt;chirico dot stefano at parcoprogetti dot com&gt;
--%>

<%@page import="java.util.List"%>
<%@page import="it.unitn.aa1718.webprogramming.lab09.shoppingList.dao.entities.ShoppingList"%>
<%@page import="it.unitn.aa1718.webprogramming.persistence.utils.dao.exceptions.DAOException"%>
<%@page import="it.unitn.aa1718.webprogramming.lab09.shoppingList.dao.ShoppingListDAO"%>
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
        <title>Lab 09: Shopping lists shared with${user.firstName} ${user.lastName}</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <!-- Latest compiled and minified CSS -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" crossorigin="anonymous">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.8/css/all.css" crossorigin="anonymous">
        <link rel="stylesheet" href="css/floating-labels.css">
        <link rel="stylesheet" href="css/forms.css">
    </head>
    <body>
        <div class="container-fluid">
            <div class="card border-primary">
                <div class="card-header bg-primary text-white">
                    <h1>Benvenuto, qui puoi gestire le tue liste della spesa</h1>
                </div>
                <div class="card-body">
                    The following table lists all the shopping-lists shared with &quot;${user.firstName} ${user.lastName}&quot;.<br>
                </div>

                <!-- Shopping Lists cards -->
                <div id="accordion">
                    <c:choose>
                        <c:when test="${empty shoppingLists}">
                    <div class="card">
                        <div class="card-body">
                            <button type="button" class="btn btn-outline-light bg-light text-primary btn-sm mx-auto" data-toggle="modal" data-target="#editDialog">Non hai liste, creane una</i></button>
                        </div>
                    </div>
                        </c:when>
                        <c:otherwise>
                    <%
                        int index = 1;
                    %>
                    <c:forEach var="shoppingList" items="${shoppingLists}">
                    <div class="card">
                        <div class="card-header" id="heading<%=index%>">
                            <h5 class="mb-0">
                                <button class="btn btn-link" data-toggle="collapse" data-target="#collapse${index}" aria-expanded="true" aria-controls="collapse${index}">
                                    ${shoppingList.name}
                                </button>
                                    <div class="float-right"><a href="<c:url context="${contextPath}" value="/restricted/edit.shopping.list.html?id=${shoppingList.id}" />" class="fas fa-pen-square" title="edit &quot;${shoppingList.name}&quot; shopping list" data-toggle="modal" data-target="#editDialog" data-shopping-list-id="${shoppingList.id}" data-shopping-list-name="${shoppingList.name}" data-shopping-list-description="${shoppingList.description}"></a></div>
                            </h5>
                        </div>
                        <div id="collapse${index}" class="collapse<%=(index == 1 ? " show" : "")%>" aria-labelledby="heading<%=(index++)%>" data-parent="#accordion">
                            <div class="card-body">
                                ${shoppingList.description}
                            </div>
                        </div>
                    </div>
                    </c:forEach>
                    </c:otherwise>
                    </c:choose>
                </div>                    
                <div class="card-footer"><span class="float-left">Copyright bbbb</span>
                    <c:choose>
                        <c:when test="${sessionScope.user.email eq 'stefano.chirico@unitn.it'}">
                    <a class="float-right" href="users.html"><button type="button" class="btn btn-primary btn-sm">Go to Users List</button></a>
                        </c:when>
                        <c:otherwise>
                    <a class="float-right" href="logout.handler"><button type="button" class="btn btn-primary btn-sm">Logout</button></a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
        <!-- create/edit shopping list modal dialog (#editDialog) -->
        <form action="shopping.lists.handler" method="POST">
            <div class="modal fade" id="editDialog" tabindex="-1" role="dialog" aria-labelledby="titleLabel">
                <div class="modal-dialog modal-dialog-centered" role="document">
                    <div class="modal-content">
                        <div class="modal-header">            
                            Categorie disponibili                 
                        </div>
                        <div class="modal-body">
                            <ul>
                                <li><a href="ServletPerMostrareProdotti"><u>Supermercato</u></a></li>
                                <li><a href="ServletPerMostrareProdotti"><u>Farmacia</u></a></li></li>
                            </ul>
                        </div>
                        <div class="modal-footer">
                            <button type="submit" class="btn btn-primary" id="editDialogSubmit">Create</button>
                            <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                        </div>
                    </div>
                </div>
            </div>
        </form>
        <!-- Latest compiled and minified JavaScript -->
        <script src="https://code.jquery.com/jquery-3.2.1.min.js" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.18.1/moment.min.js" crossorigin="anonymous"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" crossorigin="anonymous"></script>
        <script type="text/javascript">
            $(function () {
                $("#editDialog").on("show.bs.modal", function (e) {
                    var target = $(e.relatedTarget);
                    var shoppingListId = target.data("shopping-list-id");
                    if (shoppingListId !== undefined) {
                        var shoppingListName = target.data("shopping-list-name");
                        var shoppingListDescription = target.data("shopping-list-description");

                        $("#titleLabel").html("Edit Shopping List (" + shoppingListId + ")");
                        $("#editDialogSubmit").html("Update");
                        $("#idShoppingList").val(shoppingListId);
                        $("#name").val(shoppingListName);
                        $("#description").val(shoppingListDescription);
                    } else {
                        $("#titleLabel").html("Create new Shopping List");
                        $("#editDialogSubmit").html("Create");
                    }
                });
            });
        </script>

    </body>
</html>
</c:catch>
<c:if test="${not empty ex}">
    <jsp:scriptlet>
        response.sendError(500, ((Exception) pageContext.getAttribute("ex")).getMessage());
    </jsp:scriptlet>
</c:if>
