package com.cal.controlleurs.subscriptions;

import com.cal.Routes;
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
import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.ValidatorFactory;
import org.json.JSONObject;

import java.io.IOException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

@WebServlet(Routes.SUBCRIPTION_FORM)
public class SubscriptionFormServlet extends HttpServlet {

    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = (EntityManagerFactory) getServletContext().getAttribute("EntityManagerFactory");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        processRequest(request, response, HttpMethod.POST);
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws IOException {
        processRequest(request, response, HttpMethod.PUT);
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        processRequest(request, response, HttpMethod.DELETE);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response, HttpMethod method) throws IOException {
        response.setContentType("application/json");

        JSONObject jsonObject = JsonData.parseRequestBody(request, response);
        if (jsonObject == null) return;

        Map<String, String> errors = new HashMap<>();
        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();

        try {
            Subscription subscription = null;
            if (method != HttpMethod.POST) {
                subscription = findSubscription(jsonObject, response, errors, em);
                if (subscription == null) return; // Response already handled in findSubscription
            }

            transaction.begin();
            if (method == HttpMethod.DELETE) {
                em.remove(subscription);
                transaction.commit();
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write(new JSONObject(Map.of("message", "L'abonnement a été supprimé avec succès!")).toString());
                return;
            }

            if (method == HttpMethod.POST) {
                subscription = new Subscription();
            }

            try {
                setSubscriptionFields(jsonObject, subscription);
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                errors.put("global", "Données JSON invalides");
                response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
                return;
            }

            if (validateSubscriptionForm(response, errors, subscription)) return;

            if (method == HttpMethod.POST) {
                em.persist(subscription);
            } else {
                em.merge(subscription);
            }

            transaction.commit();
            em.refresh(subscription);

            if (method == HttpMethod.POST) {
                response.setStatus(HttpServletResponse.SC_CREATED);
                response.getWriter().write(new JSONObject(Map.of("message", "L'abonnement a été ajouté avec succès!", "subscriptionId", subscription.getId())).toString());
            } else {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write(new JSONObject(Map.of("message", "L'abonnement a été mis à jour avec succès!")).toString());
            }
        } catch (Exception e) {
            handleException(e, transaction, response, errors);
        } finally {
            if (em.isOpen()) {
                em.close();
            }
        }
    }

    private Subscription findSubscription(JSONObject jsonObject, HttpServletResponse response, Map<String, String> errors, EntityManager em) throws IOException {
        long subscriptionId = jsonObject.optLong("id", 0);
        if (subscriptionId == 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            errors.put("id", "ID de l'abonnement manquant");
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
            return null;
        }

        Subscription subscription = em.find(Subscription.class, subscriptionId);
        if (subscription == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            errors.put("global", "Abonnement non trouvé");
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
            return null;
        }

        return subscription;
    }

    private boolean validateSubscriptionForm(HttpServletResponse response, Map<String, String> errors, Subscription subscription) throws IOException {
        ValidatorFactory factory = Validation.buildDefaultValidatorFactory();
        Validator validator = factory.getValidator();
        Set<ConstraintViolation<Subscription>> violations = validator.validate(subscription);

        if (!violations.isEmpty()) {
            for (ConstraintViolation<Subscription> violation : violations) {
                errors.put(violation.getPropertyPath().toString(), violation.getMessage());
            }
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
            return true;
        }
        return false;
    }

    private void setSubscriptionFields(JSONObject jsonObject, Subscription subscription) {
        subscription.setName(jsonObject.getString("name"));
        if (jsonObject.has("price") && !jsonObject.optString("price", "").isEmpty()) {
            subscription.setPrice(Double.parseDouble(jsonObject.get("price").toString()));
        }
        subscription.setDescription(jsonObject.optString("description"));
        subscription.setAccessConditions(jsonObject.optString("accessConditions"));
        subscription.setType(jsonObject.getString("type"));
        subscription.setStatus(jsonObject.getString("status"));
    }

    private void handleException(Exception e, EntityTransaction transaction, HttpServletResponse response, Map<String, String> errors) throws IOException {
        if (transaction.isActive()) {
            transaction.rollback();
        }

        Throwable cause = e.getCause();
        while (cause != null && !(cause instanceof SQLIntegrityConstraintViolationException)) {
            cause = cause.getCause();
        }

        if (cause != null) {
            errors.put("name", "Le nom de l'abonnement est déjà utilisé");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            errors.put("global", "Une erreur s'est produite lors de l'opération");
        }

        response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
    }

    private enum HttpMethod {
        POST, PUT, DELETE
    }
}
