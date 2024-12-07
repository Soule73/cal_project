package com.cal.controlleurs.rooms;

import com.cal.Routes;
import com.cal.models.Room;
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
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

@WebServlet({Routes.ROOM_FORM})
public class RoomFormServlet extends HttpServlet {

    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = (EntityManagerFactory) getServletContext().getAttribute("EntityManagerFactory");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");

        JSONObject jsonObject = JsonData.parseRequestBody(request, response);
        if (jsonObject == null) return;

        Map<String, String> errors = new HashMap<>();
        Room room = new Room();

        try {
            setRoomFileds(jsonObject, room);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            errors.put("global", "Données JSON invalides");
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
            return;
        }

        if (validateRoomForm(response, errors, room)) return;

        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();

        try {
            transaction.begin();
            em.persist(room);
            transaction.commit();

            em.refresh(room);

            response.setStatus(HttpServletResponse.SC_CREATED);
            response.getWriter().write(new JSONObject(Map.of("message", "La salle a été ajouté avec succès!", "roomId", room.getId())).toString());

        } catch (Exception e) {

            if (transaction.isActive()) {
                transaction.rollback();
            }

            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            errors.put("global", "Une erreur s'est produite lors de l'ajout du cours.");
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());

        } finally {
            if (em.isOpen()) {
                em.close();
            }
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");

        JSONObject jsonObject = JsonData.parseRequestBody(request, response);
        if (jsonObject == null) return;

        Map<String, String> errors = new HashMap<>();

        long roomId = jsonObject.optLong("id", 0);
        if (roomId == 0) {

            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            errors.put("id", "ID du salle manquant");
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
            return;
        }

        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();

        try {
            transaction.begin();
            Room room = em.find(Room.class, roomId);

            if (room == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                errors.put("global", "Salle non trouvé");
                response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
                return;
            }

            setRoomFileds(jsonObject, room);

            if (validateRoomForm(response, errors, room)) return;

            em.merge(room);
            transaction.commit();

            em.refresh(room);

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(new JSONObject(Map.of("message", "La salle a été mis à jour avec succès!")).toString());

        } catch (Exception e) {

            if (transaction.isActive()) {
                transaction.rollback();
            }

            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            errors.put("global", "Une erreur s'est produite lors de la mise à jour du cours.");
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());

        } finally {
            if (em.isOpen()) {
                em.close();
            }
        }
    }

    private boolean validateRoomForm(HttpServletResponse response, Map<String, String> errors, Room room) throws IOException {
        ValidatorFactory factory = Validation.buildDefaultValidatorFactory();
        Validator validator = factory.getValidator();
        Set<ConstraintViolation<Room>> violations = validator.validate(room);

        if (!violations.isEmpty()) {
            for (ConstraintViolation<Room> violation : violations) {
                errors.put(violation.getPropertyPath().toString(), violation.getMessage());
            }
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
            return true;
        }
        return false;
    }

    private void setRoomFileds(JSONObject jsonObject, Room room) {
        room.setName(jsonObject.getString("name"));
        room.setEquipment(jsonObject.getString("equipment"));
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");

        JSONObject jsonObject = JsonData.parseRequestBody(request, response);
        if (jsonObject == null) return;

        Map<String, String> errors = new HashMap<>();


        long roomId = jsonObject.optLong("id", 0);
        if (roomId == 0) {

            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            errors.put("id", "ID de la salle manquant");
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
            return;
        }

        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();

        try {
            transaction.begin();
            Room room = em.find(Room.class, roomId);
            if (room == null) {

                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                errors.put("global", "Salle non trouvé");
                response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
                return;
            }

            em.remove(room);
            transaction.commit();

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(new JSONObject(Map.of("message", "La salle a été supprimé avec succès!")).toString());

        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }

            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            errors.put("global", "Une erreur s'est produite lors de la suppression du cours.");
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());

        } finally {
            if (em.isOpen()) {
                em.close();
            }
        }
    }
}
