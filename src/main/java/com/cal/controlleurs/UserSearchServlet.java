package com.cal.controlleurs;

import com.cal.Routes;
import com.cal.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.TypedQuery;
import jakarta.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONObject;
import java.io.IOException;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@WebServlet(Routes.PRIVATE_USER_SEARCH)
public class UserSearchServlet extends HttpServlet {

    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = Persistence.createEntityManagerFactory("languageCenterPU");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");

        HttpSession httpSession = request.getSession();
        User currentUser = (User) httpSession.getAttribute("user");
        String searchTerm = request.getParameter("searchTerm");

        EntityManager em = emf.createEntityManager();

        try {
            // Requête pour récupérer les utilisateurs avec lesquels l'utilisateur actuel a déjà des conversations
            List<User> contactedUsers = em.createQuery(
                            "SELECT DISTINCT u FROM Conversation c JOIN c.members u WHERE c.isGroup = false AND :currentUser MEMBER OF c.members", User.class)
                    .setParameter("currentUser", currentUser)
                    .getResultList();

            Set<Long> contactedUserIds = contactedUsers.stream()
                    .map(User::getId)
                    .collect(Collectors.toSet());

            List<User> users;
            if (contactedUserIds.isEmpty()) {
                // Requête pour chercher les utilisateurs par nom, prénom ou email, sans exclure ceux déjà contactés
                TypedQuery<User> query = em.createQuery(
                        "SELECT u FROM User u WHERE u.firstname LIKE :searchTerm OR u.lastname LIKE :searchTerm OR u.email LIKE :searchTerm",
                        User.class
                );
                query.setParameter("searchTerm", "%" + searchTerm + "%");
                users = query.getResultList();
            } else {
                // Requête pour chercher les utilisateurs par nom, prénom ou email, excluant ceux déjà contactés
                TypedQuery<User> query = em.createQuery(
                        "SELECT u FROM User u WHERE (u.firstname LIKE :searchTerm OR u.lastname LIKE :searchTerm OR u.email LIKE :searchTerm) AND u.id NOT IN :contactedUserIds",
                        User.class
                );
                query.setParameter("searchTerm", "%" + searchTerm + "%");
                query.setParameter("contactedUserIds", contactedUserIds);
                users = query.getResultList();
            }

            JSONArray jsonArray = new JSONArray();
            for (User user : users) {
                if (!user.getId().equals(currentUser.getId())) {  // Exclure l'utilisateur actuel des résultats
                    JSONObject jsonUser = new JSONObject();
                    jsonUser.put("id", user.getId());
                    jsonUser.put("name", user.getFullname());
                    jsonUser.put("email", user.getEmail());
                    jsonArray.put(jsonUser);
                }
            }

            response.getWriter().write(jsonArray.toString());
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(new JSONObject().put("error", "Une erreur s'est produite lors de la recherche des utilisateurs.").toString());
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
