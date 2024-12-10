package com.cal.controlleurs.courses;

import com.cal.models.Course;
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

import static com.cal.Routes.COURSE_FORM;

@WebServlet(COURSE_FORM)
public class CourseFormServlet extends HttpServlet {

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
            Course course = null;
            if (method != HttpMethod.POST) {
                course = findCourse(jsonObject, response, errors, em);
                if (course == null) return; // Response already handled in findCourse
            }

            transaction.begin();
            if (method == HttpMethod.DELETE) {
                em.remove(course);
                transaction.commit();
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write(new JSONObject(Map.of("message", "Le cours a été supprimé avec succès!")).toString());
                return;
            }

            if (method == HttpMethod.POST) {
                course = new Course();
            }

            try {
                checkInputValue(jsonObject, course);
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                errors.put("global", "Données JSON invalides");
                response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
                return;
            }

            if (validateCourseForm(response, errors, course)) return;

            if (method == HttpMethod.POST) {
                em.persist(course);
            } else {
                em.merge(course);
            }

            transaction.commit();
            em.refresh(course);

            if (method == HttpMethod.POST) {
                response.setStatus(HttpServletResponse.SC_CREATED);
                response.getWriter().write(new JSONObject(Map.of("message", "Le cours a été ajouté avec succès!", "courseId", course.getId())).toString());
            } else {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write(new JSONObject(Map.of("message", "Le cours a été mis à jour avec succès!")).toString());
            }
        } catch (Exception e) {
            handleException((Exception) response, (EntityManager) errors, (HttpServletResponse) em, (Map<String, String>) e);
        } finally {
            if (em.isOpen()) {
                em.close();
            }
        }
    }

    private Course findCourse(JSONObject jsonObject, HttpServletResponse response, Map<String, String> errors, EntityManager em) throws IOException {
        long courseId = jsonObject.optLong("id", 0);
        if (courseId == 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            errors.put("id", "ID du cours manquant");
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
            return null;
        }

        Course course = em.find(Course.class, courseId);
        if (course == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            errors.put("global", "Cours non trouvé");
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
            return null;
        }

        return course;
    }

    private boolean validateCourseForm(HttpServletResponse response, Map<String, String> errors, Course course) throws IOException {
        ValidatorFactory factory = Validation.buildDefaultValidatorFactory();
        Validator validator = factory.getValidator();
        Set<ConstraintViolation<Course>> violations = validator.validate(course);

        if (!violations.isEmpty()) {
            for (ConstraintViolation<Course> violation : violations) {
                errors.put(violation.getPropertyPath().toString(), violation.getMessage());
            }
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
            return true;
        }
        return false;
    }

    private void checkInputValue(JSONObject jsonObject, Course course) {
        if (jsonObject.has("level") && !jsonObject.optString("level", "").isEmpty()) {
            course.setLevelId(jsonObject.getLong("level"));
        }
        if (jsonObject.has("subscription") && !jsonObject.optString("subscription", "").isEmpty()) {
            course.setLevelId(jsonObject.getLong("level"));
        }
        if (jsonObject.has("languageId") && !jsonObject.optString("languageId", "").isEmpty()) {
            course.setLanguageId(jsonObject.getLong("languageId"));
        }
        if (jsonObject.has("room") && !jsonObject.optString("room", "").isEmpty()) {
            course.setRoomId(jsonObject.getLong("room"));
        }
        course.setName(jsonObject.getString("name"));
        course.setIdentifier(jsonObject.getString("identifier"));
        course.setDescription(jsonObject.optString("description"));
        course.setSpecificEquipment(jsonObject.optString("specificEquipment"));
        course.setTypeOfCourse(jsonObject.getString("typeOfCourse"));
    }

    private void handleException(Exception e, EntityManager em, HttpServletResponse response, Map<String, String> errors) throws IOException {
        if (em.getTransaction().isActive()) {
            em.getTransaction().rollback();
        }

        Throwable cause = e.getCause();
        while (cause != null && !(cause instanceof SQLIntegrityConstraintViolationException)) {
            cause = cause.getCause();
        }

        if (cause != null) {
            errors.put("name", "Le nom du cours est déjà utilisé");
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
