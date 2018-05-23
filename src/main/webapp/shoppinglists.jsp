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
            <title>Lista della spesa</title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <!-- Latest compiled and minified CSS -->
            <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" crossorigin="anonymous">
            <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.8/css/all.css" crossorigin="anonymous">
            <link rel="stylesheet" href="css/floating-labels.css">
            <link rel="stylesheet" href="css/forms.css">
        </head>
        <body class="bg-info">
            <!-- Altrimenti, container-fluid -->
            <div class="container">
                <div class="card border-primary">
                    <div class="card-header bg-success text-white">
                        <h1>Ciao ${user.firstName}, cosa vuoi fare oggi?
                            <c:choose>
                                <c:when test="${sessionScope.user.email eq 'stefano.chirico@unitn.it'}">
                                    <a class="float-right" href="users.html"><button type="button" class="btn btn-primary btn-sm">Go to Users List</button></a>
                                </c:when>
                                <c:otherwise>
                                    <a class="float-right" href="logout.handler"><button type="button" class="btn btn-primary btn-sm">Logout</button></a>
                                </c:otherwise>
                            </c:choose>
                        </h1>
                    </div>
                </div>
                <div class="card-body">
                    <h2>Qui puoi gestire le tue liste della spesa.</h2>
                    <h3>Creane una nuova o modificane una esistente.</h3>
                </div>

                <div class="container">
                    <div class="row">  
                        <!-- Prima colonna del grid. Contiene il box per aggiungere una nuova lista della spesa. -->
                        <div class="col-sm">
                            <div class="card" style="width: 20rem;">
                                <img class="card-img-top" src="http://www.radiosubasio.it/wp-content/uploads/2013/09/LISTA-SPESA-OK.jpg" alt="Card image cap">
                                <div class="card-body">
                                    <h5 class="card-title">Nuova lista della spesa</h5>
                                    <p class="card-text">Aggiungi una nuova lista della spesa. Provvederemo noi a salvarla.</p>
                                    <a href="#" class="btn btn-outline-primary">Aggiungi</a>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm">
                            <!-- Seconda colonna del grid. Conterrà l'accordion, che visualizza tutte le liste della spesa di un utente. -->
                            <div id="accordion">
                                <c:choose>
                                    <c:when test="${empty shoppingLists}">
                                        <div class="card" style="width: 22rem;">
                                            <div class="card-body">
                                                <h5 class="card-title">Inventario vuoto</h5>
                                                <p class="card-text">Non hai ancora nessuna lista della spesa.<br>Aggiungine una per visualizzarla nell'elenco.</p>
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
                        </div>
                    </div>
                </div>
            </div>
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
