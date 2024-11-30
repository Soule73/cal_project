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
        response.setContentType("application/json");

        JSONObject jsonObject = JsonData.parseRequestBody(request, response);
        if (jsonObject == null) return;

        Map<String, String> errors = new HashMap<>();

        Subscription subscription = new Subscription();
        try {
            setSubscritionFileds(jsonObject, subscription);
        } catch (Exception e) {

            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            errors.put("global", "Données JSON invalides");
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
            return;
        }


        if (validateSubscriptionForm(response, errors, subscription)) return;

        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();

        try {
            transaction.begin();
            em.persist(subscription);
            transaction.commit();

            em.refresh(subscription);

            response.setStatus(HttpServletResponse.SC_CREATED);
            response.getWriter().write(new JSONObject(Map.of("message", "L'abonnement a été ajouté avec succès!", "roomId", subscription.getId())).toString());

        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }

            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            errors.put("global", "Une erreur s'est produite lors de l'ajout du cours.");
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());

        } finally {
            if (em.isOpen()) {
                em.close();
            }
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");

        JSONObject jsonObject = JsonData.parseRequestBody(request, response);
        if (jsonObject == null) return;

        long subscriptionId = jsonObject.optLong("id", 0);

        Map<String, String> errors = new HashMap<>();

        if (subscriptionId == 0) {

            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            errors.put("id", "ID de l'abonnement manquant");
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
            return;
        }

        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();

    try {
            transaction.begin();
            Subscription subscription = em.find(Subscription.class, subscriptionId);
            if (subscription == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                errors.put("global", "Abonnement non trouvé");
                response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
                return;

            }

            setSubscritionFileds(jsonObject, subscription);

            if (validateSubscriptionForm(response, errors, subscription)) return;


            em.merge(subscription);
            transaction.commit();

            em.refresh(subscription);

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(new JSONObject(Map.of("message", "L'abonnement a été mis à jour avec succès!")).toString());

        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }

            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            errors.put("global", "Une erreur s'est produite lors de la mise à jour de l'abonnement.");
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());

        } finally {
            if (em.isOpen()) {
                em.close();
            }
        }
    }

    private void setSubscritionFileds(JSONObject jsonObject, Subscription subscription) {
        subscription.setName(jsonObject.getString("name"));

        if(jsonObject.has("price") && !jsonObject.optString("price", "").isEmpty()){

            subscription.setPrice(Double.parseDouble(jsonObject.getString("price")));
        }
        subscription.setDescription(jsonObject.optString("description"));
        subscription.setAccessConditions(jsonObject.optString("accessConditions"));
        subscription.setType(jsonObject.getString("type"));
        subscription.setStatus(jsonObject.getString("status"));
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");

        JSONObject jsonObject = JsonData.parseRequestBody(request, response);
        if (jsonObject == null) return;

        Map<String, String> errors = new HashMap<>();

        long subscriptionId = jsonObject.optLong("id", 0);
        if (subscriptionId == 0) {

            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            errors.put("id", "ID de l'abonnement manquant");
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
            return;
        }

        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();

        try {
            transaction.begin();
            Subscription subscription = em.find(Subscription.class, subscriptionId);
            if (subscription == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                errors.put("global", "L'bonnement non trouvé");
                response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
                return;
            }

            em.remove(subscription);
            transaction.commit();

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(new JSONObject(Map.of("message", "L'abonnement a été supprimé avec succès!")).toString());

        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }

            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            errors.put("global", "Une erreur s'est produite lors de la mise à jour de l'abonnement.");
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());

        } finally {
            if (em.isOpen()) {
                em.close();
            }
        }
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

}
