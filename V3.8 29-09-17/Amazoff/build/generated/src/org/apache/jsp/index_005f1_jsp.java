package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

public final class index_005f1_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List<String> _jspx_dependants;

  private org.glassfish.jsp.api.ResourceInjector _jspx_resourceInjector;

  public java.util.List<String> getDependants() {
    return _jspx_dependants;
  }

  public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException {

    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    JspWriter out = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;

    try {
      response.setContentType("text/html;charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;
      _jspx_resourceInjector = (org.glassfish.jsp.api.ResourceInjector) application.getAttribute("com.sun.appserv.jsp.resource.injector");

      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("<!DOCTYPE html>\n");
      out.write("<html>\n");
      out.write("    <head>\n");
      out.write("        <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">\n");
      out.write("        <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n");
      out.write("        <script src=\"js/popper.js\"></script>\n");
      out.write("        <script src=\"js/popper-utils.js\"></script>\n");
      out.write("        <script src=\"https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js\"></script>\n");
      out.write("        <link rel=\"stylesheet\" href=\"css/bootstrap.min.css\">\n");
      out.write("        <link rel=\"stylesheet\" href=\"css/bootstrap-theme.css\">\n");
      out.write("        <script src=\"js/bootstrap.min.js\"></script>\n");
      out.write("        \n");
      out.write("        <link rel=\"stylesheet\" href=\"css/amazoffStyle.css\">\n");
      out.write("        \n");
      out.write("        <title>Amazoff</title>\n");
      out.write("    </head>\n");
      out.write("    <body class=\"bodyStyle\">\n");
      out.write("        \n");
      out.write("        <!-- PROVA BOOTSTRAP \n");
      out.write("        <div class=\"container-fluid\">\n");
      out.write("        <div class=\"row\">\n");
      out.write("            <!-- xs per smartphone lg per tablet e pc --\n");
      out.write("            <div class=\"col-xs-12 col-lg-4\" style=\"background-color: green\"><button class=\"col-xs-12\">button</button></div>\n");
      out.write("            <div class=\"hidden-xs col-lg-4\" style=\"background-color: red\">col-xs-8</div>\n");
      out.write("            <div class=\"col-xs-4 col-lg-3\" style=\"background-color: aqua\">col-xs-4</div>\n");
      out.write("          </div>\n");
      out.write("        </div> -->\n");
      out.write("            \n");
      out.write("        <div class=\"container-fluid\">\n");
      out.write("            \n");
      out.write("            \n");
      out.write("            <!-- barra bianca a sx -->\n");
      out.write("            <div class=\"hidden-xs col-lg-1\"></div>\n");
      out.write("            \n");
      out.write("            <div class=\"col-xs-12 col-lg-10\">\n");
      out.write("                \n");
      out.write("                <div class=\"row\" > <!-- style=\"position: fixed; z-index: 999;\" -->\n");
      out.write("                        <!-- barra con: login/registrati, cerca, carrello -->\n");
      out.write("                        <div class=\"logo col-xs-12 col-lg-1\">\n");
      out.write("                            <div class=\"row\">\n");
      out.write("                                <div class=\"col-xs-8 col-lg-10\">LOGO</div>\n");
      out.write("                                <div class=\"col-xs-2 hidden-lg\" style=\"text-align: right\"> <spam class=\"glyphicon glyphicon-user\"></spam></div>\n");
      out.write("                                <div class=\"col-xs-2 hidden-lg\" style=\"text-align: right\"> <spam class=\"glyphicon glyphicon-shopping-cart\"></spam></div>\n");
      out.write("                            </div>\n");
      out.write("                        </div>\n");
      out.write("                        <div class=\"searchBar col-xs-12 col-lg-7\">\n");
      out.write("                            <div class=\"input-group\">\n");
      out.write("                                <input type=\"text\" class=\"form-control\" aria-label=\"...\">\n");
      out.write("                                \n");
      out.write("                                <div class=\"input-group-btn\">\n");
      out.write("                                  <button type=\"button\" class=\"btn btn-default dropdown-toggle hidden-xs\" data-toggle=\"dropdown\" aria-haspopup=\"true\" aria-expanded=\"false\">Scegli categoria<span class=\"caret\"></span></button>\n");
      out.write("                                  <ul class=\"dropdown-menu dropdown-menu-left hidden-xs\"> <!-- ?????????? sull'ipad non sparisce -->\n");
      out.write("                                    <li><a href=\"#\">Prodotto</a></li>\n");
      out.write("                                    <li><a href=\"#\">Categoria</a></li>\n");
      out.write("                                    <li><a href=\"#\">Luogo</a></li>\n");
      out.write("                                  </ul>\n");
      out.write("                                  <button class=\"btn btn-default\" type=\"button\">Cerca</button>\n");
      out.write("                                </div><!-- /btn-group --> \n");
      out.write("                            </div><!-- /input-group -->\n");
      out.write("                        </div>                     \n");
      out.write("                        \n");
      out.write("                        <!-- button: accedi/registrati e carrello per PC -->\n");
      out.write("                        <div class=\"hidden-xs hidden-sm hidden-md col-lg-4\">\n");
      out.write("                        \n");
      out.write("                            <div class=\"row\">                                \n");
      out.write("                                <div class=\"dropdownUtente col-lg-6\" >\n");
      out.write("                                    <div class=\"dropdown\">\n");
      out.write("                                        <button class=\"btn btn-default dropdown-toggle\" type=\"button\" id=\"dropdownMenu1\" data-toggle=\"dropdown\" aria-haspopup=\"true\" aria-expanded=\"true\">\n");
      out.write("                                          Accedi / Registrati\n");
      out.write("                                          <span class=\"caret\"></span>\n");
      out.write("                                        </button>\n");
      out.write("                                        <ul class=\"dropdown-menu\" aria-labelledby=\"dropdownMenu1\">\n");
      out.write("                                          <li><a href=\"#\">Accedi</a></li>\n");
      out.write("                                          <li><a href=\"#\">Registrati</a></li>\n");
      out.write("                                        </ul>\n");
      out.write("                                    </div>\n");
      out.write("                                </div>\n");
      out.write("                                \n");
      out.write("                                <div class=\"col-lg-4\">\n");
      out.write("                                   <button type=\"button\" class=\"btn btn-default btn-md\">\n");
      out.write("                                        <span class=\"glyphicon glyphicon-shopping-cart\" aria-hidden=\"true\"></span>\n");
      out.write("                                    </button>\n");
      out.write("                                </div>\n");
      out.write("                            </div>\n");
      out.write("                        </div>\n");
      out.write("                            \n");
      out.write("                        <div class=\"col-xs-12 hidden-sm hidden-md hidden-lg\">\n");
      out.write("                            <div class=\"menuBar\">\n");
      out.write("                                <nav class=\"navbar navbar-default\">\n");
      out.write("                                    <div class=\"container\">\n");
      out.write("                                        <div class=\"row\">\n");
      out.write("                                      \n");
      out.write("                                            <div class=\"navbar-header col-xs-8\">\n");
      out.write("                                                <p class=\"navbar-text dropdown-toggle\" id=\"...\" data-toggle=\"dropdown\" aria-haspopup=\"true\" aria-expanded=\"true\" >\n");
      out.write("                                                    Scegli categoria <span class=\"caret\"></span>\n");
      out.write("                                                </p>\n");
      out.write("                                                <ul class=\"dropdown-menu dropdown-menu-left col-xs-8 hidden-sm hidden-md hidden-lg\"> <!-- ?????????? sull'ipad non sparisce -->\n");
      out.write("                                                  <li><a href=\"#\">Prodotto</a></li>\n");
      out.write("                                                  <li><a href=\"#\">Categoria</a></li>\n");
      out.write("                                                  <li><a href=\"#\">Luogo</a></li>\n");
      out.write("                                                </ul>\n");
      out.write("                                            </div>\n");
      out.write("                                            <div class=\"navbar-header col-xs-4\">\n");
      out.write("                                                <p class=\"navbar-text dropdown-toggle\" id=\"...\" data-toggle=\"dropdown\" aria-haspopup=\"true\" aria-expanded=\"true\" >\n");
      out.write("                                                    Filtri <span class=\"caret\"></span>\n");
      out.write("                                                </p>\n");
      out.write("                                                <ul class=\"dropdown-menu dropdown-menu-right col-xs-8 hidden-sm hidden-md hidden-lg\"> <!-- ?????????? sull'ipad non sparisce -->\n");
      out.write("                                                  <li><a href=\"#\">Prodotto</a></li>\n");
      out.write("                                                  <li><a href=\"#\">Categoria</a></li>\n");
      out.write("                                                  <li><a href=\"#\">Luogo</a></li>\n");
      out.write("                                                </ul>\n");
      out.write("                                            </div>\n");
      out.write("                                        </div>\n");
      out.write("                                    </div>\n");
      out.write("                                </nav>\n");
      out.write("                            \n");
      out.write("                            </div>\n");
      out.write("                            \n");
      out.write("                        </div>\n");
      out.write("                </div>\n");
      out.write("           \n");
      out.write("                <!-- PROVA -->\n");
      out.write("                <!-- barra del menu OSS: si potrebbe fare che sui dispositivi sm diventa un menu a tendina --    \n");
      out.write("            <div class=\"row menuBar\">            \n");
      out.write("                <nav class=\"navbar navbar-default col-lg-12\">\n");
      out.write("                    <div class=\"container-fluid\">\n");
      out.write("                      <div class=\"navbar-header col-lg-3\">\n");
      out.write("                          <p class=\"navbar-text\">Home1</p>\n");
      out.write("                      </div>\n");
      out.write("                      <div class=\"navbar-header col-lg-3\">\n");
      out.write("                          <p class=\"navbar-text\">Home2</p>\n");
      out.write("                      </div>\n");
      out.write("                      <div class=\"navbar-header col-lg-3\">\n");
      out.write("                          <p class=\"navbar-text\">Home3</p>\n");
      out.write("                      </div>\n");
      out.write("                      <div class=\"navbar-header col-lg-3\">\n");
      out.write("                          <p class=\"navbar-text\">Home4</p>\n");
      out.write("                      </div>\n");
      out.write("                    </div>\n");
      out.write("                </nav>\n");
      out.write("            </div> -->\n");
      out.write("                    \n");
      out.write("                <!-- carousel -->\n");
      out.write("                <div class=\"row galleria\">\n");
      out.write("                    <div class=\"col-lg-12\">\n");
      out.write("                    <div id=\"myCarousel\" class=\"carousel slide\" data-ride=\"carousel\">\n");
      out.write("                        <!-- Indicators -->\n");
      out.write("                        <ol class=\"carousel-indicators\">\n");
      out.write("                          <li data-target=\"#myCarousel\" data-slide-to=\"0\" class=\"active\"></li>\n");
      out.write("                          <li data-target=\"#myCarousel\" data-slide-to=\"1\"></li>\n");
      out.write("                          <li data-target=\"#myCarousel\" data-slide-to=\"2\"></li>\n");
      out.write("                        </ol>\n");
      out.write("\n");
      out.write("                        <!-- Wrapper for slides -->\n");
      out.write("                        <div class=\"carousel-inner\" role=\"listbox\" style=\"background-color: aqua\">\n");
      out.write("\n");
      out.write("                          <div class=\"item active\">\n");
      out.write("                            <img src=\"images/img1.jpg\" alt=\"Chania\">\n");
      out.write("                            <div class=\"carousel-caption\">\n");
      out.write("                              <h3>Chania</h3>\n");
      out.write("                              <p>The atmosphere in Chania has a touch of Florence and Venice.</p>\n");
      out.write("                            </div>\n");
      out.write("                          </div>\n");
      out.write("\n");
      out.write("                          <div class=\"item\">\n");
      out.write("                            <img src=\"images/img2.jpg\" alt=\"Chania\">\n");
      out.write("                            <div class=\"carousel-caption\">\n");
      out.write("                              <h3>Chania</h3>\n");
      out.write("                              <p>The atmosphere in Chania has a touch of Florence and Venice.</p>\n");
      out.write("                            </div>\n");
      out.write("                          </div>\n");
      out.write("                        </div>\n");
      out.write("\n");
      out.write("                        <!-- Left and right controls -->\n");
      out.write("                        <a class=\"left carousel-control col-lg-2\" href=\"#myCarousel\" role=\"button\" data-slide=\"prev\">\n");
      out.write("                          <span class=\"glyphicon glyphicon-chevron-left\" aria-hidden=\"true\"></span>\n");
      out.write("                          <span class=\"sr-only\">Previous</span>\n");
      out.write("                        </a>\n");
      out.write("                        <a class=\"right carousel-control col-lg-2\" href=\"#myCarousel\" role=\"button\" data-slide=\"next\">\n");
      out.write("                          <span class=\"glyphicon glyphicon-chevron-right\" aria-hidden=\"true\"></span>\n");
      out.write("                          <span class=\"sr-only\">Next</span>\n");
      out.write("                        </a>\n");
      out.write("                    </div>\n");
      out.write("                    </div>\n");
      out.write("                </div>\n");
      out.write("            \n");
      out.write("            <!-- PROVE -->\n");
      out.write("            <!-- galleria immagine animata \n");
      out.write("                <div class=\"row\">\n");
      out.write("\n");
      out.write("                    <div class=\"carousel slide\" id=\"carousel-example-generic\"  data-ride=\"carousel\">\n");
      out.write("                        <!-- Indicators \n");
      out.write("                        <ol class=\"carousel-indicators\">\n");
      out.write("                          <li data-target=\"#carousel-example-generic\" data-slide-to=\"0\" class=\"active\"></li>\n");
      out.write("                          <li data-target=\"#carousel-example-generic\" data-slide-to=\"1\"></li>\n");
      out.write("                          <li data-target=\"#carousel-example-generic\" data-slide-to=\"2\"></li>\n");
      out.write("                        </ol>\n");
      out.write("\n");
      out.write("                        <!-- Wrapper for slides\n");
      out.write("                        <div class=\"carousel-inner\" role=\"listbox\">\n");
      out.write("                          <div class=\"item active\">\n");
      out.write("                            <img src=\"images/img1.jpg\" alt=\"...\">\n");
      out.write("                          </div>\n");
      out.write("                          <div class=\"item\">\n");
      out.write("                            <img src=\"images/img2.jpg\" alt=\"...\">\n");
      out.write("                          </div>\n");
      out.write("                            <div class=\"item\">\n");
      out.write("                            <img src=\"images/img3.jpg\" alt=\"...\">\n");
      out.write("                          </div>\n");
      out.write("                        </div>\n");
      out.write("\n");
      out.write("                        <!-- Controls\n");
      out.write("                        <a class=\"left carousel-control\" href=\"#carousel-example-generic\" role=\"button\" data-slide=\"prev\">\n");
      out.write("                          <span class=\"glyphicon glyphicon-chevron-left\" aria-hidden=\"true\"></span>\n");
      out.write("                          <span class=\"sr-only\">Previous</span>\n");
      out.write("                        </a>\n");
      out.write("                        <a class=\"right carousel-control\" href=\"#carousel-example-generic\" role=\"button\" data-slide=\"next\">\n");
      out.write("                          <span class=\"glyphicon glyphicon-chevron-right\" aria-hidden=\"true\"></span>\n");
      out.write("                          <span class=\"sr-only\">Next</span>\n");
      out.write("                        </a>\n");
      out.write("                    </div>\n");
      out.write("                </div>-->\n");
      out.write("            <!--<div class=\"row\">\n");
      out.write("\n");
      out.write("            <div class=\"col-lg-4 col-md-6 mb-4\">\n");
      out.write("              <div class=\"card h-100\">\n");
      out.write("                <a href=\"#\"><img class=\"card-img-top\" src=\"http://placehold.it/700x400\" alt=\"\"></a>\n");
      out.write("                <div class=\"card-body\">\n");
      out.write("                  <h4 class=\"card-title\">\n");
      out.write("                    <a href=\"#\">Item One</a>\n");
      out.write("                  </h4>\n");
      out.write("                  <h5>$24.99</h5>\n");
      out.write("                  <p class=\"card-text\">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Amet numquam aspernatur!</p>\n");
      out.write("                </div>\n");
      out.write("                <div class=\"card-footer\">\n");
      out.write("                  <small class=\"text-muted\">&#9733; &#9733; &#9733; &#9733; &#9734;</small>\n");
      out.write("                </div>\n");
      out.write("              </div>\n");
      out.write("            </div>\n");
      out.write("\n");
      out.write("            <div class=\"col-lg-4 col-md-6 col-xs-5\">\n");
      out.write("              <div class=\"card h-100\">\n");
      out.write("                <a href=\"#\"><img class=\"card-img-top\" src=\"http://placehold.it/700x400\" alt=\"\"></a>\n");
      out.write("                <div class=\"card-body\">\n");
      out.write("                  <h4 class=\"card-title\">\n");
      out.write("                    <a href=\"#\">Item Two</a>\n");
      out.write("                  </h4>\n");
      out.write("                  <h5>$24.99</h5>\n");
      out.write("                  <p class=\"card-text\">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Amet numquam aspernatur! Lorem ipsum dolor sit amet.</p>\n");
      out.write("                </div>\n");
      out.write("                <div class=\"card-footer\">\n");
      out.write("                  <small class=\"text-muted\">&#9733; &#9733; &#9733; &#9733; &#9734;</small>\n");
      out.write("                </div>\n");
      out.write("              </div>\n");
      out.write("            </div>\n");
      out.write("\n");
      out.write("            <div class=\"col-lg-4 col-md-6 col-sm-5\">\n");
      out.write("              <div class=\"card h-100\">\n");
      out.write("                <a href=\"#\"><img class=\"card-img-top\" src=\"images/doge.jpg\" alt=\"\"></a>\n");
      out.write("                <div class=\"card-body\">\n");
      out.write("                  <h4 class=\"card-title\">\n");
      out.write("                    <a href=\"#\">Item Three</a>\n");
      out.write("                  </h4>\n");
      out.write("                  <h5>$24.99</h5>\n");
      out.write("                  <p class=\"card-text\">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Amet numquam aspernatur!</p>\n");
      out.write("                </div>\n");
      out.write("                <div class=\"card-footer\">\n");
      out.write("                  <small class=\"text-muted\">&#9733; &#9733; &#9733; &#9733; &#9734;</small>\n");
      out.write("                </div>\n");
      out.write("              </div>\n");
      out.write("            </div>\n");
      out.write("\n");
      out.write("            <div class=\"col-lg-4 col-md-6 col-xs-5\">\n");
      out.write("              <div class=\"card h-100\">\n");
      out.write("                <a href=\"#\"><img class=\"card-img-top\" src=\"http://placehold.it/700x400\" alt=\"\"></a>\n");
      out.write("                <div class=\"card-body\">\n");
      out.write("                  <h4 class=\"card-title\">\n");
      out.write("                    <a href=\"#\">Item Four</a>\n");
      out.write("                  </h4>\n");
      out.write("                  <h5>$24.99</h5>\n");
      out.write("                  <p class=\"card-text\">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Amet numquam aspernatur!</p>\n");
      out.write("                </div>\n");
      out.write("                <div class=\"card-footer\">\n");
      out.write("                  <small class=\"text-muted\">&#9733; &#9733; &#9733; &#9733; &#9734;</small>\n");
      out.write("                </div>\n");
      out.write("              </div>\n");
      out.write("            </div>\n");
      out.write("\n");
      out.write("            <div class=\"col-lg-4 col-md-6 mb-4\">\n");
      out.write("              <div class=\"card h-100\">\n");
      out.write("                <a href=\"#\"><img class=\"card-img-top\" src=\"http://placehold.it/700x400\" alt=\"\"></a>\n");
      out.write("                <div class=\"card-body\">\n");
      out.write("                  <h4 class=\"card-title\">\n");
      out.write("                    <a href=\"#\">Item Five</a>\n");
      out.write("                  </h4>\n");
      out.write("                  <h5>$24.99</h5>\n");
      out.write("                  <p class=\"card-text\">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Amet numquam aspernatur! Lorem ipsum dolor sit amet.</p>\n");
      out.write("                </div>\n");
      out.write("                <div class=\"card-footer\">\n");
      out.write("                  <small class=\"text-muted\">&#9733; &#9733; &#9733; &#9733; &#9734;</small>\n");
      out.write("                </div>\n");
      out.write("              </div>\n");
      out.write("            </div>\n");
      out.write("\n");
      out.write("            <div class=\"col-lg-4 col-md-6 mb-4\">\n");
      out.write("              <div class=\"card h-100\">\n");
      out.write("                <a href=\"#\"><img class=\"card-img-top\" src=\"http://placehold.it/700x400\" alt=\"\"></a>\n");
      out.write("                <div class=\"card-body\">\n");
      out.write("                  <h4 class=\"card-title\">\n");
      out.write("                    <a href=\"#\">Item Six</a>\n");
      out.write("                  </h4>\n");
      out.write("                  <h5>$24.99</h5>\n");
      out.write("                  <p class=\"card-text\">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Amet numquam aspernatur!</p>\n");
      out.write("                </div>\n");
      out.write("                <div class=\"card-footer\">\n");
      out.write("                  <small class=\"text-muted\">&#9733; &#9733; &#9733; &#9733; &#9734;</small>\n");
      out.write("                </div>\n");
      out.write("              </div>\n");
      out.write("            </div>\n");
      out.write("\n");
      out.write("          </div> -->\n");
      out.write("                        \n");
      out.write("         \n");
      out.write("                <!-- tabella di 2 righe, con 3 colonne, che mostrano 6 prodotti -->\n");
      out.write("                <div class=\"row\">\n");
      out.write("                <div class=\"page\">\n");
      out.write("                        <div class=\"col-sm-6 col-md-4\">\n");
      out.write("                          <div class=\"thumbnail\">\n");
      out.write("                            <img src=\"images/doge.jpg\" alt=\"...\">\n");
      out.write("                            <div class=\"caption\">\n");
      out.write("                              <h3>Prodotto Bello</h3>\n");
      out.write("                              <p>Descrizione bella</p>\n");
      out.write("                              <p><a href=\"#\" class=\"btn btn-primary\" role=\"button\">Vedi prodotto</a> <a href=\"#\" class=\"btn btn-default\" role=\"button\">Aggiungi al carrello</a></p>\n");
      out.write("                            </div>\n");
      out.write("                          </div>\n");
      out.write("                        </div>\n");
      out.write("                        <div class=\"col-sm-6 col-md-4\">\n");
      out.write("                          <div class=\"thumbnail\">\n");
      out.write("                            <img src=\"images/doge.jpg\" alt=\"...\">\n");
      out.write("                            <div class=\"caption\">\n");
      out.write("                              <h3>Prodotto Bello</h3>\n");
      out.write("                              <p>Descrizione bella</p>\n");
      out.write("                              <p><a href=\"#\" class=\"btn btn-primary\" role=\"button\">Vedi prodotto</a> <a href=\"#\" class=\"btn btn-default\" role=\"button\">Aggiungi al carrello</a></p>\n");
      out.write("                            </div>\n");
      out.write("                          </div>\n");
      out.write("                        </div>\n");
      out.write("                        <div class=\"col-sm-6 col-md-4\">\n");
      out.write("                          <div class=\"thumbnail\">\n");
      out.write("                            <img src=\"images/doge.jpg\" alt=\"...\">\n");
      out.write("                            <div class=\"caption\">\n");
      out.write("                              <h3>Prodotto Bello</h3>\n");
      out.write("                              <p>Descrizione bella</p>\n");
      out.write("                              <p><a href=\"#\" class=\"btn btn-primary\" role=\"button\">Vedi prodotto</a> <a href=\"#\" class=\"btn btn-default\" role=\"button\">Aggiungi al carrello</a></p>\n");
      out.write("                            </div>\n");
      out.write("                          </div>\n");
      out.write("                        </div>\n");
      out.write("\n");
      out.write("                        <div class=\"col-sm-6 col-md-4\">\n");
      out.write("                          <div class=\"thumbnail\">\n");
      out.write("                            <img src=\"images/doge.jpg\" alt=\"...\">\n");
      out.write("                            <div class=\"caption\">\n");
      out.write("                              <h3>Prodotto Bello</h3>\n");
      out.write("                              <p>Descrizione bella</p>\n");
      out.write("                              <p><a href=\"#\" class=\"btn btn-primary\" role=\"button\">Vedi prodotto</a> <a href=\"#\" class=\"btn btn-default\" role=\"button\">Aggiungi al carrello</a></p>\n");
      out.write("                            </div>\n");
      out.write("                          </div>\n");
      out.write("                        </div>\n");
      out.write("                        <div class=\"col-sm-6 col-md-4\">\n");
      out.write("                          <div class=\"thumbnail\">\n");
      out.write("                            <img src=\"images/doge.jpg\" alt=\"...\">\n");
      out.write("                            <div class=\"caption\">\n");
      out.write("                              <h3>Prodotto Bello</h3>\n");
      out.write("                              <p>Descrizione bella</p>\n");
      out.write("                              <p><a href=\"#\" class=\"btn btn-primary\" role=\"button\">Vedi prodotto</a> <a href=\"#\" class=\"btn btn-default\" role=\"button\">Aggiungi al carrello</a></p>\n");
      out.write("                            </div>\n");
      out.write("                          </div>\n");
      out.write("                        </div>\n");
      out.write("                        <div class=\"col-sm-6 col-md-4\">\n");
      out.write("                          <div class=\"thumbnail\">\n");
      out.write("                            <img src=\"images/doge.jpg\" alt=\"...\">\n");
      out.write("                            <div class=\"caption\">\n");
      out.write("                              <h3>Prodotto Bello</h3>\n");
      out.write("                              <p>Descrizione bella</p>\n");
      out.write("                              <p><a href=\"#\" class=\"btn btn-primary\" role=\"button\">Vedi prodotto</a> <a href=\"#\" class=\"btn btn-default\" role=\"button\">Aggiungi al carrello</a></p>\n");
      out.write("                            </div>\n");
      out.write("                          </div>\n");
      out.write("                        </div> \n");
      out.write("                </div>\n");
      out.write("            </div>\n");
      out.write("            \n");
      out.write("            <!-- barra bianca a dx -->\n");
      out.write("            <div class=\"hidden-xs col-lg-1\"></div>\n");
      out.write("            \n");
      out.write("            <!-- back to top button -->\n");
      out.write("            <button onclick=\"topFunction()\" id=\"btnTop\" title=\"Go to top\"><span class=\"glyphicon glyphicon-arrow-up\"> Top</span></button>\n");
      out.write("            \n");
      out.write("            <!-- footer -->\n");
      out.write("            <footer style=\"background-color: red\">\n");
      out.write("                <p>&copy; Company 2017</p>\n");
      out.write("            </footer>\n");
      out.write("            \n");
      out.write("            </div>\n");
      out.write("        </div>\n");
      out.write("            \n");
      out.write("            \n");
      out.write("            \n");
      out.write("        <script>\n");
      out.write("            // When the user scrolls down 20px from the top of the document, show the button\n");
      out.write("            window.onscroll = function() {scrollFunction()};\n");
      out.write("\n");
      out.write("            function scrollFunction() {\n");
      out.write("                if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {\n");
      out.write("                    document.getElementById(\"btnTop\").style.display = \"block\";\n");
      out.write("                } else {\n");
      out.write("                    document.getElementById(\"btnTop\").style.display = \"none\";\n");
      out.write("                }\n");
      out.write("            }\n");
      out.write("\n");
      out.write("            // When the user clicks on the button, scroll to the top of the document\n");
      out.write("            function topFunction() {\n");
      out.write("                document.body.scrollTop = 0; // For Chrome, Safari and Opera \n");
      out.write("                document.documentElement.scrollTop = 0; // For IE and Firefox\n");
      out.write("            }\n");
      out.write("        </script>\n");
      out.write("    </body>\n");
      out.write("</html>\n");
    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          out.clearBuffer();
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
