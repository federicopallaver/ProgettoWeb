/*
 * AA 2017-2018
 * Introduction to Web Programming
 * Lab 09 - ShoppingList List
 * UniTN
 */
package it.unitn.aa1718.webprogramming.lab09.shoppingList.dao;

import it.unitn.aa1718.webprogramming.lab09.shoppingList.dao.entities.ShoppingList;
import it.unitn.aa1718.webprogramming.lab09.shoppingList.dao.entities.User;
import it.unitn.aa1718.webprogramming.persistence.utils.dao.DAO;
import it.unitn.aa1718.webprogramming.persistence.utils.dao.exceptions.DAOException;
import java.util.List;

/**
 * All concrete DAOs must implement this interface to handle the persistence 
 * system that interact with {@link ShoppingList shopping-lists}.
 * 
 * @author Stefano Chirico &lt;stefano dot chirico at unitn dot it&gt;
 * @since 2018.04.21
 */
public interface ShoppingListDAO extends DAO<ShoppingList, Integer> {
    /**
     * Persists the new {@link ShoppingList shopping-list} passed as parameter
     * to the storage system.
     * @param shoppingList the new {@code shopping-list} to persist.
     * @return the id of the new persisted record.
     * @throws DAOException if an error occurred during the persist action.
     * 
     * @author Stefano Chirico
     * @since 1.0.180421
     */
    public Integer insert(ShoppingList shoppingList) throws DAOException;
    
    /**
     * Persists the already existing {@link ShoppingList shopping-list} passed
     * as parameter to the storage system.
     * @param shoppingList the {@code shopping-list} to persist.
     * @return the old record.
     * @throws DAOException if an error occurred during the persist action.
     * 
     * @author Stefano Chirico
     * @since 1.0.180421
     */
    public ShoppingList update(ShoppingList shoppingList) throws DAOException;
    
    /**
     * Links the passed {@code shopping_list} with the passed {@code user}.
     * @param shoppingList the shopping_list to link.
     * @param user the user to link.
     * @return {@code true} if the link has correctly persisted on the storage
     * system.
     * @throws DAOException if an error occurred during the persist action.
     * 
     * @author Stefano Chirico
     * @since 1.0.180421
     */
    public boolean linkShoppingListToUser(ShoppingList shoppingList, User user) throws DAOException;
    
    /**
     * Returns the list of {@link ShoppingList shopping-lists} with the
     * {@code id_user} is the one passed as parameter.
     *
     * @param userId the {@code id} of the {@code user} for which retrieve the
     * shopping-lists list.
     * @return the list of {@code shopping-list} with the user id equals to the
     * one passed as parameter or an empty list if user id is not linked to any
     * to-dos.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     *
     * @author Stefano Chirico
     * @since 1.0.180421
     */
    public List<ShoppingList> getByUserId(Integer userId) throws DAOException;
}
