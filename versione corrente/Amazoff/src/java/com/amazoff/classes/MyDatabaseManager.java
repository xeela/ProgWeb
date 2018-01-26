package com.amazoff.classes;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import com.mchange.v2.c3p0.*;
import java.beans.PropertyVetoException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Davide
 */
public class MyDatabaseManager {

    static public boolean alreadyExists = false;
    static public String db_host;
    static public String db_username;
    static public String db_password;
    static public ComboPooledDataSource cpds;

    public MyDatabaseManager() {
        alreadyExists = true;

        cpds = new ComboPooledDataSource();
        cpds.setMaxPoolSize(200);
        cpds.setMaxStatements(100);
        cpds.setMaxStatementsPerConnection(100);
        db_host = "jdbc:mysql://hostingmysql275.register.it:3306/progweb17";
        db_username = "GruppoProgWeb";
        db_password = "GruppoWeb17";

        try {
            cpds.setDriverClass("com.mysql.jdbc.Driver"); //loads the jdbc driver    
        } catch (PropertyVetoException ex) {
            return;
        }
        cpds.setJdbcUrl(db_host);
        cpds.setUser(db_username);
        cpds.setPassword(db_password);
    }

    static public Connection CreateConnection() {
        //TODO: Gestire meglio gli errori
        Connection tmp = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException ex) {
            return null;
        }

        try {
            tmp = cpds.getConnection();
        } catch (SQLException ex) {
            return null;
        }

        //continua a chiedere una connessione valida finchè non ne trovi una
        //magari non serve, ma magari risolve il problema che ogni tanto la connessione si rompe
        //anche se si toglie dovrebbe andare tutto comunque, almeno il 90% delle volte
        try {
            while (!tmp.isValid(3)) {
                tmp = cpds.getConnection();
            }
        } catch (SQLException ex) {
            return null;
        }
        //se si vuole togliere, bisogna togliere tutto fino a qui, lasciando il resto invariato

