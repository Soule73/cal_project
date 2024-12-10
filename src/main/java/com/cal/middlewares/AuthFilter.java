package com.cal.middlewares;

import com.cal.Routes;
import com.cal.models.User;
import com.cal.utils.Permission;
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

import jakarta.servlet.FilterConfig;

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
        Routes.ROOM_LIST,
        Routes.ROOM_FORM,
        Routes.SUBCRIPTION_LIST,
        Routes.MESSAGE,
        Routes.SUBCRIPTION_FORM,
        Routes.CURRENT_LEARNER
})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath()+Routes.LOGIN);
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        String path = httpRequest.getServletPath();

        if (isAdminRoute(path)) {
            if (Permission.hasRole(currentUser, "ADMIN")) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès interdit.");
                return;
            }
        } else if (Routes.CURRENT_LEARNER.equals(path)) {
            if (Permission.hasRole(currentUser, "LEARNER")) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès interdit.");
                return;
            }
        } else if (isLearnerAndAdminRoute(path)) {
            if (Permission.hasRole(currentUser, "LEARNER") && Permission.hasRole(currentUser, "ADMIN")) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès interdit.");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    private boolean isAdminRoute(String path) {
        return path.equals(Routes.LEARNER_LIST) || path.equals(Routes.LEARNER_FORM) || path.equals(Routes.LEARNER_SHOW)
                || path.equals(Routes.LANG_LIST) || path.equals(Routes.LANG_FORM) || path.equals(Routes.LANG_SHOW)
                || path.equals(Routes.LANG_COURSE) || path.equals(Routes.ROOM_LIST) || path.equals(Routes.ROOM_FORM)
                || path.equals(Routes.COURSE_FORM) || path.equals(Routes.SUBCRIPTION_LIST) || path.equals(Routes.SUBCRIPTION_FORM);
    }

    private boolean isLearnerAndAdminRoute(String path) {
        return path.equals(Routes.LEARN_SUBCRIPTIONS);
    }


}
