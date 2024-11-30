package com.cal.controlleurs.courses;

import com.cal.models.Course;
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

import static com.cal.Routes.LANG_COURSE;

@WebServlet(name = "CourseServlet", urlPatterns = {LANG_COURSE})
public class CourseServlet extends HttpServlet {

    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = (EntityManagerFactory) getServletContext().getAttribute("EntityManagerFactory");
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
        Long languageId = jsonObject.optLong("languageId", 0);
        String searchQuery = jsonObject.optString("searchQuery", "");

        if (languageId == 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(new JSONObject().put("error", "Invalid language ID").toString());
            return;
        }

        try (EntityManager em = emf.createEntityManager()) {
            String queryStr = "SELECT c FROM Course c WHERE c.language.id = :languageId";
            if (!searchQuery.isEmpty()) {
                queryStr += " AND (c.name LIKE :searchQuery OR c.identifier LIKE :searchQuery)";
            }
            queryStr += " ORDER BY c.identifier";

            TypedQuery<Course> query = em.createQuery(queryStr, Course.class)
                    .setParameter("languageId", languageId)
                    .setFirstResult((page - 1) * pageSize)
                    .setMaxResults(pageSize);

            if (!searchQuery.isEmpty()) {
                query.setParameter("searchQuery", "%" + searchQuery + "%");
            }

            List<Course> courses = query.getResultList();

            // Compter le nombre total de cours pour la pagination
            TypedQuery<Long> countQuery = em.createQuery(
                    "SELECT COUNT(c) FROM Course c WHERE c.language.id = :languageId", Long.class
            ).setParameter("languageId", languageId);

            long totalCourses = countQuery.getSingleResult();

            
            JSONObject result = new JSONObject();
            JSONArray coursesJsonArray = new JSONArray();

            for (Course course : courses) {
                JSONObject courseJson = getJsonObject(course);
                coursesJsonArray.put(courseJson);
            }

            result.put("courses", coursesJsonArray);
            result.put("totalCourses", totalCourses);
            result.put("page", page);
            result.put("pageSize", pageSize);

            response.getWriter().write(result.toString());
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(new JSONObject().put("error", "Une erreur se produit").toString());
        }
    }

    private static JSONObject getJsonObject(Course course) {
        JSONObject courseJson = new JSONObject();
        courseJson.put("id", course.getId());
        courseJson.put("languageId", course.getLanguage().getId());
        courseJson.put("identifier", course.getIdentifier());
        courseJson.put("name", course.getName());
        courseJson.put("level", course.getLevel().getName());
        courseJson.put("levelId", course.getLevel().getId());
        courseJson.put("roomId", course.getRoom().getId());
        courseJson.put("subscriptionId", course.getSubscription().getId());
        courseJson.put("description", course.getDescription());
        courseJson.put("typeOfCourse", course.getTypeOfCourse());
        courseJson.put("specificEquipment", course.getSpecificEquipment());
        return courseJson;
    }

}

