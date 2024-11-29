package com.cal.models;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "learner_subscription")
@IdClass(LearnerSubscriptionId.class)
public class LearnerSubscription {

    @Id
    @ManyToOne
    @JoinColumn(name = "learner_id", nullable = false)
    private Learner learner;

    @Id
    @ManyToOne
    @JoinColumn(name = "subscription_id", nullable = false)
    private Subscription subscription;

    @Column(name = "start_at", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date startAt;

    @Column(name = "end_at", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date endAt;

    // Getters and Setters

    public Learner getLearner() {
        return learner;
    }

    public void setLearner(Learner learner) {
        this.learner = learner;
    }

    public Subscription getSubscription() {
        return subscription;
    }

    public void setSubscription(Subscription subscription) {
        this.subscription = subscription;
    }

    public Date getStartAt() {
        return startAt;
    }

    public void setStartAt(Date startAt) {
        this.startAt = startAt;
    }

    public Date getEndAt() {
        return endAt;
    }

    public void setEndAt(Date endAt) {
        this.endAt = endAt;
    }
}