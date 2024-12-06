package com.cal.controlleurs.auth;

import com.cal.Routes;
import com.cal.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import java.io.IOException;


@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = (EntityManagerFactory) getServletContext().getAttribute("EntityManagerFactory");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("WEB-INF/auth/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        EntityManager em = emf.createEntityManager();
        TypedQuery<User> query = em.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class);
        query.setParameter("email", email);

        User user;
        try {
            user = query.getSingleResult();
        } catch (NoResultException e) {
            request.setAttribute("error", "Utilisateur non trouvé");
            request.getRequestDispatcher("WEB-INF/auth/login.jsp").forward(request, response);
            return;
        }

        if (BCrypt.checkpw(password, user.getPassword())) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            response.sendRedirect(Routes.LEARNER_LIST);
        } else {
            request.setAttribute("error", "Email ou mot de passe incorrect.");
            request.getRequestDispatcher("WEB-INF/auth/login.jsp").forward(request, response);
        }

        em.close();
    }

    @Override
    public void destroy() {
        if (emf != null) {
            emf.close();
        }
    }
}
