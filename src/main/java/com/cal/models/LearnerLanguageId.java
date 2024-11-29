package com.cal.models;

import java.io.Serializable;
import java.util.Objects;

public class LearnerLanguageId implements Serializable {

    private Long learner;
    private Long language;
    private Long level;

    // Default constructor
    public LearnerLanguageId() {}

    // Parameterized constructor
    public LearnerLanguageId(Long learner, Long language, Long level) {
        this.learner = learner;
        this.language = language;
        this.level = level;
    }

    // Getters, Setters, equals, and hashCode

    public Long getLearner() {
        return learner;
    }

    public void setLearner(Long learner) {
        this.learner = learner;
    }

    public Long getLanguage() {
        return language;
    }

    public void setLanguage(Long language) {
        this.language = language;
    }

    public Long getLevel() {
        return level;
    }

    public void setLevel(Long level) {
        this.level = level;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        LearnerLanguageId that = (LearnerLanguageId) o;
        return Objects.equals(learner, that.learner) &&
                Objects.equals(language, that.language) &&
                Objects.equals(level, that.level);
    }

    @Override
    public int hashCode() {
        return Objects.hash(learner, language, level);
    }
}
