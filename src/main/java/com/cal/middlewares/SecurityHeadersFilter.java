package com.cal.middlewares;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebFilter("/*")
public class SecurityHeadersFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Ajout des en-têtes de sécurité
        httpResponse.setHeader("X-Content-Type-Options", "nosniff");
        httpResponse.setHeader("X-Frame-Options", "DENY");
        httpResponse.setHeader("X-XSS-Protection", "1; mode=block");
/*        httpResponse.setHeader("Content-Security-Policy",
                "default-src 'self'; " +
                        "style-src 'self' 'unsafe-inline' *; " +
                        "script-src 'self' 'unsafe-inline' 'unsafe-eval' *; " +
                        "img-src 'self' data: *; " +
                        "font-src 'self' *; " +
                        "connect-src 'self' *; " +
                        "media-src 'self' *; " +
                        "object-src 'none'; " +
                        "frame-src 'self' *;");*/

        chain.doFilter(request, response);
    }

}
