package com.cal.controlleurs.learners;

import com.cal.Routes;
import com.cal.models.Learner;
import com.cal.utils.JsonData;
import com.cal.utils.ValidationUtils;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.EntityTransaction;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONObject;

import java.io.IOException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@WebServlet(Routes.LEARNER_FORM)
public class LearnerFormServlet extends HttpServlet {

    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = (EntityManagerFactory) getServletContext().getAttribute("EntityManagerFactory");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        JSONObject jsonObject = JsonData.parseRequestBody(request, response);
        if (jsonObject == null) return;

        Map<String, String> errors = new HashMap<>();
        Learner learner = new Learner();
        try {
            checkInputValue(jsonObject, learner);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            errors.put("global", "Données JSON invalides");
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
            return;
        }

        if (ValidationUtils.validateLearner(response, errors, learner)) return;

        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();

        try {
            transaction.begin();
            em.persist(learner);
            transaction.commit();
            em.refresh(learner);

            response.setStatus(HttpServletResponse.SC_CREATED);
            response.getWriter().write(new JSONObject(Map.of("message", "L'apprenant a été ajouté avec succès!", "learnerId", learner.getId())).toString());
        } catch (Exception e) {
            handleException(response, errors, em , e);
        } finally {
            if (em.isOpen()) {
                em.close();
            }
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws IOException {
        JSONObject jsonObject = JsonData.parseRequestBody(request, response);
        if (jsonObject == null) return;

        Map<String, String> errors = new HashMap<>();
        long learnerId = jsonObject.optLong("id", 0);
        if (learnerId == 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            errors.put("id", "ID de l'apprenant manquant");
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
            return;
        }

        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();

        try {
            transaction.begin();
            Learner learner = em.find(Learner.class, learnerId);
            if (learner == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                errors.put("global", "Apprenant non trouvé");
                response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
                return;
            }

            try {
                checkInputValue(jsonObject, learner);
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                errors.put("global", "Données JSON invalides");
                response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
                return;
            }

            if (ValidationUtils.validateLearner(response, errors, learner)) return;

            em.merge(learner);
            transaction.commit();

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(new JSONObject(Map.of("message", "Les informations ont été mises à jour avec succès!")).toString());
        } catch (Exception e) {
            handleException(response, errors, em , e);
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

        Map<String, String> errors = new HashMap<>();
        long learnerId = jsonObject.optLong("id", 0);
        if (learnerId == 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            errors.put("id", "ID de l'apprenant manquant");
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
            return;
        }

        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();

        try {
            transaction.begin();
            Learner learner = em.find(Learner.class, learnerId);
            if (learner == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                errors.put("global", "Apprenant non trouvé");
                response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
                return;
            }

            em.remove(learner);
            transaction.commit();

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(new JSONObject(Map.of("message", "L'apprenant a été supprimé avec succès!")).toString());
        } catch (Exception e) {
            handleException(response, errors, em , e);
        } finally {
            if (em.isOpen()) {
                em.close();
            }
        }
    }

    private void checkInputValue(JSONObject jsonObject, Learner learner) {
        learner.setFirstname(jsonObject.getString("firstname"));
        learner.setLastname(jsonObject.getString("lastname"));
        learner.setEmail(jsonObject.optString("email"));
        learner.setCreatedAt(new Date());
    }

    private void handleException(HttpServletResponse response, Map<String, String> errors,EntityManager em, Exception e) throws IOException {
        if (em.getTransaction().isActive()) {
            em.getTransaction().rollback();
        }

        Throwable cause = e.getCause();
        while (cause != null && !(cause instanceof SQLIntegrityConstraintViolationException)) {
            cause = cause.getCause();
        }

        if (cause != null) {
            errors.put("email", "L'email est déjà utilisé");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            errors.put("global", "Une erreur s'est produite lors du traitement de la requête");
        }

        response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
    }
}
