/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
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
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Cate
 */
@WebServlet(name = "ServletFindShops", urlPatterns = {"/ServletFindShops"})
public class ServletFindShops extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            String userLat = request.getParameter("userLat");
            String userLng = request.getParameter("userLng");

            if (!MyDatabaseManager.alreadyExists) //se non esiste lo creo
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }

            //Chiedi roba al db
            String jsonObj = "";
            if (MyDatabaseManager.cpds != null) {
                Connection connection = MyDatabaseManager.CreateConnection();
                // Interrogo il Db per farmi dare i prodotti cercati con la searchbar

                ResultSet results = null;
                String query = "SELECT shops_coordinates.name, lat, lng "
                        + "FROM shops, shops_coordinates,users "
                        + "WHERE shops.id_owner = users.id AND shops_coordinates.id_shop = shops.id"
                        + "";   // TODO: AGGIUNGERE CONDIZIONE DISTANZA

                query += ";";
                    results = MyDatabaseManager.EseguiQuery(query, connection);

                    if (results.isAfterLast()) //se non c'è un prodotto che rispetta il criterio richiesto
                    {
                        HttpSession session = request.getSession();
                        session.setAttribute("errorMessage", Errors.noShopFound);
                        response.sendRedirect(request.getContextPath() + "/negoziVicini.jsp");
                        connection.close();
                        return;
                    }

                    //aggiungo i prodotti al json
                    jsonObj = MyDatabaseManager.GetJsonOfProductsInSet(results, connection);

                    HttpSession session = request.getSession();

                    session.setAttribute("jsonNegozi", jsonObj);

                    connection.close();

                    response.sendRedirect(request.getContextPath() + "/negoziVicini.jsp");
                } else {
                    HttpSession session = request.getSession();
                    session.setAttribute("errorMessage", Errors.dbConnection);
                    response.sendRedirect(request.getContextPath() + "/"); //TODO: Gestire meglio l'errore
                }
            } catch (SQLException ex) {
                response.sendRedirect(request.getContextPath() + "/"); //TODO: Gestire meglio l'errore
            }
    }
/**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
