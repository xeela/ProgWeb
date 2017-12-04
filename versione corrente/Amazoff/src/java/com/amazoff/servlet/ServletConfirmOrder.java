package com.amazoff.servlet;

import com.amazoff.classes.MyDatabaseManager;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * @author Davide
 */
public class ServletConfirmOrder extends HttpServlet {

    
    /**
     * ServletConfirmOrder
     * 
     * Questa servlet viene richiamata quando il cliente, dalla pagina del pagamento (payPage), 
     * procede con l'acquisto dei prodotti
     * 
     * @param request contiene la modalità con cui l'utente intente ricevere i prodotti. 
     * @param modalita è contenuto nel parametro request ed ha memorizzato la modalità di ritiro dei prodotti (spediti a casa o ritirati in negozio) 
     * @param session contiene l'id dell'utente che sta eseguendo l'acquisto
     * @return PER ORA IL CODICE è DA FINIRE. "Variabile che specifica se l'operazione è andata a buon fine (return TRUE) o FLASE in caso di errori
     * 
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            
            String modalita = request.getParameter("modalita");
            
            /** se l'oggetto MyDatabaseManager non esiste, vuol dire che la connessione al db non è presente */
            if(!MyDatabaseManager.alreadyExists) /** se non esiste lo creo */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
        
            HttpSession session = request.getSession();
            String userID = session.getAttribute("userID").toString();
            
            int orderID = -1;
            if(MyDatabaseManager.cpds != null)
            {
                Connection connection = MyDatabaseManager.CreateConnection();
                
                /** Memorizza nel db un nuovo ordine associato all'utente specificato */
                PreparedStatement ps = MyDatabaseManager.EseguiStatement("INSERT INTO orders (who_ordered, order_date, address) VALUES (" + userID + ", "
                        + "'" + MyDatabaseManager.GetCurrentDate() + "',"
                        + "1);", connection);
                
                /** Memorizzo l'id dell'ordine aggiunto sopra */
                ResultSet idOrderRS = ps.getGeneratedKeys();
                if(idOrderRS.next())
                    orderID = idOrderRS.getInt(1);
                
                /** Prendo i prodotti nel carrello e li aggiungo all'ordine corrente */
                ResultSet results = MyDatabaseManager.EseguiQuery("SELECT id_product FROM cart WHERE id_user = " + userID + ";", connection);
                while(results.next())
                {
                    String productID = results.getString(1);
                    MyDatabaseManager.EseguiStatement("INSERT INTO orders_products (order_id, product_id) VALUES (" + orderID + ", " + productID + ");", connection);
                }
                
                //****** TODO: segnare i prodotti ordinati come "venduti" ****** //
                
                
                connection.close();
                
                //****** TODO: quando cìè l'errore, questo dovrebbe essere passato tramite la session.setAttribute *******/
                response.sendRedirect(request.getContextPath() + "/orderCompletedPage.jsp?p=ok&id="+orderID);       
            }
            else
            {
                //session.setAttribute("errorMessage", Errors.dbConnection);
                response.sendRedirect(request.getContextPath() + "/orderCompletedPage.jsp?p=err"); 
            }
        }catch (SQLException ex) {
            MyDatabaseManager.LogError(request.getParameter("username"), "ServletConfirmOrder", ex.toString());
            HttpSession session = request.getSession();
            //session.setAttribute("errorMessage", Errors.dbQuery);
            response.sendRedirect(request.getContextPath() + "/orderCompletedPage.jsp?p=err"); 
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
