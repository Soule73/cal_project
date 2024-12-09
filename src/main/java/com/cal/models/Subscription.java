package com.cal.models;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;

import java.io.Serializable;
import java.util.Set;

@Entity
@Table(name = "subscriptions")
public class Subscription implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Le nom de l'abonnement est obligatoire")
    @Size(max = 100, message = "Le nom de l'abonnement doit comporter moins de 100 caractères")
    @Column(name = "name", nullable = false, unique = true, length = 100)
    private String name;

    @NotNull(message = "Le prix est obligatoire")
    @DecimalMin(value = "0.0", inclusive = false, message = "Le prix doit être supérieur à 0")
    @Column(name = "price", nullable = false)
    private Double price;

    @Size(max = 255, message = "La description doit comporter moins de 255 caractères")
    @Column(name = "description", length = 255)
    private String description;

    @Size(max = 255, message = "Les conditions d'accès doivent comporter moins de 255 caractères")
    @Column(name = "access_conditions", columnDefinition = "TEXT")
    private String accessConditions;

    @NotBlank(message = "Le type est obligatoire")
    @Size(max = 50, message = "Le type doit comporter moins de 50 caractères")
    @Column(name = "type", nullable = false, length = 50)
    private String type;

    @NotBlank(message = "Le statut est obligatoire")
    @Size(max = 50, message = "Le statut doit comporter moins de 50 caractères")
    @Column(name = "status", nullable = false, length = 50)
    private String status;

    @OneToMany(mappedBy = "subscription", cascade = CascadeType.ALL)
    private Set<LearnerSubscription> learnerSubscriptions;

    @OneToMany(mappedBy = "subscription", cascade = CascadeType.ALL)
    private Set<Course> courses;

    // Getters and Setters

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getAccessConditions() {
        return accessConditions;
    }

    public void setAccessConditions(String accessConditions) {
        this.accessConditions = accessConditions;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Set<LearnerSubscription> getLearnerSubscriptions() {
        return learnerSubscriptions;
    }

    public void setLearnerSubscriptions(Set<LearnerSubscription> learnerSubscriptions) {
        this.learnerSubscriptions = learnerSubscriptions;
    }

    // Getters and Setters pour courses
    public Set<Course> getCourses() {
        return courses;
    }

    public void setCourses(Set<Course> courses) {
        this.courses = courses;
    }

}