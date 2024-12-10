package com.cal.controlleurs.learners;

import com.cal.Routes;
import com.cal.models.Role;
import com.cal.models.User;
import com.cal.models.UserRole;
import com.cal.models.UserRoleId;
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
import org.mindrot.jbcrypt.BCrypt;

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
        JSONObject jsonObject = JsonData.parseRequestBody(request, response);
        if (jsonObject == null) return;

        Map<String, String> errors = new HashMap<>();
        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();

        try {
            User learner = null;
            if (method != HttpMethod.POST) {
                learner = findLearner(jsonObject, response, errors, em);
                if (learner == null) return; // Response already handled in findLearner
            }

            transaction.begin();
            if (method == HttpMethod.DELETE) {
                em.remove(learner);
                transaction.commit();
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write(new JSONObject(Map.of("message", "L'apprenant a été supprimé avec succès!")).toString());
                return;
            }

            if (method == HttpMethod.POST) {
                learner = new User();
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

            if (jsonObject.has("password") && !jsonObject.getString("password").isEmpty()) {
                String hashedPassword = BCrypt.hashpw(jsonObject.getString("password"), BCrypt.gensalt());
                learner.setPassword(hashedPassword);
            }

            if (method == HttpMethod.POST) {
                em.persist(learner);
                em.flush();
                assignRoleToLearner(em, learner);
            } else {
                em.merge(learner);
            }

            transaction.commit();
            em.refresh(learner);

            if (method == HttpMethod.POST) {
                response.setStatus(HttpServletResponse.SC_CREATED);
                response.getWriter().write(new JSONObject(Map.of("message", "L'apprenant a été ajouté avec succès!", "learnerId", learner.getId())).toString());
            } else {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write(new JSONObject(Map.of("message", "Les informations ont été mises à jour avec succès!")).toString());
            }
        } catch (Exception e) {
            handleException(response, errors, em, e);
        } finally {
            if (em.isOpen()) {
                em.close();
            }
        }
    }

    private User findLearner(JSONObject jsonObject, HttpServletResponse response, Map<String, String> errors, EntityManager em) throws IOException {
        long learnerId = jsonObject.optLong("id", 0);
        if (learnerId == 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            errors.put("id", "ID de l'apprenant manquant");
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
            return null;
        }

        User learner = em.find(User.class, learnerId);
        if (learner == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            errors.put("global", "Apprenant non trouvé");
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
            return null;
        }

        return learner;
    }

    private void assignRoleToLearner(EntityManager em, User learner) {
        Role learnerRole = em.createQuery("SELECT r FROM Role r WHERE r.name = 'LEARNER'", Role.class).getSingleResult();
        UserRole userRole = new UserRole();
        userRole.setId(new UserRoleId(learner.getId(), learnerRole.getId()));
        userRole.setUser(learner);
        userRole.setRole(learnerRole);
        em.persist(userRole);
    }

    private void checkInputValue(JSONObject jsonObject, User learner) {
        learner.setFirstname(jsonObject.getString("firstname"));
        learner.setLastname(jsonObject.getString("lastname"));
        learner.setEmail(jsonObject.optString("email"));
        learner.setCreatedAt(new Date());
    }

    private void handleException(HttpServletResponse response, Map<String, String> errors, EntityManager em, Exception e) throws IOException {
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
            System.out.print(e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            errors.put("global", "Une erreur s'est produite lors du traitement de la requête");
        }

        response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
    }

    private enum HttpMethod {
        POST, PUT, DELETE
    }
}
