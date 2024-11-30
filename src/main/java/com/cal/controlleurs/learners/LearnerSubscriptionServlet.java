package com.cal.controlleurs.learners;

import com.cal.models.Course;
import com.cal.models.Learner;
import com.cal.models.LearnerSubscription;
import com.cal.models.Subscription;
import com.cal.utils.JsonData;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.EntityTransaction;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.util.Set;

import static com.cal.Routes.LEARN_SUBCRIPTIONS;

@WebServlet(name = "LearnerSubscriptionServlet", urlPatterns = {LEARN_SUBCRIPTIONS})
public class LearnerSubscriptionServlet extends HttpServlet {

    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = (EntityManagerFactory) getServletContext().getAttribute("EntityManagerFactory");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Long learnerId = Long.parseLong(request.getParameter("learnerId"));
        EntityManager em = emf.createEntityManager();
        try {
            Learner learner = em.find(Learner.class, learnerId);
            if (learner == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Learner not found");
                return;
            }

            em.refresh(learner);
            // Forcer la mise à jour des abonnements
            learner.getLearnerSubscriptions().forEach(ls -> em.refresh(ls.getSubscription()));

            Set<LearnerSubscription> subscriptions = learner.getLearnerSubscriptions();
            JSONArray subscriptionsJson = getSubscriptionsJson(subscriptions);

            response.setContentType("application/json");
            response.getWriter().write(subscriptionsJson.toString());
        } finally {
            em.close();
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        JSONObject jsonObject = JsonData.parseRequestBody(request, response);
        if (jsonObject == null) return;

        long learnerId = jsonObject.optLong("learnerId", 0);
        long subscriptionId = jsonObject.optLong("subscriptionId", 0);

        if (learnerId == 0 || subscriptionId == 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(new JSONObject().put("error", "Invalid learner or subscription ID").toString());
            return;
        }

        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();

        try {
            transaction.begin();
            Learner learner = em.find(Learner.class, learnerId);
            Subscription subscription = em.find(Subscription.class, subscriptionId);

            if (learner == null || subscription == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write(new JSONObject().put("error", "Learner or Subscription not found").toString());
                return;
            }

            LearnerSubscription learnerSubscription = new LearnerSubscription();
            learnerSubscription.setLearner(learner);
            learnerSubscription.setSubscription(subscription);

            em.persist(learnerSubscription);
            transaction.commit();

            response.setStatus(HttpServletResponse.SC_CREATED);
            response.getWriter().write(new JSONObject().put("message", "Subscription added successfully").toString());
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(new JSONObject().put("error", "An error occurred while adding the subscription").toString());
        } finally {
            if (em.isOpen()) {
                em.close();
            }
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        JSONObject jsonObject = JsonData.parseRequestBody(request, response);
        if (jsonObject == null) return;

        long learnerId = jsonObject.optLong("learnerId", 0);
        long subscriptionId = jsonObject.optLong("subscriptionId", 0);

        if (learnerId == 0 || subscriptionId == 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(new JSONObject().put("error", "Invalid learner or subscription ID").toString());
            return;
        }

        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();

        try {
            transaction.begin();
            Learner learner = em.find(Learner.class, learnerId);
            Subscription subscription = em.find(Subscription.class, subscriptionId);

            if (learner == null || subscription == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write(new JSONObject().put("error", "Learner or Subscription not found").toString());
                return;
            }

            LearnerSubscription learnerSubscription = em.createQuery(
                            "SELECT ls FROM LearnerSubscription ls WHERE ls.learner = :learner AND ls.subscription = :subscription", LearnerSubscription.class)
                    .setParameter("learner", learner)
                    .setParameter("subscription", subscription)
                    .getSingleResult();

            em.remove(learnerSubscription);
            transaction.commit();

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(new JSONObject().put("message", "Subscription removed successfully").toString());
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(new JSONObject().put("error", "An error occurred while removing the subscription").toString());
        } finally {
            if (em.isOpen()) {
                em.close();
            }
        }
    }

    private JSONArray getSubscriptionsJson(Set<LearnerSubscription> subscriptions) {
        JSONArray jsonArray = new JSONArray();
        for (LearnerSubscription learnerSubscription : subscriptions) {
            JSONObject json = new JSONObject();
            json.put("id", learnerSubscription.getSubscription().getId());
            json.put("name", learnerSubscription.getSubscription().getName());
            json.put("description", learnerSubscription.getSubscription().getDescription());
            json.put("courses", getCoursesJson(learnerSubscription.getSubscription().getCourses()));
            jsonArray.put(json);
        }
        return jsonArray;
    }

    private JSONArray getCoursesJson(Set<Course> courses) {
        JSONArray jsonArray = new JSONArray();
        for (Course course : courses) {
            JSONObject json = new JSONObject();
            json.put("id", course.getId());
            json.put("identifier", course.getIdentifier());
            json.put("name", course.getName());
            json.put("description", course.getDescription());
            json.put("typeOfCourse", course.getTypeOfCourse());
            jsonArray.put(json);
        }
        return jsonArray;
    }
}

