package com.cal.controlleurs;

import com.cal.Routes;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.TypedQuery;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;
import java.io.IOException;
import java.sql.Date;
import java.util.List;



@WebServlet(Routes.CURSE_USAGE)
public class CourseUsageServlet extends HttpServlet {

    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = Persistence.createEntityManagerFactory("languageCenterPU");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");

        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");

        EntityManager em = emf.createEntityManager();

        try {
            StringBuilder queryString = new StringBuilder("SELECT s.name, COUNT(ls) FROM LearnerSubscription ls JOIN ls.subscription s WHERE 1=1");
            if (startDateStr != null && !startDateStr.isEmpty()) {
                queryString.append(" AND ls.startAt >= :startDate");
            }
            if (endDateStr != null && !endDateStr.isEmpty()) {
                queryString.append(" AND ls.startAt <= :endDate");
            }
            queryString.append(" GROUP BY s.name ORDER BY COUNT(ls) DESC");

            TypedQuery<Object[]> query = em.createQuery(queryString.toString(), Object[].class);

            if (startDateStr != null && !startDateStr.isEmpty()) {
                Date startDate = Date.valueOf(startDateStr);
                query.setParameter("startDate", startDate);
            }

            if (endDateStr != null && !endDateStr.isEmpty()) {
                Date endDate = Date.valueOf(endDateStr);
                query.setParameter("endDate", endDate);
            }

            List<Object[]> results = query.getResultList();

            JSONArray jsonArray = new JSONArray();
            for (Object[] result : results) {
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("courseName", result[0]);
                jsonObject.put("enrollmentCount", result[1]);
                jsonArray.put(jsonObject);
            }

            response.getWriter().write(jsonArray.toString());
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(new JSONObject().put("error", "Une erreur s'est produite lors de la récupération des données d'utilisation des cours.").toString());
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    @Override
    public void destroy() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}


