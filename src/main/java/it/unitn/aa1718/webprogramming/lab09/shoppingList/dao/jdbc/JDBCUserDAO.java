/*
 * AA 2017-2018
 * Introduction to Web Programming
 * Lab 09 - ShoppingList List
 * UniTN
 */
package it.unitn.aa1718.webprogramming.lab09.shoppingList.dao.jdbc;

import it.unitn.aa1718.webprogramming.lab09.shoppingList.dao.UserDAO;
import it.unitn.aa1718.webprogramming.lab09.shoppingList.dao.entities.User;
import it.unitn.aa1718.webprogramming.persistence.utils.dao.exceptions.DAOException;
import it.unitn.aa1718.webprogramming.persistence.utils.dao.jdbc.JDBCDAO;
import java.io.Console;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * The JDBC implementation of the {@link UserDAO} interface.
 *
 * @author Stefano Chirico &lt;stefano dot chirico at unitn dot it&gt;
 * @since 2018.04.21
 */
public class JDBCUserDAO extends JDBCDAO<User, Integer> implements UserDAO {

    /**
     * The default constructor of the class.
     *
     * @param con the connection to the persistence system.
     *
     * @author Stefano Chirico
     * @since 1.0.180421
     */
    public JDBCUserDAO(Connection con) {
        super(con);
    }

    /**
     * Returns the number of {@link User users} stored on the persistence system
     * of the application.
     *
     * @return the number of records present into the storage system.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     *
     * @author Stefano Chirico
     * @since 1.0.180421
     */
    @Override
    public Long getCount() throws DAOException {
        try (Statement stmt = CON.createStatement()) {
            ResultSet counter = stmt.executeQuery("SELECT COUNT(*) FROM users");
            if (counter.next()) {
                return counter.getLong(1);
            }

        } catch (SQLException ex) {
            throw new DAOException("Impossible to count users", ex);
        }

        return 0L;
    }

    /**
     * Returns the {@link User user} with the primary key equals to the one
     * passed as parameter.
     *
     * @param primaryKey the {@code id} of the {@code user} to get.
     * @return the {@code user} with the id equals to the one passed as
     * parameter or {@code null} if no entities with that id are present into
     * the storage system.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     *
     * @author Stefano Chirico
     * @since 1.0.180421
     */
    @Override
    public User getByPrimaryKey(Integer primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM users WHERE id = ?")) {
            stm.setInt(1, primaryKey);
            try (ResultSet rs = stm.executeQuery()) {

                rs.next();
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setFirstName(rs.getString("name"));
                user.setLastName(rs.getString("lastname"));
                user.setAvatarPath(rs.getString("avatarPath"));
                user.setIsAdmin(rs.getBoolean("isAdmin"));
                
                try (PreparedStatement todoStatement = CON.prepareStatement("SELECT count(*) FROM USER_SHOPPING_LISTS WHERE id_user = ?")) {
                    todoStatement.setInt(1, user.getId());

                    ResultSet counter = todoStatement.executeQuery();
                    counter.next();
                    user.setShoppingListsCount(counter.getInt(1));
                }

                return user;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the user for the passed primary key", ex);
        }
    }

    /**
     * Returns the {@link User user} with the given {@code email} and
     * {@code password}.
     *
     * @param email the email of the user to get.
     * @param password the password of the user to get.
     * @return the {@link User user} with the given {@code email} and
     * {@code password}..
     * @throws DAOException if an error occurred during the information
     * retrieving.
     *
     * @author Stefano Chirico
     * @since 1.0.180421
     */
    @Override
    public User getByEmailAndPassword(String email, String password) throws DAOException {
        if ((email == null) || (password == null)) {
            throw new DAOException("Email and password are mandatory fields", new NullPointerException("email or password are null"));
        }
 
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM users WHERE email = ? AND password = ?")) {
            stm.setString(1, email);
            stm.setString(2, password);
            try (ResultSet rs = stm.executeQuery()) {
                PreparedStatement shoppingListStatement = CON.prepareStatement("SELECT count(*) FROM user_shopping_lists WHERE id_user = ?");
        
                int count = 0;
                while (rs.next()) {
                    count++;
                    if (count > 1) {
                        throw new DAOException("Unique constraint violated! There are more than one user with the same email! WHY???");
                    }
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setFirstName(rs.getString("name"));
                    user.setLastName(rs.getString("lastname"));
                    user.setIsAdmin(rs.getBoolean("isAdmin"));
                    user.setAvatarPath(rs.getString("avatarPath"));
                    
                    shoppingListStatement.setInt(1, user.getId());

                    ResultSet counter = shoppingListStatement.executeQuery();
                    counter.next();
                    user.setShoppingListsCount(counter.getInt(1));
                    return user;
                }

                if (!shoppingListStatement.isClosed()) {
                    shoppingListStatement.close();
                }
                
                return null;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }
    }

    /**
     * Returns the list of all the valid {@link User users} stored by the
     * storage system.
     *
     * @return the list of all the valid {@code users}.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     *
     * @author Stefano Chirico
     * @since 1.0.180421
     */
    @Override
    public List<User> getAll() throws DAOException {
        List<User> users = new ArrayList<>();

        try (Statement stm = CON.createStatement()) {
            try (ResultSet rs = stm.executeQuery("SELECT * FROM users ORDER BY lastname")) {

                PreparedStatement shoppingListsStatement = CON.prepareStatement("SELECT count(*) FROM user_shopping_lists WHERE id_user = ?");

                while (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setFirstName(rs.getString("name"));
                    user.setLastName(rs.getString("lastname"));
                    user.setIsAdmin(rs.getBoolean("isAdmin"));
                    user.setAvatarPath(rs.getString("avatarPath"));

                    shoppingListsStatement.setInt(1, user.getId());

                    ResultSet counter = shoppingListsStatement.executeQuery();
                    counter.next();
                    user.setShoppingListsCount(counter.getInt(1));

                    users.add(user);
                }
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }

        return users;
    }
    
    /**
     * Update the user passed as parameter and returns it.
     *
     * @param user the user used to update the persistence system.
     * @return the updated user.
     * @throws DAOException if an error occurred during the action.
     *
     * @author Stefano Chirico
     * @since 1.0.180421
     */
    @Override
    public User update(User user) throws DAOException {
        if (user == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed user is null"));
        }

        try (PreparedStatement std = CON.prepareStatement("UPDATE app.users SET email = ?, password = ?, name = ?, lastname = ?, isAdmin = ?, avatarPath = ? WHERE id = ?")) {
            std.setString(1, user.getEmail());
            std.setString(2, user.getPassword());
            std.setString(3, user.getFirstName());
            std.setString(4, user.getLastName());
            std.setBoolean(5, user.getIsAdmin());
            std.setString(6, user.getAvatarPath());
            std.setInt(7, user.getId());
            if (std.executeUpdate() == 1) {
                return user;
            } else {
                throw new DAOException("Impossible to update the user");
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to update the user", ex);
        }
    }
}
