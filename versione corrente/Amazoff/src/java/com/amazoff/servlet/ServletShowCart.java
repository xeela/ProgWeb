package com.amazoff.servlet;

import com.amazoff.classes.Errors;
import com.amazoff.classes.MyDatabaseManager;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Caterina Battisti
 */
@WebServlet(name = "ServletShowCookieCart", urlPatterns = {"/ServletShowCookieCart"})
public class ServletShowCart extends HttpServlet {

    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            HttpSession session = request.getSession();
            String jsonObj = "";
            
            /** se l'oggetto MyDatabaseManager non esiste, vuol dire che la connessione al db non è presente */
            if(!MyDatabaseManager.alreadyExists) /** se non esiste lo creo */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
            
            if (MyDatabaseManager.cpds != null) {
                Connection connection = MyDatabaseManager.CreateConnection();

                if (session.getAttribute("user") != null) {
                    /** Interrogo il db per farmi restituire tutti i dettagli dei prodotti nel carrello */
                    ResultSet results = MyDatabaseManager.EseguiQuery("SELECT products.name, products.description, products.price, products.id FROM products, cart "
                            + "WHERE cart.ID_USER = " + session.getAttribute("userID") + " AND cart.ID_PRODUCT = products.ID;", connection);
                    /** Memorizzo i dati in un oggetto json */
                    jsonObj = MyDatabaseManager.GetJsonOfProductsInSet(results, connection);

                } else {                
                    /** Se l'utente non è loggato, estraggo i dati del carrello, dai cookie */
                    Cookie[] cart = request.getCookies();
                    if (cart != null) {
                        ResultSet[] results = null;
                        String value;

                        for (int i = 0; i < cart.length; i++) {
                            value = cart[i].getValue();
                            results[i] = MyDatabaseManager.EseguiQuery("SELECT name, description, price, id FROM products WHERE id = " + value + ";", connection);
                        }

                        jsonObj = MyDatabaseManager.GetJsonOfProductsInSetList(results, connection);
                    }
                }
                                
                connection.close();
                session.setAttribute("shoppingCartProducts", jsonObj);
                response.sendRedirect(request.getContextPath() + "/shopping-cartPage.jsp");
                                
            } else {
                session.setAttribute("errorMessage", Errors.dbConnection);
                response.sendRedirect(request.getContextPath() + "/"); 
            }
        } catch (SQLException ex) {
            HttpSession session = request.getSession();
            MyDatabaseManager.LogError(session.getAttribute("user").toString(), "ServletAddToCart", ex.toString());
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