        return tmp;
    }

    static public ResultSet EseguiQuery(String query, Connection connection) throws SQLException {
        Statement stmt = connection.createStatement();
        String sql = query;
        ResultSet results = stmt.executeQuery(sql);
        return results;
    }

    static public int EseguiUpdate(String query, Connection connection) throws SQLException {
        Statement stmt = connection.createStatement();
        String sql = query;
        int results = stmt.executeUpdate(sql);
        return results;
    }
    
    static public PreparedStatement EseguiStatement(String query, Connection connection) throws SQLException {
        PreparedStatement ps = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
        ps.executeUpdate();
        
        return ps;
    }

    //Query usate spesso
    static public int GetID_Shop(String utente) throws SQLException {
        int idshop = -1;
        //per ora una persona può avere solo un negozio, altrimenti non so quale prende (l'ultimo creato, in teoria)
        Connection connection = CreateConnection();
        int userID = GetID_User(utente);

        ResultSet results = MyDatabaseManager.EseguiQuery("SELECT DISTINCT shops.id FROM shops, users WHERE shops.id_creator = " + userID + ";", connection);
        while (results.next()) {
            idshop = results.getInt(1);
        }
        connection.close();

        return idshop;
    }

    static public int GetID_User(String utente) throws SQLException {
        Connection connection = CreateConnection();
        ResultSet userIDres = MyDatabaseManager.EseguiQuery("SELECT id FROM users WHERE username = '" + MyDatabaseManager.EscapeCharacters(utente) + "';", connection);
        int userID = 0;
        while (userIDres.next()) {
            userID = userIDres.getInt(1);
        }
        connection.close();
        return userID;
    }

    public static String GetJson(ResultSet results, Connection connection) throws SQLException {
        String jsonObj = "";
        boolean isFirstTime = true, isFirstTimeImg = true;
        String id_product = "";
        
        while (results.next()) {
            if (!isFirstTime) //metto la virgola prima dell'oggetto solo se non è il primo
            {
                jsonObj += ", ";
            }
            isFirstTime = false;

            id_product = results.getString(1);
            jsonObj += "{";
            jsonObj += "\"id\": \"" + id_product + "\",";
            jsonObj += "\"name\": \"" + results.getString(2) + "\",";
            jsonObj += "\"description\": \"" + results.getString(3) + "\",";
            jsonObj += "\"price\": \"" + results.getString(4) + "\",";

            // in base al prodotto, ricavo il path delle img a lui associate
            ResultSet results2 = MyDatabaseManager.EseguiQuery("SELECT id, path FROM pictures WHERE id_product = " + id_product + ";", connection);

            if (results2.isAfterLast()) //se non ci sono img per quel prodotto, allora:
            {
                /*HttpSession session = request.getSession();
                session.setAttribute("errorMessage", Errors.noProductFound);
                response.sendRedirect(request.getContextPath() + "/searchPage.jsp");
                connection.close();*/
                return "";
            }
            jsonObj += "\"pictures\":[";
            // altrimenti
            while (results2.next()) {
                if (!isFirstTimeImg) //metto la virgola prima dell'oggetto solo se non è il primo
                {
                    jsonObj += ", ";
                }
                isFirstTimeImg = false;

                jsonObj += "{";
                jsonObj += "\"id\": \"" + results2.getString(1) + "\",";
                jsonObj += "\"path\": \"" + results2.getString(2) + "\"";
                jsonObj += "}";
            }
            isFirstTimeImg = true;
            jsonObj += "]";

            jsonObj += "}";
        }
        
        return jsonObj;
    }

    public static String GetJsonShops(ResultSet results, Connection connection) throws SQLException {
        String jsonObj = "";
        boolean isFirstTime = true;
        
        while (results.next()) {
            if (!isFirstTime) //metto la virgola prima dell'oggetto solo se non è il primo
            {
                jsonObj += ", ";
            }
            isFirstTime = false;

            jsonObj += "{";
            jsonObj += "\"name\": \"" + results.getString(1) + "\",";
            jsonObj += "\"lat\": \"" + results.getString(2) + "\",";
            jsonObj += "\"lng\": \"" + results.getString(3) + "\"";
            jsonObj += "}";
        }
        
        return jsonObj;
    }
    
    static public String GetJsonOfProductsInSet(ResultSet results, Connection connection) throws SQLException {
        String jsonObj = "";
        jsonObj += "{";
        jsonObj += "\"products\":[";
        
        jsonObj += GetJson(results, connection);
        
        jsonObj += "]}";

        return jsonObj;
    }

    static public String GetJsonOfProductsInSetList(ResultSet[] resultsList, Connection connection) throws SQLException {
        String jsonObj = "";
        jsonObj += "{";
        jsonObj += "\"products\":[";
        boolean isFirstTime = true;
        
        for (ResultSet result : resultsList) {
            if (!isFirstTime) //metto la virgola prima dell'oggetto solo se non è il primo
            {
                jsonObj += ", ";
            }
            isFirstTime = false;
            
            jsonObj += GetJson(result, connection);
        }
        jsonObj += "]}";

        return jsonObj;
    }

    static public String GetJsonOfShopsInSet(ResultSet results, Connection connection) throws SQLException {
        String jsonObj = "";
        jsonObj += "{";
        jsonObj += "\"shops\":[";
        
        jsonObj += GetJsonShops(results, connection);
        
        jsonObj += "]}";

        return jsonObj;
    }
    
    static public String GetCurrentDate() {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date = new Date();
        return dateFormat.format(date);
    }

    static public void LogError(String user, String servletName, String message) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date = new Date();

        try {
            Connection connection = CreateConnection();

            PreparedStatement ps = EseguiStatement("INSERT INTO errors(user, message, servlet, date) VALUES ("
                    + "'" + MyDatabaseManager.EscapeCharacters(user) + "', "
                    + "'" + MyDatabaseManager.EscapeCharacters(message) + "', "
                    + "'" + MyDatabaseManager.EscapeCharacters(servletName) + "', "
                    + "'" + dateFormat.format(date) + "');", connection);

            connection.close();
        } catch (SQLException ex) {
            Logger.getLogger(MyDatabaseManager.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    //Helpers
    static public String EscapeCharacters(String msg) {
        return msg.replace("'", "\\\'");
    }
}
