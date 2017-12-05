package com.amazoff.servlet;

import com.amazoff.classes.Errors;
import com.amazoff.classes.MyDatabaseManager;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Davide
 */
public class ServletDopoRegistrazione extends HttpServlet {

    /**
     * ServletDopoRegistrazione 
     * 
     * Ha il compito di memorizzari i dati inseriti nella pagina afterRegistration.
     * Memorizza nel db i dati dell'indirizzo e della carta di credito forniti dall'utente successivamente alla sua registrazione
     * 
     * @param request contiene i dati relativi all'indirizzo e alla carta di credito che l'utente vuole memorizzare
     * @return: in caso di errore, richiama la pagina afterRegistration, dove l'utente dovrà inserire nuovamente i dati
     *          in caso di successo, verrà rimandato alla home del sito (index)
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            String paese = request.getParameter("paese");
            String indirizzo = request.getParameter("indirizzo");
            String citta = request.getParameter("citta");
            String provincia = request.getParameter("provincia");
            String cap = request.getParameter("cap");
            
            String intestatario = request.getParameter("intestatario");
            String numeroCarta = request.getParameter("numerocarta");
            String meseScadenza = request.getParameter("mesescadenza");
            String annoScadenza = request.getParameter("annoscadenza");
            
            /** se l'oggetto MyDatabaseManager non esiste, vuol dire che la connessione al db non è presente */
            if(!MyDatabaseManager.alreadyExists) /** se non esiste lo creo */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
        
            if(MyDatabaseManager.cpds != null)
            {
                HttpSession session = request.getSession();
                Connection connection = MyDatabaseManager.CreateConnection();
                
                /** memorizzo i dati l'indirizzo dell'utente */
                MyDatabaseManager.EseguiStatement("INSERT INTO user_addresses(ID_UTENTE, TOWN, CITY, ADDRESS, PROVINCE, POSTAL_CODE)"
                        + " VALUES("
                        + session.getAttribute("userID") + ","
                        + "'" + paese + "',"
                        + "'" + citta + "',"
                        + "'" + indirizzo + "',"
                        + "'" + provincia + "',"
                        + "'" + cap + "');", connection);
                
                /** memorizzo i dati della carta di credito */
                MyDatabaseManager.EseguiStatement("INSERT INTO creditcards(ID_UTENTE, OWNER, CARD_NUMBER, EXP_MONTH, EXP_YEAR)"
                        + " VALUES("
                        + session.getAttribute("userID") + ","
                        + "'" + intestatario + "',"
                        + "'" + numeroCarta + "',"
                        + "'" + meseScadenza + "',"
                        + "'" + annoScadenza + "');", connection);
                
                connection.close();
                
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
            MyDatabaseManager.LogError(request.getParameter("username"), "ServletDopoRegistrazione", ex.toString());
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
