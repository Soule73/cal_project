package com.cal.models;

import java.io.Serializable;
import java.util.Objects;

public class ConversationMemberId implements Serializable {
    private Long userId;
    private Long conversationId;

    // Getters, setters, equals, and hashCode methods

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getConversationId() {
        return conversationId;
    }

    public void setConversationId(Long conversationId) {
        this.conversationId = conversationId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ConversationMemberId that = (ConversationMemberId) o;
        return Objects.equals(userId, that.userId) && Objects.equals(conversationId, that.conversationId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(userId, conversationId);
    }
}
