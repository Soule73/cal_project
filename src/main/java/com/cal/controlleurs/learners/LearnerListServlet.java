package com.cal.controlleurs.learners;


import com.cal.models.Language;
import com.cal.models.User;
import com.cal.models.Level;
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

import static com.cal.Routes.LEARNER_LIST;

@WebServlet({LEARNER_LIST})
public class LearnerListServlet extends HttpServlet {

    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = (EntityManagerFactory) getServletContext().getAttribute("EntityManagerFactory");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();

        List<Language> languages;
        List<Level> levels;
        languages = em.createQuery("SELECT l FROM Language l", Language.class).getResultList();
        levels = em.createQuery("SELECT l FROM Level l", Level.class).getResultList();
        request.setAttribute("languages", languages);
        request.setAttribute("levels", levels);
        request.getRequestDispatcher("WEB-INF/learner/list.jsp").forward(request, response);
        em.close();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
            String queryStr = "SELECT u FROM User u JOIN u.roles r WHERE r.name = 'LEARNER'";
            if (!searchQuery.isEmpty()) {
                queryStr += " AND (u.firstname LIKE :searchQuery OR u.lastname LIKE :searchQuery OR u.email LIKE :searchQuery)";
            }
            queryStr += " ORDER BY u.id";
            TypedQuery<User> query = em.createQuery(queryStr, User.class)
                    .setFirstResult((page - 1) * pageSize)
                    .setMaxResults(pageSize);

            if (!searchQuery.isEmpty()) {
                query.setParameter("searchQuery", "%" + searchQuery + "%");
            }

            List<User> learners = query.getResultList();

            // Compter le nombre total d'apprenants pour la pagination
            TypedQuery<Long> countQuery = em.createQuery("SELECT COUNT(u) FROM User u JOIN u.roles r WHERE r.name = 'LEARNER'", Long.class);
            if (!searchQuery.isEmpty()) {
                countQuery = em.createQuery(
                        "SELECT COUNT(u) FROM User u JOIN u.roles r WHERE r.name = 'LEARNER' AND (u.firstname LIKE :searchQuery OR u.lastname LIKE :searchQuery OR u.email LIKE :searchQuery)", Long.class
                );
                countQuery.setParameter("searchQuery", "%" + searchQuery + "%");
            }

            long totalLearners = countQuery.getSingleResult();

            JSONObject result = new JSONObject();
            JSONArray learnersJsonArray = new JSONArray();

            for (User learner : learners) {
                JSONObject learnerJson = getJsonObject(learner);
                learnersJsonArray.put(learnerJson);
            }

            result.put("learners", learnersJsonArray);
            result.put("totalLearners", totalLearners);
            result.put("page", page);
            result.put("pageSize", pageSize);

            response.getWriter().write(result.toString());
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(new JSONObject().put("error", "Une erreur s'est produite").toString());
        }
    }

    private static JSONObject getJsonObject(User learner) {
        JSONObject learnerJson = new JSONObject();
        learnerJson.put("id", learner.getId());
        learnerJson.put("firstname", learner.getFirstname());
        learnerJson.put("lastname", learner.getLastname());
        learnerJson.put("email", learner.getEmail());

        if (learner.getLanguage() != null) {
            learnerJson.put("languageId", learner.getLanguage().getId());
            learnerJson.put("languageName", learner.getLanguage().getName());
        } else {
            learnerJson.put("languageId", JSONObject.NULL);
            learnerJson.put("languageName", JSONObject.NULL);
        }

        if (learner.getLevel() != null) {
            learnerJson.put("levelId", learner.getLevel().getId());
            learnerJson.put("levelName", learner.getLevel().getName());
        } else {
            learnerJson.put("levelId", JSONObject.NULL);
            learnerJson.put("levelName", JSONObject.NULL);
        }

        return learnerJson;
    }
}
