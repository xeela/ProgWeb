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
 * @author Gianluca Pasqua
 * 
 * Funzione "init"
 *  Si occupa di selezionare la directory in cui sono caricate le immagini sul server (se esiste). Dà errore altrimenti.
 *  OSS: Lege la directory di upload dal file web.xml
 * 
 * Funzione "processRequest"
 * Servlet richiamata quando l'utente (venditore) vuole inserire un nuovo prodotto.
 * 
 * request contiene tutti i dati relativi all'oggetto che l'utente sta caricando
 *                  Quindi: nome, categoria dell'oggetto, descrizione, prezzo e le immagini 
 * 
 */
@MultipartConfig
public class ServletAddProduct extends HttpServlet {
    
    private String dirName;
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        /** legge il nome della cartella in cui memorizzare le immagini, leggendo il campo uploadDir nel file web.xml */
        dirName = config.getInitParameter("uploadDir");
        if (dirName == null) {
        throw new ServletException("Please supply uploadDir parameter");
        }
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            String userReceived = (String) request.getSession().getAttribute("user");

            /** Funzione che prende il file specificato dall'utente e lo salva sul server */
            MultipartRequest multi = new MultipartRequest(request, getServletContext().getRealPath(dirName), 16*4096*4096, "ISO-8859-1", new DefaultFileRenamePolicy());

            /** Leggo anche tutti gli altri parametri specificati dall'utente */
            String categoriaReceived = multi.getParameter("categoria");
            String nomeReceived = multi.getParameter("nome");
            String descrizioneReceived = multi.getParameter("descrizione");
            String prezzoReceived = multi.getParameter("prezzo");
            String nomeFotoReceived = multi.getFilesystemName("productPic");
            String spedizioneReceived = multi.getParameter("consegna");
            int ritiro;
            prezzoReceived = prezzoReceived.replace(',', '.');
            if (spedizioneReceived != null)
            {
                if("ritiro".equals(spedizioneReceived))
                {
                    ritiro = 1; /** = 1 significa che il prodotto verrà RITIRATO in negozio */
                }
                else
                    ritiro = 0; /** = 0 significa che il prodotto verrà SPEDITO all'utente */
            }
            else
                ritiro = -1; /** Non è stata specificata la modalità di acquisto del prodotto */
                  
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
                /* ?????????????????? QUERY: vanno aggiornati i campi. manca ritiro, venduto */
                PreparedStatement ps = MyDatabaseManager.EseguiStatement("INSERT INTO products (name, description, price, id_shop, ritiro, sold) VALUES (" 
                            + "'" + MyDatabaseManager.EscapeCharacters(nomeReceived) + "', "
                            + "'" + MyDatabaseManager.EscapeCharacters(descrizioneReceived) + "', "
                            + "" + prezzoReceived + ", "
                            + id_shop + ", "
                            + ritiro + ","
                            + 0
                            + ");", connection);
                
                /** ottieni l'ID del prodotto appena aggiunto */
                int productID = -1;
                ResultSet idProdottoRS = ps.getGeneratedKeys();
                if(idProdottoRS.next())
                    productID = idProdottoRS.getInt(1);
                if(nomeFotoReceived != null)
                {
                    /** aggiungi il nome della foto alla tabella pictures */
                    PreparedStatement ps2 = MyDatabaseManager.EseguiStatement("INSERT INTO pictures (path, id_product) VALUES ("
                                + "'" + MyDatabaseManager.EscapeCharacters(nomeFotoReceived) + "', "
                                + productID + ");", connection);
                }
                connection.close();
                
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            }
            else
            {   /** C'è stato un errore. */
                HttpSession session = request.getSession(); 
                session.setAttribute("errorMessage", Errors.dbConnection);
                response.sendRedirect(request.getContextPath() + "/"); 
            }
        }
        catch(Exception ex)
        {
            /** C'è stato un errore non previsto.  */
            HttpSession session = request.getSession();
            MyDatabaseManager.LogError(session.getAttribute("user").toString(), "ServletAddProduct", ex.toString());
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
