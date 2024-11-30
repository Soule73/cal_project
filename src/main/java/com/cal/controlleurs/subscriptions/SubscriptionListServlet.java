package com.cal.controlleurs.subscriptions;

import com.cal.Routes;
import com.cal.models.Subscription;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.TypedQuery;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(Routes.SUBCRIPTION_LIST)
public class SubscriptionListServlet extends HttpServlet {

    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = (EntityManagerFactory) getServletContext().getAttribute("EntityManagerFactory");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/subscriptions/list.jsp")
                .forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");

        String jsonString = request.getReader().lines().collect(Collectors.joining());

        JSONObject jsonObject;
        try {
            jsonObject = new JSONObject(jsonString);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(new JSONObject().put("error", "Invalid JSON data").toString());
            return;
        }

        int page = jsonObject.optInt("page", 1);
        int pageSize = jsonObject.optInt("pageSize", 10);
        String searchQuery = jsonObject.optString("searchQuery", "");

        try (EntityManager em = emf.createEntityManager()) {
            String queryStr = "SELECT s FROM Subscription s";
            if (!searchQuery.isEmpty()) {
                queryStr += " WHERE s.name LIKE :searchQuery OR s.description LIKE :searchQuery";
            }
            queryStr += " ORDER BY s.id";
            TypedQuery<Subscription> query = em.createQuery(queryStr, Subscription.class)
                    .setFirstResult((page - 1) * pageSize)
                    .setMaxResults(pageSize);

            if (!searchQuery.isEmpty()) {
                query.setParameter("searchQuery", "%" + searchQuery + "%");
            }

            List<Subscription> subscriptions = query.getResultList();

            // Compter le nombre total d'abonnements pour la pagination
            TypedQuery<Long> countQuery = em.createQuery("SELECT COUNT(s) FROM Subscription s", Long.class);
            if (!searchQuery.isEmpty()) {
                countQuery = em.createQuery("SELECT COUNT(s) FROM Subscription s WHERE s.name LIKE :searchQuery OR s.description LIKE :searchQuery", Long.class);
                countQuery.setParameter("searchQuery", "%" + searchQuery + "%");
            }

            long totalSubscriptions = countQuery.getSingleResult();

            JSONObject result = new JSONObject();
            JSONArray subscriptionsJsonArray = new JSONArray();

            for (Subscription subscription : subscriptions) {
                JSONObject subscriptionJson = getJsonObject(subscription);
                subscriptionsJsonArray.put(subscriptionJson);
            }

            result.put("subscriptions", subscriptionsJsonArray);
            result.put("totalSubscriptions", totalSubscriptions);
            result.put("page", page);
            result.put("pageSize", pageSize);

            response.getWriter().write(result.toString());
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(new JSONObject().put("error", "Une erreur s'est produite").toString());
        }
    }

    private static JSONObject getJsonObject(Subscription subscription) {
        JSONObject subscriptionJson = new JSONObject();
        subscriptionJson.put("id", subscription.getId());
        subscriptionJson.put("name", subscription.getName());
        subscriptionJson.put("price", subscription.getPrice());
        subscriptionJson.put("description", subscription.getDescription());
        subscriptionJson.put("accessConditions", subscription.getAccessConditions());
        subscriptionJson.put("type", subscription.getType());
        subscriptionJson.put("status", subscription.getStatus());
        return subscriptionJson;
    }
}
