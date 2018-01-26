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
    static public String isNotYourEmail = "L'email selezionata non è quella corretta";
    //Database
    static public String dbConnection = "Impossibile stabilire la connessione al database. Riprovare piu tardi";
    static public String dbQuery = "C'è stato un errore nell'inserimento o nella lettura dei dati dal database";
    //Altro
    static public String noProductFound = "Non è stato trovato un prodotto con quel nome";
    static public String noShopFound = "Non è stato trovato un negozio vicino a te";
    static public String emailAlreadyExists = "L'indirizzo email inserito è già associato ad un altro utente";
    static public String noOrdersFound = "Non è stato ancora effettuato alcun ordine";
    static public String updateUnsuccessful = "Nessun record aggiornato nel database";
    static public String insertUnsuccessful = "Nessun record aggiunto al database";
    static public String deleteUnsuccessful = "Nessun record eliminato dal database";
}
