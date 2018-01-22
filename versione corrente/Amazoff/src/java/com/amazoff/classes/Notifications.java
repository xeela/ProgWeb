package com.amazoff.classes;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author DVD_01
 */


public class Notifications {

    public enum NotificationType {NEW_USER, ORDER_COMPLETE, NEW_REVIEW, ANOMALY};
    
    /** OSSSS: altroID varia in base al tipo di notifica.
     * vale = -1 se type = New_user oppure = NEW_REVIEW
     * vale = orderID se type = ORDER_COMPLETE
     */
    public static void SendNotification(String userID, String altroID, NotificationType type, String link, Connection connection) throws SQLException
    {
        MyDatabaseManager.EseguiStatement("INSERT INTO notifications(ID_USER, TYPE, DESCRIPTION, DATE_ADDED, LINK, ALREADY_READ) VALUES ("
                                        + userID + ","
                                        + type.ordinal() + "," 
                                        + "'" + GetDescriptionFromType(type, altroID) + "',"
                                        + "'" + MyDatabaseManager.GetCurrentDate() + "',"
                                        + "'" + link + "',"
                                        + 0 + ");", connection);
    }
    
    private static String GetDescriptionFromType(NotificationType type, String ID)
    {
        switch(type)
        {
            case NEW_USER: return "Benvenuto!";
            case ORDER_COMPLETE: return "Il tuo ordine è andato a buon fine! (ID: "+ ID +")";
            case NEW_REVIEW: return "E' stata postata una nuova recensione. Leggila ora!";
            case ANOMALY: return "Anomalia segnalata per l'oggetto venduto con ID: " + ID;
            default: return "";
        }
    }
    
    public static String GetJson(String userID, Connection connection) throws SQLException
    {
        String jsonObj = "";
        ResultSet results = MyDatabaseManager.EseguiQuery("SELECT * FROM notifications WHERE ID_USER = " + userID + ";", connection);
        
        boolean isFirstTime = true;
        jsonObj += "{";
        jsonObj        += "\"notifications\":[";
        while (results.next()) {
            if(!isFirstTime)            //metto la virgola prima dell'oggetto solo se non è il primo
                jsonObj += ", ";
            isFirstTime = false;

            jsonObj += "{";
            jsonObj += "\"id\": \"" + results.getString(1) + "\",";
            jsonObj += "\"id_user\": \"" + results.getString(2) + "\",";
            jsonObj += "\"type\": \"" + results.getString(3) + "\",";
            jsonObj += "\"description\": \"" + results.getString(4) + "\",";
            jsonObj += "\"date_added\": \"" + results.getString(5) + "\",";
            jsonObj += "\"link\": \"" + results.getString(6) + "\",";
            jsonObj += "\"already_read\": \"" + results.getString(7) + "\"";

            jsonObj += "}";
        }
        jsonObj += "]}";
        
        return jsonObj;
    }
    
}
