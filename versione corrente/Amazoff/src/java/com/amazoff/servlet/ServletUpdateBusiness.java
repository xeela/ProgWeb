package com.amazoff.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.amazoff.classes.Errors;
import com.amazoff.classes.MyDatabaseManager;
import com.amazoff.classes.Notifications;
import java.sql.Connection;
import java.util.UUID;

/**
 *
 * @author Gianluca Pasqua
 */
public class ServletUpdateBusiness extends HttpServlet {

    /**
     * ServletRegister
     * 
     * Questa servlet permette ad un utente di registrarsi al sito 
     *
     * @param request contiene i dati relativi al profilo del nuovo utente 
     * @param response 
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            
            String name = request.getParameter("shop_name");
            String description = request.getParameter("shop_description");
            String website = request.getParameter("shop_website");
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
                mydb.CreateConnection();    
            }
            
            HttpSession session = request.getSession();
            String userID = (String) session.getAttribute("userID");
            if(MyDatabaseManager.cpds != null)
            {
                Connection connection = MyDatabaseManager.CreateConnection();
                
                connection = MyDatabaseManager.CreateConnection();
                Boolean invalidename = false;
                if(!"".equals(name) && name != null && !"".equals(description) && description != null && !"".equals(website) && website != null){
                    PreparedStatement ps = MyDatabaseManager.EseguiStatement("UPDATE shops SET name = '" + MyDatabaseManager.EscapeCharacters(name)+ "', " + 
                                                                    " description = '"+MyDatabaseManager.EscapeCharacters(description)+ "', " + 
                                                                    "web_site_url= '"+ MyDatabaseManager.EscapeCharacters(website) + 
                                                                    "' WHERE ID_OWNER= "+session.getAttribute("userID") +";", connection);

                                connection.close();
                                response.sendRedirect(request.getContextPath() + "/index.jsp");
                }
                else
                {
                    session.setAttribute("errorMessage", Errors.updateUnsuccessful);
                    response.sendRedirect(request.getContextPath() + "/userPage.jsp");
                }
            }
            else
            {
                session.setAttribute("errorMessage", Errors.dbConnection);
                response.sendRedirect(request.getContextPath() + "/userPage.jsp");
            }
            
        }catch (SQLException ex) {
            MyDatabaseManager.LogError(request.getParameter("username"), "ServletUpdateBusiness", ex.toString());
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", Errors.dbQuery);
            response.sendRedirect(request.getContextPath() + "/dsf");
        }           
    }
    
    /** Funzione che genera una stringa in modo casuale, da usare come password di recupero */
    private static String generateString() {
        
        String uuid = UUID.randomUUID().toString();
        return uuid;
    }
    
    /******** TMP: 
    private static void generateNString() {
        
        String[] tmp = new String[50];
        for (int i = 0; i < 50; i++) {
            String uuid = UUID.randomUUID().toString();
            tmp[i] = uuid;
        }
        tmp = tmp;
    }*/

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
