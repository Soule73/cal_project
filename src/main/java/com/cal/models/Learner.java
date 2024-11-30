package com.cal.models;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;

import java.util.Date;
import java.util.Set;

@Entity
@Table(name = "learners")
public class Learner {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Le prénom est obligatoire")
    @Size(max = 50, message = "Le prénom doit comporter moins de 50 caractères")
    @Column(name = "firstname", nullable = false, length = 50)
    private String firstname;

    @NotBlank(message = "Le nom de famille est obligatoire")
    @Size(max = 50, message = "Le nom de famille doit comporter moins de 50 caractères")
    @Column(name = "lastname", nullable = false, length = 50)
    private String lastname;

    @NotBlank(message = "L'email est obligatoire")
    @Email(message = "L'email doit être valide")
    @Size(max = 100, message = "L'email doit comporter moins de 100 caractères")
    @Column(name = "email", nullable = false, unique = true, length = 100)
    private String email;

    @NotNull(message = "La date de création est obligatoire")
    @Column(name = "created_at", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date createdAt;

    @ManyToOne
    @JoinColumn(name = "language_id")
    private Language language;

    @ManyToOne
    @JoinColumn(name = "level_id")
    private Level level;

    @OneToMany(mappedBy = "learner", cascade = CascadeType.ALL)
    private Set<LearnerSubscription> learnerSubscriptions;

    // Getters and Setters

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getFirstname() {
        return firstname;
    }

    public String getFullname() {
        return firstname + " " + lastname;
    }

    public void setFirstname(String firstname) {
        this.firstname = firstname;
    }

    public String getLastname() {
        return lastname;
    }

    public void setLastname(String lastname) {
        this.lastname = lastname;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
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

    public Set<LearnerSubscription> getLearnerSubscriptions() {
        return learnerSubscriptions;
    }

    public void setLearnerSubscriptions(Set<LearnerSubscription> learnerSubscriptions) {
        this.learnerSubscriptions = learnerSubscriptions;
    }

}
