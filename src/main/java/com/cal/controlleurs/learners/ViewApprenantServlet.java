package com.cal.controlleurs.learners;

import com.cal.models.Learner;
import com.cal.models.Subscription;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

import static com.cal.Routes.LEARNER_SHOW;

@WebServlet(name = "apprenant.view", urlPatterns = {LEARNER_SHOW})
public class ViewApprenantServlet extends HttpServlet {

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
            Learner apprenant = em.find(Learner.class, id);
            if (apprenant == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Learner not found");
                return;
            }

            List<Subscription> subscriptionsList = em.createQuery(
                            "SELECT s FROM Subscription s WHERE s.id NOT IN " +
                                    "(SELECT ls.subscription.id FROM LearnerSubscription ls WHERE ls.learner.id = :learnerId)", Subscription.class)
                    .setParameter("learnerId", id)
                    .getResultList();

            request.setAttribute("apprenant", apprenant);
            request.setAttribute("subscriptionsList", subscriptionsList);
            request.getRequestDispatcher("/WEB-INF/learner/view.jsp").forward(request, response);
        } finally {
            em.close();
        }
    }

}
