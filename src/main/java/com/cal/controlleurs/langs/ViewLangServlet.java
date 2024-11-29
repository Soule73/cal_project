package com.cal.controlleurs.langs;

import com.cal.Routes;
import com.cal.models.*;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "cours.view", urlPatterns = {Routes.LANG_SHOW})
public class ViewLangServlet extends HttpServlet {

    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = (EntityManagerFactory) getServletContext().getAttribute("EntityManagerFactory");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        EntityManager em = emf.createEntityManager();

        try {
            Language language = em.createQuery("SELECT l FROM Language l WHERE l.id = :id", Language.class)
                    .setParameter("id", id)
                    .getSingleResult();

            if (language == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Language not found");
                return;
            }

            // Forcer l'actualisation de l'entité
            em.refresh(language);

            List<Level> levels = em.createQuery("SELECT l FROM Level l", Level.class).getResultList();
            List<Subscription> subscriptions = em.createQuery("SELECT s FROM Subscription s", Subscription.class).getResultList();
            List<Room> rooms = em.createQuery("SELECT r FROM Room r", Room.class).getResultList();

            request.setAttribute("language", language);
            request.setAttribute("levels", levels);
            request.setAttribute("rooms", rooms);
            request.setAttribute("subscriptions", subscriptions);

            request.getRequestDispatcher("/WEB-INF/langs/view.jsp").forward(request, response);
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

}

