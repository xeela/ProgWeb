package com.amazoff.filters;

import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Francesco Bruschetti
 */
public class IndexPageFilter implements Filter {
    
    private static final boolean debug = true;
    private FilterConfig filterConfig = null;
    
    public IndexPageFilter() {
    }    
    
    private void doBeforeProcessing(ServletRequest request, ServletResponse response)
            throws IOException, ServletException {
        if (debug) {
            log("IndexPageFilter:DoBeforeProcessing");
        }
       
        /*if (request instanceof HttpServletRequest) {
            ServletContext servletContext = ((HttpServletRequest) request).getServletContext();
            HttpSession session = ((HttpServletRequest) request).getSession(false);

            String contextPath = servletContext.getContextPath();
            if (!contextPath.endsWith("/")) {
                    contextPath += "/";
                }
                ((HttpServletResponse) response).sendRedirect(((HttpServletResponse) response).encodeRedirectURL(contextPath + "login.handler"));
                return;
        }*/
        
     
        
    }    
    
    private void doAfterProcessing(ServletRequest request, ServletResponse response)
            throws IOException, ServletException {
        if (debug) {
            log("IndexPageFilter:DoAfterProcessing");
        }

        
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {
              
        HttpSession session = ((HttpServletRequest) request).getSession();
        if(session.getAttribute("jsonProdottiIndex") == null) {
            ((HttpServletResponse)response).sendRedirect(((HttpServletRequest) request).getContextPath() + "/ServletIndexProducts");       
        }
        else {
            chain.doFilter(request, response);
        }
    }
    
    public FilterConfig getFilterConfig() {
        return (this.filterConfig);
    }

    public void setFilterConfig(FilterConfig filterConfig) {
        this.filterConfig = filterConfig;
    }

    @Override
    public void destroy() {        
    }

    @Override
    public void init(FilterConfig filterConfig) {        
        this.filterConfig = filterConfig;
        if (filterConfig != null) {
            if (debug) {                
                log("IndexPageFilter:Initializing filter");
            }
        }
        
        // Get init parameter 
      String testParam = filterConfig.getInitParameter("test-param"); 
        
        //Print the init parameter 
      System.out.println("Test Param: " + testParam); 
    }

    @Override
    public String toString() {
        if (filterConfig == null) {
            return ("IndexPageFilter()");
        }
        StringBuilder sb = new StringBuilder("IndexPageFilter(");
        sb.append(filterConfig);
        sb.append(")");
        return (sb.toString());
    }
    
    private void sendProcessingError(Throwable t, ServletResponse response) {
        String stackTrace = getStackTrace(t);        
        
        if (stackTrace != null && !stackTrace.equals("")) {
            try {
                response.setContentType("text/html");
                PrintStream ps = new PrintStream(response.getOutputStream());
                PrintWriter pw = new PrintWriter(ps);                
                pw.print("<html>\n<head>\n<title>Error</title>\n</head>\n<body>\n"); //NOI18N

                // PENDING! Localize this for next official release
                pw.print("<h1>The resource did not process correctly</h1>\n<pre>\n");                
                pw.print(stackTrace);                
                pw.print("</pre></body>\n</html>"); //NOI18N
                pw.close();
                ps.close();
                response.getOutputStream().close();
            } catch (IOException ex) {
            }
        } else {
            try {
                PrintStream ps = new PrintStream(response.getOutputStream());
                t.printStackTrace(ps);
                ps.close();
                response.getOutputStream().close();
            } catch (IOException ex) {
            }
        }
    }
    
    public static String getStackTrace(Throwable t) {
        String stackTrace = null;
        try {
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            t.printStackTrace(pw);
            pw.close();
            sw.close();
            stackTrace = sw.getBuffer().toString();
        } catch (IOException ex) {
        }
        return stackTrace;
    }
    
    public void log(String msg) {
        filterConfig.getServletContext().log(msg);        
    }
    
}
