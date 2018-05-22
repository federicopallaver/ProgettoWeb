/*
 * AA 2017-2018
 * Introduction to Web Programming
 * Lab 09 - ShoppingList List
 * UniTN
 */
package it.unitn.aa1718.webprogramming.lab09.shoppingList.servlets;

import it.unitn.aa1718.webprogramming.lab09.shoppingList.dao.ShoppingListDAO;
import it.unitn.aa1718.webprogramming.lab09.shoppingList.dao.UserDAO;
import it.unitn.aa1718.webprogramming.lab09.shoppingList.dao.entities.ShoppingList;
import it.unitn.aa1718.webprogramming.lab09.shoppingList.dao.entities.User;
import it.unitn.aa1718.webprogramming.persistence.utils.dao.exceptions.DAOException;
import it.unitn.aa1718.webprogramming.persistence.utils.dao.exceptions.DAOFactoryException;
import it.unitn.aa1718.webprogramming.persistence.utils.dao.factories.DAOFactory;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet that handles the shopping lists actions.
 *
 * @author Stefano Chirico &lt;stefano dot chirico at unitn dot it&gt;
 * @since 2018.04.21
 */
public class ShoppingListsServlet extends HttpServlet {
    private ShoppingListDAO shoppingListDao;
    private UserDAO userDao;
    
    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        try {
            shoppingListDao = daoFactory.getDAO(ShoppingListDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for shopping-list storage system", ex);
        }
        try {
            userDao = daoFactory.getDAO(UserDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for user storage system", ex);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     * 
     * @author Stefano Chirico
     * @since 2018.04.21
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Integer userId = null;
        try {
            userId = Integer.valueOf(request.getParameter("idUser"));
        } catch (RuntimeException ex) {
            //TODO: log the exception
        }
        Integer shoppingListId = null;
        try {
            shoppingListId = Integer.valueOf(request.getParameter("idShoppingList"));
        } catch (RuntimeException ex) {
            //TODO: log the exception
        }
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        
        
        try {
            ShoppingList shoppingList = new ShoppingList();
            shoppingList.setId(shoppingListId);
            shoppingList.setName(name);
            shoppingList.setDescription(description);

            User user = userDao.getByPrimaryKey(userId);

            if (shoppingListId == null) {
                shoppingListDao.insert(shoppingList);
            } else {
                shoppingListDao.update(shoppingList);
            }
            shoppingListDao.linkShoppingListToUser(shoppingList, user);
        } catch (DAOException ex) {
            //TODO: log exception
        }

        String contextPath = getServletContext().getContextPath();
        if (!contextPath.endsWith("/")) {
            contextPath += "/";
        }

        response.sendRedirect(response.encodeRedirectURL(contextPath + "restricted/shopping.lists.html?id=" + userId));
    }
}
