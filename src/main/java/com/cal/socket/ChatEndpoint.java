package com.cal.socket;

import com.cal.Routes;
import com.cal.middlewares.HttpSessionConfigurator;
import com.cal.models.*;
import jakarta.persistence.Persistence;
import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;
import jakarta.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONObject;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.EntityTransaction;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

@ServerEndpoint(value = Routes.CHAT, configurator = HttpSessionConfigurator.class)
public class ChatEndpoint {

    private static final Map<Long, Session> userSessions = new HashMap<>();
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

        userSessions.put(currentUser.getId(), session);
        emf = Persistence.createEntityManagerFactory("languageCenterPU");

        sendPreviousConversationsAndMessages(session, currentUser);
    }

    @OnClose
    public void onClose(Session session) {
        userSessions.values().remove(session);
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
        String messageType = jsonMessage.getString("type");

        if ("startConversation".equals(messageType)) {
            Long otherUserId = jsonMessage.getLong("otherUserId");

            // Créer une nouvelle conversation privée
            Conversation conversation = createConversation(currentUser.getId(), otherUserId);

            // Envoyer la nouvelle conversation aux membres concernés
            sendConversationToMembers(conversation, session);
        } else if ("createGroup".equals(messageType)) {
            String groupName = jsonMessage.getString("groupName");
            JSONArray memberIds = jsonMessage.getJSONArray("memberIds");

            // Créer un nouveau groupe
            Conversation group = createGroup(currentUser, groupName, memberIds);

            // Envoyer la nouvelle conversation aux membres concernés
            sendConversationToMembers(group, session);
        } else if ("sendMessage".equals(messageType)) {
            Long userId = jsonMessage.getLong("userId");
            Long conversationId = jsonMessage.getLong("conversationId");
            String content = jsonMessage.getString("content");

            Message storedMessage = storeMessage(userId, conversationId, content);

            EntityManager em = emf.createEntityManager();
            User user = em.find(User.class, userId);

            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSXXX");

            JSONObject broadcastMessage = new JSONObject();
            broadcastMessage.put("id", storedMessage.getId());
            broadcastMessage.put("userId", userId);
            broadcastMessage.put("firstName", user.getFirstname());
            broadcastMessage.put("lastName", user.getLastname());
            broadcastMessage.put("content", content);
            broadcastMessage.put("created_at", dateFormat.format(storedMessage.getCreatedAt()));
            broadcastMessage.put("conversationId", conversationId);

            // Envoyer le message seulement aux membres de la conversation concernée
            Conversation conversation = em.find(Conversation.class, conversationId);
            sendToMembers(conversation, broadcastMessage, session);
        } else if ("addMember".equals(messageType)) {
            Long conversationId = jsonMessage.getLong("conversationId");
            Long newMemberId = jsonMessage.getLong("newMemberId");

            addMemberToGroup(conversationId, newMemberId);
        } else if ("removeMember".equals(messageType)) {
            Long conversationId = jsonMessage.getLong("conversationId");
            Long memberId = jsonMessage.getLong("memberId");

            removeMemberFromGroup(conversationId, memberId);
        }
    }

    private void addMemberToGroup(Long conversationId, Long newMemberId) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();

        try {
            transaction.begin();
            Conversation conversation = em.find(Conversation.class, conversationId);
            User newMember = em.find(User.class, newMemberId);

            conversation.getMembers().add(newMember);
            em.merge(conversation);
            transaction.commit();
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    private void removeMemberFromGroup(Long conversationId, Long memberId) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();

        try {
            transaction.begin();
            Conversation conversation = em.find(Conversation.class, conversationId);
            User member = em.find(User.class, memberId);

            conversation.getMembers().remove(member);
            em.merge(conversation);
            transaction.commit();

            // Notifier tous les membres de la suppression du membre
            JSONObject notification = new JSONObject();
            notification.put("type", "removeMember");
            notification.put("conversationId", conversationId);
            notification.put("memberId", memberId);

            sendToMembers(conversation, notification, null);

        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    private Conversation createGroup(User creator, String groupName, JSONArray memberIds) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();
        Conversation group = new Conversation();

        try {
            transaction.begin();

            group.setName(groupName);
            group.setGroup(true);
            group.getMembers().add(creator);

            for (int i = 0; i < memberIds.length(); i++) {
                Long memberId = memberIds.getLong(i);
                User member = em.find(User.class, memberId);
                group.getMembers().add(member);
            }

            em.persist(group);
            em.flush();

            // Mettre à jour le créateur comme admin
            ConversationMemberId creatorMemberId = new ConversationMemberId();
            creatorMemberId.setUserId(creator.getId());
            creatorMemberId.setConversationId(group.getId());

            ConversationMember creatorMember = em.find(ConversationMember.class, creatorMemberId);
            if (creatorMember != null) {
                creatorMember.setAdmin(true);
                em.merge(creatorMember);
            }

            transaction.commit();
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            em.close();
        }

        return group;
    }

    private void sendConversationToMembers(Conversation conversation, Session currentSession) throws IOException {
        Set<User> members = conversation.getMembers();
        for (User member : members) {
            Session peer = userSessions.get(member.getId());
            if (peer != null && peer.isOpen()) {
                JSONObject response = new JSONObject();
                response.put("type", "startConversation");
                response.put("conversation", new JSONObject()
                        .put("id", conversation.getId())
                        .put("name", conversation.isGroup() ? conversation.getName() : getPrivateConversationName(conversation, member))  // Correctement définir le nom pour chaque membre
                        .put("isGroup", conversation.isGroup()));

                peer.getBasicRemote().sendText(response.toString());
            }
        }
    }

    private String getPrivateConversationName(Conversation conversation, User currentUser) {
        for (User member : conversation.getMembers()) {
            if (!member.getId().equals(currentUser.getId())) {
                return member.getFullname();
            }
        }
        return "Conversation privée";
    }

    private void sendToMembers(Conversation conversation, JSONObject message, Session currentSession) throws IOException {
        Set<User> members = conversation.getMembers();
        for (User member : members) {
            Session peer = userSessions.get(member.getId());
            if (peer != null && peer.isOpen() && !peer.equals(currentSession)) {
                peer.getBasicRemote().sendText(message.toString());
            }
        }
    }

    private Conversation createConversation(Long currentUserId, Long otherUserId) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();
        Conversation conversation = new Conversation();

        try {
            transaction.begin();

            User currentUser = em.find(User.class, currentUserId);
            User otherUser = em.find(User.class, otherUserId);

            conversation.setGroup(false);
            conversation.getMembers().add(currentUser);
            conversation.getMembers().add(otherUser);

            em.persist(conversation);
            transaction.commit();
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            em.close();
        }

        return conversation;
    }

    private void sendPreviousConversationsAndMessages(Session session, User currentUser) {
        EntityManager em = emf.createEntityManager();
        try {
            List<Conversation> conversations = em.createQuery("SELECT DISTINCT c FROM Conversation c JOIN c.members m WHERE m.id = :userId", Conversation.class)
                    .setParameter("userId", currentUser.getId())
                    .getResultList();
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSXXX");

            for (Conversation conversation : conversations) {
                JSONObject jsonConversation = new JSONObject();
                jsonConversation.put("id", conversation.getId());

                String conversationName = conversation.isGroup() ? conversation.getName() : getPrivateConversationName(conversation, currentUser);
                jsonConversation.put("name", conversationName);
                jsonConversation.put("isGroup", conversation.isGroup());

                JSONArray membersArray = new JSONArray();
                for (User member : conversation.getMembers()) {
                    if (!conversation.isGroup() && member.getId().equals(currentUser.getId())) {
                        continue;  // Skip the current user for private conversations
                    }
                    JSONObject jsonMember = new JSONObject();
                    jsonMember.put("id", member.getId());
                    jsonMember.put("email", member.getEmail());

                    jsonMember.put("fullName", member.getFullname());

                    // Récupérer le statut is_admin pour chaque membre
                    ConversationMemberId memberId = new ConversationMemberId();
                    memberId.setUserId(member.getId());
                    memberId.setConversationId(conversation.getId());
                    ConversationMember conversationMember = em.find(ConversationMember.class, memberId);
                    jsonMember.put("is_admin", conversationMember != null && conversationMember.isAdmin());


                    membersArray.put(jsonMember);
                }
                jsonConversation.put("members", membersArray);

                List<Message> messages = em.createQuery("SELECT m FROM Message m WHERE m.conversation.id = :conversationId ORDER BY m.createdAt", Message.class)
                        .setParameter("conversationId", conversation.getId())
                        .getResultList();

                JSONArray messagesArray = new JSONArray();
                for (Message msg : messages) {
                    JSONObject jsonMessage = new JSONObject();
                    jsonMessage.put("id", msg.getId());
                    jsonMessage.put("userId", msg.getUser().getId());
                    jsonMessage.put("firstName", msg.getUser().getFirstname());
                    jsonMessage.put("lastName", msg.getUser().getLastname());
                    jsonMessage.put("content", msg.getContent());
                    jsonMessage.put("created_at", dateFormat.format(msg.getCreatedAt()));
                    jsonMessage.put("conversationId", conversation.getId());
                    messagesArray.put(jsonMessage);
                }
                jsonConversation.put("messages", messagesArray);

                session.getBasicRemote().sendText(jsonConversation.toString());
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    private Message storeMessage(Long userId, Long conversationId, String content) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();
        Message msg = new Message();

        try {
            transaction.begin();
            msg.setContent(content);
            msg.setCreatedAt(new Date());
            User user = em.find(User.class, userId);
            Conversation conversation = em.find(Conversation.class, conversationId);
            msg.setUser(user);
            msg.setConversation(conversation);
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

