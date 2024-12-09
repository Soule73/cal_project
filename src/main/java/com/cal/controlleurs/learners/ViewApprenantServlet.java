package com.cal.controlleurs.learners;

import com.cal.Routes;
import com.cal.models.User;
import com.cal.models.Subscription;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.NoResultException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "apprenant.view", urlPatterns = {
        Routes.LEARNER_SHOW,
        Routes.CURRENT_LEARNER,
})
public class ViewApprenantServlet extends HttpServlet {

    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = (EntityManagerFactory) getServletContext().getAttribute("EntityManagerFactory");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        Long id = null;
        EntityManager em = emf.createEntityManager();

        try {
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");

            String path = request.getServletPath();

            // Vérification de la route et récupération de l'ID
            if (Routes.CURRENT_LEARNER.equals(path)) {
                id = currentUser.getId();
            } else if (Routes.LEARNER_SHOW.equals(path)) {
                String idParam = request.getParameter("id");
                if (idParam != null) {
                    id = Long.parseLong(idParam);
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Paramètre ID manquant.");
                    return;
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Route non trouvée.");
                return;
            }

            // Récupérer les informations de l'apprenant à partir de la base de données
            User learner = em.find(User.class, id);
            if (learner == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Apprenant non trouvé.");
                return;
            }

            List<Subscription> subscriptionsList = em.createQuery(
                            "SELECT s FROM Subscription s WHERE s.id NOT IN " +
                                    "(SELECT ls.subscription.id FROM LearnerSubscription ls WHERE ls.learner.id = :learnerId)", Subscription.class)
                    .setParameter("learnerId", id)
                    .getResultList();

            request.setAttribute("apprenant", learner);
            request.setAttribute("subscriptionsList", subscriptionsList);
            request.getRequestDispatcher("/WEB-INF/learner/view.jsp").forward(request, response);
        } catch (NoResultException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } finally {
            em.close();
        }
    }

    @Override
    public void destroy() {
        if (emf != null) {
            emf.close();
        }
    }
}
