package com.cal.controlleurs.langs;

import com.cal.models.Language;
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

import static com.cal.Routes.LANG_FORM;

@WebServlet(LANG_FORM)
public class LangFormServlet extends HttpServlet {

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
        Language language = new Language();

        try {
            setLanguageFields(jsonObject, language);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            errors.put("global", "Données JSON invalides");
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
            return;
        }

        if (validateLanguageForm(response, errors, language)) return;

        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();

        try {
            transaction.begin();
            em.persist(language);
            transaction.commit();

            em.refresh(language);

            response.setStatus(HttpServletResponse.SC_CREATED);
            response.getWriter().write(new JSONObject(Map.of("message", "La langue a été ajoutée avec succès!", "languageId", language.getId())).toString());
        } catch (Exception e) {
            handleException(e, transaction, response, errors);
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
        long languageId = jsonObject.optLong("id", 0);
        if (languageId == 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            errors.put("id", "ID de la langue manquant");
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
            return;
        }

        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();

        try {
            transaction.begin();
            Language language = em.find(Language.class, languageId);
            if (language == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                errors.put("global", "Langue non trouvée");
                response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
                return;
            }

            try {
                setLanguageFields(jsonObject, language);
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                errors.put("global", "Données JSON invalides");
                response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
                return;
            }

            if (validateLanguageForm(response, errors, language)) return;

            em.merge(language);
            transaction.commit();

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(new JSONObject(Map.of("message", "Les informations de la langue ont été mises à jour avec succès!")).toString());
        } catch (Exception e) {
            handleException(e, transaction, response, errors);
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
        long languageId = jsonObject.optLong("id", 0);
        if (languageId == 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            errors.put("id", "ID de la langue manquant");
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
            return;
        }

        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();

        try {
            transaction.begin();
            Language language = em.find(Language.class, languageId);
            if (language == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                errors.put("global", "Langue non trouvée");
                response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
                return;
            }

            em.remove(language);
            transaction.commit();

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(new JSONObject(Map.of("message", "La langue a été supprimée avec succès!")).toString());
        } catch (Exception e) {
            handleException(e, transaction, response, errors);
        } finally {
            if (em.isOpen()) {
                em.close();
            }
        }
    }

    private boolean validateLanguageForm(HttpServletResponse response, Map<String, String> errors, Language language) throws IOException {
        ValidatorFactory factory = Validation.buildDefaultValidatorFactory();
        Validator validator = factory.getValidator();
        Set<ConstraintViolation<Language>> violations = validator.validate(language);

        if (!violations.isEmpty()) {
            for (ConstraintViolation<Language> violation : violations) {
                errors.put(violation.getPropertyPath().toString(), violation.getMessage());
            }
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
            return true;
        }
        return false;
    }

    private void setLanguageFields(JSONObject jsonObject, Language language) {
        language.setName(jsonObject.getString("name"));
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
            errors.put("name", "Le nom de la langue est déjà utilisé");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            errors.put("global", "Une erreur s'est produite lors de l'opération");
        }
        response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
    }
}
