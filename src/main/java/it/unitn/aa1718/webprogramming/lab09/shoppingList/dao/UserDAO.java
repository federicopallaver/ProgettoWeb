/*
 * AA 2017-2018
 * Introduction to Web Programming
 * Lab 09 - ShoppingList List
 * UniTN
 */
package it.unitn.aa1718.webprogramming.lab09.shoppingList.dao;

import it.unitn.aa1718.webprogramming.lab09.shoppingList.dao.entities.User;
import it.unitn.aa1718.webprogramming.persistence.utils.dao.DAO;
import it.unitn.aa1718.webprogramming.persistence.utils.dao.exceptions.DAOException;

/**
 * All concrete DAOs must implement this interface to handle the persistence 
 * system that interact with {@link User users}.
 * 
 * @author Stefano Chirico &lt;stefano dot chirico at unitn dot it&gt;
 * @since 2018.04.21
 */
public interface UserDAO extends DAO<User, Integer> {
    /**
     * Returns the {@link User user} with the given {@code email} and
     * {@code password}.
     * @param email the email of the user to get.
     * @param password the password of the user to get.
     * @return the {@link User user} with the given {@code username} and
     * {@code password}..
     * @throws DAOException if an error occurred during the information
     * retrieving.
     * 
     * @author Stefano Chirico
     * @since 1.0.180421
     */
    public User getByEmailAndPassword(String email, String password) throws DAOException;
    
    /**
     * Update the user passed as parameter and returns it.
     * @param user the user used to update the persistence system.
     * @return the updated user.
     * @throws DAOException if an error occurred during the action.
     * 
     * @author Stefano Chirico
     * @since 1.0.180421
     */
    public User update(User user) throws DAOException;
}
