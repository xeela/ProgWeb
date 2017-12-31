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
    
    /** Si occuopa di selezionare la directory in cui sono caricate le immagini sul server (se esiste). Dà errore altrimenti 
     *Prende la directory di upload dal file web.xml */
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        /** read the uploadDir from the servlet parameters */
        dirName = config.getInitParameter("uploadDir");
        if (dirName == null) {
        throw new ServletException("Please supply uploadDir parameter");
        }
    }
    
    /**
     * Servlet richiamata quando l'utente (venditore) vuole inserire un nuovo prodotto.
     * 
     * @param request contiene tutti i dati relativi all'oggetto che l'utente sta caricando
     *              Quindi: nome, categoria dell'oggetto, descrizione, prezzo e le immagini 
     * 
     * 
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            String userReceived = (String) request.getSession().getAttribute("user");

            /** Funzione che prende il file specificato dall'utente e lo salva sul server */
            MultipartRequest multi = new MultipartRequest(request, getServletContext().getRealPath(dirName), 10*1024*1024, "ISO-8859-1", new DefaultFileRenamePolicy());

            String categoriaReceived = multi.getParameter("categoria");
            String nomeReceived = multi.getParameter("nome");
            String descrizioneReceived = multi.getParameter("descrizione");
            String prezzoReceived = multi.getParameter("prezzo");
            String nomeFotoReceived = multi.getFilesystemName("productPic");
            
            /** se l'oggetto MyDatabaseManager non esiste, vuol dire che la connessione al db non è presente */
            if(!MyDatabaseManager.alreadyExists) /** se non esiste lo creo */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
                 
            if(MyDatabaseManager.cpds != null)
            {
                int id_shop = MyDatabaseManager.GetID_Shop(userReceived);
                Connection connection = MyDatabaseManager.CreateConnection();
                
                /** aggiungi alla tabella products il prodotto */
                /* QUERY: vanno aggiornati i campi. manca ritiro, venduto */
                PreparedStatement ps = MyDatabaseManager.EseguiStatement("INSERT INTO products (name, description, price, id_shop) VALUES (" 
                            + "'" + MyDatabaseManager.EscapeCharacters(nomeReceived) + "', "
                            + "'" + MyDatabaseManager.EscapeCharacters(descrizioneReceived) + "', "
                            + "" + prezzoReceived + ", "
                            + id_shop + ");", connection);
                /** ottieni l'ID del prodotto appena aggiunto */
                int productID = -1;
                ResultSet idProdottoRS = ps.getGeneratedKeys();
                if(idProdottoRS.next())
                    productID = idProdottoRS.getInt(1);
                
                /** aggiungi il nome della foto alla tabella pictures */
                PreparedStatement ps2 = MyDatabaseManager.EseguiStatement("INSERT INTO pictures (path, id_product) VALUES ("
                            + "'" + MyDatabaseManager.EscapeCharacters(nomeFotoReceived) + "', "
                            + productID + ");", connection);
                
                connection.close();
                
                response.sendRedirect(request.getContextPath() + "/");
            }
            else
            {   /** C'è stato un errore */
                HttpSession session = request.getSession(); 
                session.setAttribute("errorMessage", Errors.dbConnection);
                response.sendRedirect(request.getContextPath() + "/"); 
            }
        }
        catch(Exception ex)
        {
            /** C'è stato un errore non previsto */
            HttpSession session = request.getSession();
            MyDatabaseManager.LogError(session.getAttribute("user").toString(), "ServletFindProduct", ex.toString());
            return;
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
