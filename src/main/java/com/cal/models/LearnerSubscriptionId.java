package com.cal.models;

import java.io.Serializable;
import java.util.Objects;

public class LearnerSubscriptionId implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long learner;
    private Long subscription;

    public LearnerSubscriptionId() {}

    public LearnerSubscriptionId(Long learner, Long subscription) {
        this.learner = learner;
        this.subscription = subscription;
    }

    public Long getLearner() {
        return learner;
    }

    public void setLearner(Long learner) {
        this.learner = learner;
    }

    public Long getSubscription() {
        return subscription;
    }

    public void setSubscription(Long subscription) {
        this.subscription = subscription;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        LearnerSubscriptionId that = (LearnerSubscriptionId) o;
        return Objects.equals(learner, that.learner) &&
                Objects.equals(subscription, that.subscription);
    }

    @Override
    public int hashCode() {
        return Objects.hash(learner, subscription);
    }
}