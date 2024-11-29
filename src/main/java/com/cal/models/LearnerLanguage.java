package com.cal.models;

import jakarta.persistence.*;

@Entity
@Table(name = "learner_language")
@IdClass(LearnerLanguageId.class)
public class LearnerLanguage {

    @Id
    @ManyToOne
    @JoinColumn(name = "learner_id", nullable = false)
    private Learner learner;

    @Id
    @ManyToOne
    @JoinColumn(name = "language_id", nullable = false)
    private Language language;

    @Id
    @ManyToOne
    @JoinColumn(name = "level_id", nullable = false)
    private Level level;

    // Getters and Setters

    public Learner getLearner() {
        return learner;
    }

    public void setLearner(Learner learner) {
        this.learner = learner;
    }

    public Language getLanguage() {
        return language;
    }

    public void setLanguage(Language language) {
        this.language = language;
    }

    public Level getLevel() {
        return level;
    }

    public void setLevel(Level level) {
        this.level = level;
    }
}