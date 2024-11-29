package com.cal.controlleurs.courses;

import com.cal.Routes;
import com.cal.models.Course;
import com.cal.models.Room;
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

import java.io.BufferedReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

@WebServlet(urlPatterns = Routes.COURSE_FORM)
public class CourseFormServlet extends HttpServlet {

    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = (EntityManagerFactory) getServletContext().getAttribute("EntityManagerFactory");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        Map<String, String> errors = new HashMap<>();

        // Lire le contenu JSON du corps de la requête
        StringBuilder sb = new StringBuilder();
        String line;
        try (BufferedReader reader = request.getReader()) {
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }

        String jsonString = sb.toString();
        // Analyser le JSON reçu
        JSONObject jsonObject;
        try {
            jsonObject = new JSONObject(jsonString);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            errors.put("global", "Données JSON invalides");
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
            return;
        }

        // Créer et définir les attributs de l'objet Course
        Course course = new Course();
        try {
            course.setLanguageId(jsonObject.getLong("languageId"));
            course.setLevelId(jsonObject.getLong("level"));
            course.setRoom(new Room());
            course.getRoom().setId(jsonObject.getLong("room"));
            course.setSubscriptionId(jsonObject.getLong("subscription"));
            course.setName(jsonObject.getString("name"));
            course.setIdentifier(jsonObject.getString("identifier"));
            course.setDescription(jsonObject.optString("description"));
            course.setSpecificEquipment(jsonObject.optString("specificEquipment"));
            course.setTypeOfCourse(jsonObject.getString("typeOfCourse"));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            errors.put("global", "Données JSON invalides");
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
            return;
        }

        // Validation des données
        ValidatorFactory factory = Validation.buildDefaultValidatorFactory();
        Validator validator = factory.getValidator();
        Set<ConstraintViolation<Course>> violations = validator.validate(course);

        if (!violations.isEmpty()) {
            for (ConstraintViolation<Course> violation : violations) {
                errors.put(violation.getPropertyPath().toString(), violation.getMessage());
            }
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
            return;
        }

        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();

        try {
            transaction.begin();
            em.persist(course);
            transaction.commit();

            // Forcer l'actualisation de l'entité
            em.refresh(course);

            // Renvoyer une réponse JSON indiquant que le cours a été ajouté avec succès
            response.setStatus(HttpServletResponse.SC_CREATED);
            response.getWriter().write(new JSONObject(Map.of("message", "Le cours a été ajouté avec succès!", "courseId", course.getId())).toString());
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            errors.put("global", "Une erreur s'est produite lors de l'ajout du cours.");
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }


    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        Map<String, String> errors = new HashMap<>();

        // Lire le contenu JSON du corps de la requête
        StringBuilder sb = new StringBuilder();
        String line;
        try (BufferedReader reader = request.getReader()) {
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }

        String jsonString = sb.toString();
        // Analyser le JSON reçu
        JSONObject jsonObject;
        try {
            jsonObject = new JSONObject(jsonString);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            errors.put("global", "Données JSON invalides");
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
            return;
        }

        Long courseId = jsonObject.optLong("id", 0);
        if (courseId == 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            errors.put("global", "ID du cours manquant");
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
            return;
        }

        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();

        try {
            transaction.begin();
            Course course = em.find(Course.class, courseId);
            if (course == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                errors.put("global", "Cours non trouvé");
                response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
                return;
            }

            // Mettre à jour les attributs de l'objet Course
            try {
                course.setLevelId(jsonObject.getLong("level"));
                course.setRoom(new Room());
                course.getRoom().setId(jsonObject.getLong("room"));
                course.setSubscriptionId(jsonObject.getLong("subscription"));
                course.setName(jsonObject.getString("name"));
                course.setIdentifier(jsonObject.getString("identifier"));
                course.setDescription(jsonObject.optString("description"));
                course.setSpecificEquipment(jsonObject.optString("specificEquipment"));
                course.setTypeOfCourse(jsonObject.getString("typeOfCourse"));
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                errors.put("global", "Données JSON invalides");
                response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
                return;
            }

            // Validation des données
            ValidatorFactory factory = Validation.buildDefaultValidatorFactory();
            Validator validator = factory.getValidator();
            Set<ConstraintViolation<Course>> violations = validator.validate(course);

            if (!violations.isEmpty()) {
                for (ConstraintViolation<Course> violation : violations) {
                    errors.put(violation.getPropertyPath().toString(), violation.getMessage());
                }
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
                return;
            }

            em.merge(course);
            transaction.commit();

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(new JSONObject(Map.of("message", "Le cours a été mis à jour avec succès!")).toString());
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            errors.put("global", "Une erreur s'est produite lors de la mise à jour du cours.");
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

}
