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
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;
import java.sql.PreparedStatement;
import javax.servlet.annotation.MultipartConfig;
/**
 *
 * @author Davide
 */
@MultipartConfig
public class ServletAddProduct extends HttpServlet {
    private String dirName;
    
    //Prende la directory di upload dal file web.xml
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        // read the uploadDir from the servlet parameters
        dirName = config.getInitParameter("uploadDir");
        if (dirName == null) {
        throw new ServletException("Please supply uploadDir parameter");
        }
    }
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
            String userReceived = (String) request.getSession().getAttribute("user");

            //prendi il file e salvalo sul server
            MultipartRequest multi = new MultipartRequest(request, getServletContext().getRealPath(dirName), 10*1024*1024, "ISO-8859-1", new DefaultFileRenamePolicy());

            String categoriaReceived = multi.getParameter("categoria");
            String nomeReceived = multi.getParameter("nome");
            String descrizioneReceived = multi.getParameter("descrizione");
            String prezzoReceived = multi.getParameter("prezzo");
            String nomeFotoReceived = multi.getFilesystemName("productPic");
            
            if(!MyDatabaseManager.alreadyExists) //se non esiste lo creo
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
                 
            //Chiedi roba al db
            if(MyDatabaseManager.cpds != null)
            {
                int id_shop = MyDatabaseManager.GetID_Shop(userReceived);
                Connection connection = MyDatabaseManager.CreateConnection();
                
                //aggiungi alla tabella products il prodotto
                PreparedStatement ps = MyDatabaseManager.EseguiStatement("INSERT INTO products (name, description, price, id_shop) VALUES (" 
                            + "'" + nomeReceived + "', "
                            + "'" + descrizioneReceived + "', "
                            + "" + prezzoReceived + ", "
                            + id_shop + ");", connection);
                //ottieni l'ID del prodotto appena aggiunto
                int productID = -1;
                ResultSet idProdottoRS = ps.getGeneratedKeys();
                if(idProdottoRS.next())
                    productID = idProdottoRS.getInt(1);
                
                //aggiungi il nome della foto alla tabella pictures
                PreparedStatement ps2 = MyDatabaseManager.EseguiStatement("INSERT INTO pictures (path, id_product) VALUES ("
                            + "'" + nomeFotoReceived + "', "
                            + productID + ");", connection);
                
                connection.close();
                
                response.sendRedirect(request.getContextPath() + "/");
            }
            else
            {
                HttpSession session = request.getSession(); 
                session.setAttribute("errorMessage", Errors.dbConnection);
                response.sendRedirect(request.getContextPath() + "/"); //TODO: Gestire meglio l'errore
            }
        }
        catch(Exception ex)
        {return;}
        /*catch (SQLException ex) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", Errors.dbQuery);
            response.sendRedirect(request.getContextPath() + "/"); //TODO: Gestire meglio l'errore
        }*/
    }
    
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
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
