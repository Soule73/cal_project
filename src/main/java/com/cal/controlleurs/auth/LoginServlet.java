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
            em.refresh(user);
        } catch (NoResultException e) {
            request.setAttribute("error", "Utilisateur non trouvé.");
            request.getRequestDispatcher("WEB-INF/auth/login.jsp").forward(request, response);
            return;
        }

        String storedPasswordHash = user.getPassword();

        if (storedPasswordHash == null || storedPasswordHash.isEmpty()) {
            request.setAttribute("error", "Le mot de passe n'est pas défini. Veuillez contacter l'administrateur pour définir un mot de passe.");
            request.getRequestDispatcher("WEB-INF/auth/login.jsp").forward(request, response);
            return;
        }

        if (BCrypt.checkpw(password, storedPasswordHash)) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userRoles", user.getRoles());

            if (user.getRoles().stream().anyMatch(role -> role.getName().equals("ADMIN"))) {
                response.sendRedirect(request.getContextPath() + Routes.LEARNER_LIST);
            } else {
                response.sendRedirect(request.getContextPath() + Routes.CURRENT_LEARNER);
            }

        } else {
            request.setAttribute("error", "Email ou mot de passe incorrect.");
            request.getRequestDispatcher("WEB-INF/auth/login.jsp").forward(request, response);
        }

        em.close();
    }

    @Override
    public void destroy() {
        if (emf.isOpen()) {
            emf.close();
        }
    }
}
