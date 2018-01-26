package com.amazoff.servlet;

import com.amazoff.classes.Errors;
import com.amazoff.classes.MyDatabaseManager;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet per l'aggiunta di un nuovo negozio al db. L'utente venditore, 
 * attraverso la userPage può fare l'upgrade a venditore del proprio profilo, 
 * inserendo i dati nella form che passando per questo servlet vengono caricati sul DB.
 * @author Gianluca Pasqua
 */
public class ServletRegisterShop extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            String name = request.getParameter("nome");
            String description = request.getParameter("descrizione");
            String website = request.getParameter("website");
            String location = request.getParameter("coordinate");
            String citta = request.getParameter("citta");
            String lat = "0";
            String lng = "0";
            if(location.contains(";")){
                lat = location.split(";")[0];
                lng = location.split(";")[1];
            }
            String[]days = new String[7];
            days[0]= request.getParameter("mon");
            days[1] = request.getParameter("tue");
            days[2] = request.getParameter("wed");
            days[3] = request.getParameter("thu");
            days[4] = request.getParameter("fri");
            days[5] = request.getParameter("sat");
            days[6] = request.getParameter("sun");
            String businessDays = "";
            for (String day : days) {
                if (day != null) {
                    if ("true".equals(day)) {
                        businessDays += '1';
                    } 
                }else {
                        businessDays += '0';
                }
            }
            
            /** se l'oggetto MyDatabaseManager non esiste, vuol dire che la connessione al db non è presente */
            if(!MyDatabaseManager.alreadyExists) /** se non esiste lo creo */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
        
            if(MyDatabaseManager.cpds != null)
            {
                HttpSession session = request.getSession();
                Connection connection = MyDatabaseManager.CreateConnection();
                
                /** memorizzo i dati del negozio */
                MyDatabaseManager.EseguiStatement("INSERT INTO shops(NAME, DESCRIPTION, WEB_SITE_URL, GLOBAL_VALUE, ID_OWNER, ID_CREATOR, BUSINESS_DAYS)"
                        + " VALUES("
                        + "'" + name + "',"
                        + "'" + description + "',"
                        + "'" + website + "',"
                        + "0,'"
                        + session.getAttribute("userID") + "','"
                        + session.getAttribute("userID") + "',"
                        + "'" + businessDays
                        +"');", connection);
                ResultSet RS = MyDatabaseManager.EseguiQuery("SELECT LAST_INSERT_ID()", connection);
                int ShopID = -1;
                while (RS.next()) {
                    ShopID = RS.getInt(1);
                }
                /** memorizzo i dati della posizione geografica del negozio appena creato */
                MyDatabaseManager.EseguiStatement("INSERT INTO shops_coordinates(ID_SHOP, ID_COORDINATE, Lat, Lng)"
                        + " VALUES("
                        + (int)ShopID + ","
                        + (int)ShopID + ","
                        + "'" + lat + "',"
                        + "'" + lng 
                        +"');", connection);
                
                MyDatabaseManager.EseguiStatement("UPDATE users SET USERTYPE = 1 WHERE ID ="+session.getAttribute("userID"), connection);
                connection.close();
                session.setAttribute("categoria_user", "1");
                /** SE è andato tutto bene rimando alla home del sito */
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            }
            else
            {
                /** SE c'è stato un errore, memorizzo l'errore e chiedo di reinserire i dati */
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", Errors.dbConnection);
                response.sendRedirect(request.getContextPath() + "/"); 
            }
        }
        catch (SQLException ex) {
            /** SE c'è stato un errore, memorizzo l'errore e chiedo di reinserire i dati */
            MyDatabaseManager.LogError(request.getParameter("username"), "ServletRegisterShop", ex.toString());
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", Errors.dbQuery);
            response.sendRedirect(request.getContextPath() + "/");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
