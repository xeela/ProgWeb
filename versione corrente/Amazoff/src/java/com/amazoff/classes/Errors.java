/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.amazoff.classes;

/**
 *
 * @author Davide
 */

public class Errors {
    static public String resetError = "";
    //Pagina login/registrazione
    static public String usernameTaken = "L'username scelto è già in uso. Scegliere uno username diverso e riprovare";
    static public String wrongPassword = "Password non corretta";
    static public String usernameDoesntExist = "Username non corretto";
    static public String mustLogin = "E' necessario eseguire il login per accedere a quest'area";
    //Database
    static public String dbConnection = "Impossibile stabilire la connessione al database. Riprovare piu tardi";
    static public String dbQuery = "C'è stato un errore nell'inserimento o nella lettura dei dati dal database";
    //Altro
    static public String noProductFound = "Non è stato trovato un prodotto con quel nome";
    static public String noShopFound = "Non è stato trovato un negozio vicino a te";
}
