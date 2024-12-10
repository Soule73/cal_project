package com.cal.controlleurs.rooms;

import com.cal.Routes;
import com.cal.models.Room;
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

@WebServlet({Routes.ROOM_LIST})
public class RoomListServlet extends HttpServlet {

    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = (EntityManagerFactory) getServletContext().getAttribute("EntityManagerFactory");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/rooms/list.jsp")
                .forward(request, response);

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
            String queryStr = "SELECT r FROM Room r";
            if (!searchQuery.isEmpty()) {
                queryStr += " WHERE r.name LIKE :searchQuery";
            }
            queryStr += " ORDER BY r.id";
            TypedQuery<Room> query = em.createQuery(queryStr, Room.class)
                    .setFirstResult((page - 1) * pageSize)
                    .setMaxResults(pageSize);

            if (!searchQuery.isEmpty()) {
                query.setParameter("searchQuery", "%" + searchQuery + "%");
            }

            List<Room> rooms = query.getResultList();

            TypedQuery<Long> countQuery = em.createQuery("SELECT COUNT(r) FROM Room r", Long.class);
            if (!searchQuery.isEmpty()) {
                countQuery = em.createQuery("SELECT COUNT(r) FROM Room r WHERE r.name LIKE :searchQuery", Long.class);
                countQuery.setParameter("searchQuery", "%" + searchQuery + "%");
            }

            long totalRooms = countQuery.getSingleResult();

            JSONObject result = new JSONObject();
            JSONArray roomsJsonArray = new JSONArray();

            for (Room room : rooms) {
                JSONObject roomJson = getJsonObject(room);
                roomsJsonArray.put(roomJson);
            }

            result.put("rooms", roomsJsonArray);
            result.put("totalRooms", totalRooms);
            result.put("page", page);
            result.put("pageSize", pageSize);

            response.getWriter().write(result.toString());
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(new JSONObject().put("error", "Une erreur s'est produite").toString());
        }
    }

    private static JSONObject getJsonObject(Room room) {
        JSONObject roomJson = new JSONObject();
        roomJson.put("id", room.getId());
        roomJson.put("name", room.getName());
        roomJson.put("equipment", room.getEquipment());
        return roomJson;
    }
}

