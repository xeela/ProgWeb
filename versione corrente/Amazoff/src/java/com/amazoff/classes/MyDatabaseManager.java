package com.amazoff.classes;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import com.mchange.v2.c3p0.*;
import java.beans.PropertyVetoException;
import java.util.logging.Level;
import java.util.logging.Logger;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

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
    
    public MyDatabaseManager()
    {
        alreadyExists = true;
        
        cpds = new ComboPooledDataSource();
        cpds.setMaxPoolSize(200);
        cpds.setMaxStatements(100);
        cpds.setMaxStatementsPerConnection(100);
        db_host = "jdbc:mysql://hostingmysql275.register.it:3306/progweb17";
        db_username = "GruppoProgWeb";
        db_password = "GruppoWeb17";
        
        try {
            cpds.setDriverClass("com.mysql.jdbc.Driver" ); //loads the jdbc driver    
        } catch (PropertyVetoException ex) {
            return;
        }
        cpds.setJdbcUrl( db_host );
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
            while(!tmp.isValid(3))
            {
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
    
    static public PreparedStatement EseguiStatement(String query, Connection connection) throws SQLException {
        PreparedStatement ps = connection.prepareStatement(query); 
        ps.executeUpdate();
        
        connection.close();
        return ps;
    }
    
    //Query usate spesso
    
    //ESEMPIO
    static public String GetChosenDriversList(String username, String currentGp) throws SQLException
    {
        Connection connection = CreateConnection();
        String tmpChosenDriversList = "";
        ResultSet results = MyDatabaseManager.EseguiQuery("SELECT nome_pilota, cognome_pilota, scuderia, prezzo, punti FROM scelte_piloti, piloti WHERE username = '" + username + "' AND nome_gara = '" + currentGp + "' AND nome_pilota = nome AND cognome_pilota = cognome", connection);
        while (results.next()) {
            String name = results.getString(1);
            String surname = results.getString(2);
            String team = results.getString(3);
            String price = results.getString(4);
            String points = results.getString(5);
            tmpChosenDriversList += ("|" + name + ";" 
                                        + surname + ";"
                                        + team + ";"
                                        + price + ";"
                                        + points );
        }
        connection.close();
        return tmpChosenDriversList;
    }
}
