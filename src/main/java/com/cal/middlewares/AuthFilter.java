package com.cal.middlewares;

import com.cal.Routes;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(urlPatterns = {
        Routes.LEARNER_LIST,
        Routes.LEARNER_SHOW,
        Routes.LEARNER_FORM,
        Routes.LEARN_SUBCRIPTIONS,
        Routes.LANG_LIST,
        Routes.LANG_FORM,
        Routes.LANG_COURSE,
        Routes.LANG_SHOW,
        Routes.COURSE_FORM,
        Routes.LOGOUT,
        Routes.LOGOUT,
        Routes.ROOM_LIST,
        Routes.ROOM_FORM,
        Routes.COURSE_FORM,
        Routes.SUBCRIPTION_LIST,
        Routes.SUBCRIPTION_FORM,

})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            httpResponse.sendRedirect(Routes.LOGIN);
        } else {
            chain.doFilter(request, response);
        }
    }

}
