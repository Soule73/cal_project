package com.cal.controlleurs;

import com.cal.Routes;
import com.cal.models.Role;
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

@WebServlet(Routes.ROLE_LIST)
public class RoleListServlet extends HttpServlet {

    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = (EntityManagerFactory) getServletContext().getAttribute("EntityManagerFactory");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        request.getRequestDispatcher("WEB-INF/role.jsp").forward(request, response);
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
        String searchQuery = jsonObject.optString("searchQuery", "");

        try (EntityManager em = emf.createEntityManager()) {
            String queryStr = "SELECT r FROM Role r";
            if (!searchQuery.isEmpty()) {
                queryStr += " WHERE r.name LIKE :searchQuery";
            }
            queryStr += " ORDER BY r.id";
            TypedQuery<Role> query = em.createQuery(queryStr, Role.class)
                    .setFirstResult((page - 1) * pageSize)
                    .setMaxResults(pageSize);

            if (!searchQuery.isEmpty()) {
                query.setParameter("searchQuery", "%" + searchQuery + "%");
            }

            List<Role> roles = query.getResultList();

            TypedQuery<Long> countQuery = em.createQuery("SELECT COUNT(r) FROM Role r", Long.class);
            if (!searchQuery.isEmpty()) {
                countQuery = em.createQuery("SELECT COUNT(r) FROM Role r WHERE r.name LIKE :searchQuery", Long.class);
                countQuery.setParameter("searchQuery", "%" + searchQuery + "%");
            }

            long totalRoles = countQuery.getSingleResult();

            JSONObject result = new JSONObject();
            JSONArray rolesJsonArray = new JSONArray();

            for (Role rol : roles) {
                JSONObject roleJson = getJsonObject(rol);
                rolesJsonArray.put(roleJson);
            }

            result.put("roles", rolesJsonArray);
            result.put("totalRoles", totalRoles);
            result.put("page", page);
            result.put("pageSize", pageSize);

            response.getWriter().write(result.toString());
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(new JSONObject().put("error", "Une erreur s'est produite").toString());
        }
    }

    private static JSONObject getJsonObject(Role role) {
        JSONObject roleJson = new JSONObject();
        roleJson.put("id", role.getId());
        roleJson.put("name", role.getName());
        return roleJson;
    }
}
