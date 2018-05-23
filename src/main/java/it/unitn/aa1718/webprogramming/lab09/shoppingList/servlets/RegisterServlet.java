package it.unitn.aa1718.webprogramming.lab09.shoppingList.servlets;

import it.unitn.aa1718.webprogramming.lab09.shoppingList.dao.UserDAO;
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
 * Servlet that handles the login web page.
 *
 * @author Stefano Chirico &lt;stefano dot chirico at unitn dot it&gt;
 * @since 2018.04.21
 */
public class RegisterServlet extends HttpServlet {

    private UserDAO userDao;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
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
     * @author Federico Pallaver
     *
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            
        try {
            Long id = userDao.getCount() + 1;
            String email = request.getParameter("username");
            String password = request.getParameter("password");
            String name = request.getParameter("name");
            String lastname = request.getParameter("lastname");
            Boolean isAdmin = false;
            String avatarPath = "default-path";

            String contextPath = getServletContext().getContextPath();
            if (!contextPath.endsWith("/")) {
                contextPath += "/";
            }
            
            Boolean registered = userDao.insert(id, email, password, name, lastname, isAdmin, avatarPath);
            if(registered == true){
                //se l'inserimento è risultato corretto dovremmo rimandarlo alla pagina di login
            }
           
            
            
            /* if (user == null) {
                request.getServletContext().log("\n\n\nUser = NULL\n\n\n");
                response.sendRedirect(response.encodeRedirectURL(contextPath + "login.html"));
            } else {
                request.getSession().setAttribute("user", user);
                if (user.getEmail().equals("stefano.chirico@unitn.it")) {
                    request.getServletContext().log("\n\n\nUser is equal to Stefano Chirico\n\n\n");
                    response.sendRedirect(response.encodeRedirectURL(contextPath + "restricted/users.html"));
                } else {
                    request.getServletContext().log("\n\n\nUser is NOT equal to Stefano Chirico\n\n\n");
                    response.sendRedirect(response.encodeRedirectURL(contextPath + "restricted/shopping.lists.html?id=" + user.getId()));
                }
            }
        } */ }
           catch (DAOException ex) {
                
            request.getServletContext().log("Impossible to retrieve the user", ex);
        }
    }
}
