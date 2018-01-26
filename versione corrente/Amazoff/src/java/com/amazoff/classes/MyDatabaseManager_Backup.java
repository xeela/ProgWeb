package com.amazoff.classes;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import com.mchange.v2.c3p0.*;


/**
 *
 * @author Davide
 */
public class MyDatabaseManager_Backup {
    static public boolean alreadyExists = false;
    static public String db_host;
    static public String db_username;
    static public String db_password;
    static public Connection connection = null;
    
    public MyDatabaseManager_Backup()
    {
        alreadyExists = true;
        
        db_host = "jdbc:mysql://hostingmysql275.register.it:3306/progweb17";
        db_username = "GruppoProgWeb";
        db_password = "GruppoWeb17";
    }
    
    public MyDatabaseManager_Backup(String host, String user, String pwd)
    {
        alreadyExists = true;
        //db_host = host;
        //db_username = user;
        //db_password = pwd;
        
        db_host = "jdbc:mysql://hostingmysql275.register.it:3306/progweb17";
        db_username = "GruppoProgWeb";
        db_password = "GruppoWeb17";
    }
    
    static public void CreateConnection() {
        //TODO: Gestire meglio gli errori
        Connection tmp = null;
        
        if(connection == null)
        {
            try {
                Class.forName("com.mysql.jdbc.Driver");
            } catch (ClassNotFoundException ex) {
                return;
            }

            try {
                tmp = DriverManager.getConnection(db_host, db_username, db_password);
            } catch (SQLException ex) {
                return;
            }

            connection = tmp;  
        }       
    }
    
    static public void CloseConnection() {
        try {
            connection.close();
        } catch (SQLException ex) {
            return;
        }
        connection = null;
    }
    
    static public ResultSet EseguiQuery(String query) throws SQLException {
        Statement stmt = connection.createStatement();
        String sql = query;
        ResultSet results = stmt.executeQuery(sql);
        
        return results;
    }
    
    static public PreparedStatement EseguiStatement(String query) throws SQLException {
        PreparedStatement ps = connection.prepareStatement(query); 
        ps.executeUpdate();
        
        return ps;
    }
    
    //Query usate spesso
    
    //ESEMPIO
    static public String GetChosenDriversList(String username, String currentGp) throws SQLException
    {
        String tmpChosenDriversList = "";
        ResultSet results = MyDatabaseManager_Backup.EseguiQuery("SELECT nome_pilota, cognome_pilota, scuderia, prezzo, punti FROM scelte_piloti, piloti WHERE username = '" + username + "' AND nome_gara = '" + currentGp + "' AND nome_pilota = nome AND cognome_pilota = cognome");
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
        return tmpChosenDriversList;
    }
}
