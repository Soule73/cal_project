package com.cal.socket;

import com.cal.Routes;
import com.cal.middlewares.HttpSessionConfigurator;
import com.cal.models.Message;
import com.cal.models.User;
import jakarta.persistence.Persistence;
import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;
import jakarta.servlet.http.HttpSession;
import org.json.JSONObject;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.EntityTransaction;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@ServerEndpoint(value = Routes.CHAT, configurator = HttpSessionConfigurator.class)
public class ChatEndpoint {

    private static final Set<Session> peers = Collections.synchronizedSet(new HashSet<>());
    private static EntityManagerFactory emf;

    @OnOpen
    public void onOpen(Session session, EndpointConfig config) {
        HttpSession httpSession = (HttpSession) config.getUserProperties().get(HttpSession.class.getName());
        User currentUser = (User) httpSession.getAttribute("user");

        if (currentUser == null) {
            try {
                session.close(new CloseReason(CloseReason.CloseCodes.VIOLATED_POLICY, "Utilisateur non authentifié"));
            } catch (IOException e) {
                e.printStackTrace();
            }
            return;
        }

        peers.add(session);
        emf = Persistence.createEntityManagerFactory("languageCenterPU");

        sendPreviousMessages(session);
    }

    @OnClose
    public void onClose(Session session) {
        peers.remove(session);
    }

    @OnMessage
    public void onMessage(String message, Session session) throws IOException {
        HttpSession httpSession = (HttpSession) session.getUserProperties().get(HttpSession.class.getName());
        User currentUser = (User) httpSession.getAttribute("user");

        if (currentUser == null) {
            session.close(new CloseReason(CloseReason.CloseCodes.VIOLATED_POLICY, "Utilisateur non authentifié"));
            return;
        }

        JSONObject jsonMessage = new JSONObject(message);
        Long learnerId = jsonMessage.getLong("learnerId");
        String content = jsonMessage.getString("content");

        Message storedMessage = storeMessage(learnerId, content);

        EntityManager em = emf.createEntityManager();
        User learner = em.find(User.class, learnerId);

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSXXX");

        JSONObject broadcastMessage = new JSONObject();
        broadcastMessage.put("id", storedMessage.getId());
        broadcastMessage.put("learnerId", learnerId);
        broadcastMessage.put("firstName", learner.getFirstname());
        broadcastMessage.put("lastName", learner.getLastname());
        broadcastMessage.put("content", content);
        broadcastMessage.put("created_at", dateFormat.format(storedMessage.getCreatedAt()));

        // Envoi du message à tous les clients connectés sauf l'expéditeur
        for (Session peer : peers) {
            if (!peer.equals(session)) {
                peer.getBasicRemote().sendText(broadcastMessage.toString());
            }
        }
    }

    private void sendPreviousMessages(Session session) {
        EntityManager em = emf.createEntityManager();
        try {
            List<Message> messages = em.createQuery("SELECT m FROM Message m ORDER BY m.createdAt", Message.class).getResultList();
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSXXX");
            for (Message msg : messages) {
                JSONObject json = new JSONObject();
                json.put("id", msg.getId());
                json.put("learnerId", msg.getLearner().getId());
                json.put("firstName", msg.getLearner().getFirstname());
                json.put("lastName", msg.getLearner().getLastname());
                json.put("content", msg.getContent());
                json.put("created_at", dateFormat.format(msg.getCreatedAt()));
                session.getBasicRemote().sendText(json.toString());
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    private Message storeMessage(Long learnerId, String content) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();
        Message msg = new Message();

        try {
            transaction.begin();
            msg.setContent(content);
            msg.setCreatedAt(new Date());
            User learner = em.find(User.class, learnerId);
            msg.setLearner(learner);
            em.persist(msg);
            transaction.commit();
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            em.close();
        }

        return msg;
    }
}

