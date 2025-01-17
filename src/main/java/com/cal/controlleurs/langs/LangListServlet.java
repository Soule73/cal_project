package com.cal.controlleurs.langs;

import com.cal.models.Language;
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

import static com.cal.Routes.LANG_LIST;

@WebServlet({LANG_LIST})
public class LangListServlet extends HttpServlet {

    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = (EntityManagerFactory) getServletContext().getAttribute("EntityManagerFactory");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        request.getRequestDispatcher("WEB-INF/langs/list.jsp")
                .forward(request, response);
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
            String queryStr = "SELECT l FROM Language l";
            if (!searchQuery.isEmpty()) {
                queryStr += " WHERE l.name LIKE :searchQuery";
            }
            queryStr += " ORDER BY l.name";
            TypedQuery<Language> query = em.createQuery(queryStr, Language.class)
                    .setFirstResult((page - 1) * pageSize)
                    .setMaxResults(pageSize);

            if (!searchQuery.isEmpty()) {
                query.setParameter("searchQuery", "%" + searchQuery + "%");
            }

            List<Language> languages = query.getResultList();

            // Compter le nombre total de langues pour la pagination
            TypedQuery<Long> countQuery = em.createQuery("SELECT COUNT(l) FROM Language l", Long.class);
            if (!searchQuery.isEmpty()) {
                countQuery = em.createQuery(
                        "SELECT COUNT(l) FROM Language l WHERE l.name LIKE :searchQuery", Long.class
                );
                countQuery.setParameter("searchQuery", "%" + searchQuery + "%");
            }

            long totalLanguages = countQuery.getSingleResult();

            
            JSONObject result = new JSONObject();
            JSONArray languagesJsonArray = new JSONArray();

            for (Language language : languages) {
                JSONObject languageJson = getJsonObject(language);
                languagesJsonArray.put(languageJson);
            }

            result.put("languages", languagesJsonArray);
            result.put("totalLanguages", totalLanguages);
            result.put("page", page);
            result.put("pageSize", pageSize);

            response.getWriter().write(result.toString());
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(new JSONObject().put("error", "Une erreur s'est produite").toString());
        }
    }

    private static JSONObject getJsonObject(Language language) {
        JSONObject languageJson = new JSONObject();
        languageJson.put("id", language.getId());
        languageJson.put("name", language.getName());
        return languageJson;
    }

}

