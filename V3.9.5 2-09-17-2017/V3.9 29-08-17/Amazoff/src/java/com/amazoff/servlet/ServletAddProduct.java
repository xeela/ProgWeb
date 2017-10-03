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
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;
/**
 *
 * @author Davide
 */
public class ServletAddProduct extends HttpServlet {
    private String dirName;
    
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
            String userReceived = request.getParameter("username");
            String categoriaReceived = request.getParameter("categoria");
            String nomeReceived = request.getParameter("nome");
            String descrizioneReceived = request.getParameter("descrizione");
            String fotoReceived = request.getParameter("productPic");

           //Connessione al Database
            //String db_host = "jdbc:mysql://localhost:3306/fantaf1db";
            //String db_user = "root";
            //String db_pwd = "root";
            
            if(!MyDatabaseManager.alreadyExists) //se non esiste lo creo
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
        
            //Chiedi roba al db
            MultipartRequest multi = new MultipartRequest(request, getServletContext().getRealPath(dirName), 10*1024*1024, "ISO-8859-1", new DefaultFileRenamePolicy());

            if(MyDatabaseManager.cpds != null)
            {
                Connection connection = MyDatabaseManager.CreateConnection();
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
