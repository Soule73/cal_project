package com.cal.controlleurs;

import com.cal.Routes;
import com.cal.models.Learner;
import com.cal.models.LearnerLanguage;
import com.cal.models.LearnerSubscription;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Locale;
import java.util.Set;

@WebServlet(name = "apprenant.view", urlPatterns = {Routes.LEARNER_SHOW})
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

            // les langues de l'apprenant
            Set<LearnerLanguage> languages = apprenant.getLearnerLanguages();

            // Récupérer les abonnements et leurs cours pour l'apprenant
            Set<LearnerSubscription> subscriptions = apprenant.getLearnerSubscriptions();
            for (LearnerSubscription subscription : subscriptions) {
                subscription.getSubscription().getCourses().size(); // Initialiser les cours
            }

            request.setAttribute("apprenant", apprenant);
            request.setAttribute("languages", languages);
            request.setAttribute("subscriptions", subscriptions);
            request.setAttribute("formatter", new SimpleDateFormat("EEEE 'Le' dd MMMM yyyy", Locale.FRENCH));

            request.getRequestDispatcher("/WEB-INF/learner/view.jsp").forward(request, response);
        } finally {
            em.close();
        }
    }
}
