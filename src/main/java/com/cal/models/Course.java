package com.cal.models;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;

import java.io.Serializable;

@Entity
@Table(name = "courses")
public class Course implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "language_id", nullable = false)
    @NotNull(message = "La langue ne doit pas être nulle.")
    private Language language;

    @ManyToOne
    @JoinColumn(name = "level_id", nullable = false)
    @NotNull(message = "Le niveau ne doit pas être nul.")
    private Level level;

    @ManyToOne
    @JoinColumn(name = "room_id", nullable = false)
    @NotNull(message = "La salle ne doit pas être nulle.")
    private Room room;

    @ManyToOne
    @JoinColumn(name = "subscription_id", nullable = false)
    @NotNull(message = "L'abonnement ne doit pas être nul.")
    private Subscription subscription;

    @Column(name = "identifier", nullable = false, unique = true, length = 50)
    @NotBlank(message = "L'identifiant ne doit pas être vide.")
    @Size(max = 50, message = "L'identifiant doit contenir au maximum 50 caractères.")
    private String identifier;

    @Column(name = "name", nullable = false, length = 100)
    @NotBlank(message = "Le nom ne doit pas être vide.")
    @Size(max = 100, message = "Le nom doit contenir au maximum 100 caractères.")
    private String name;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "specific_equipment", columnDefinition = "TEXT")
    private String specificEquipment;

    @Column(name = "type_of_course", nullable = false, length = 50)
    @NotBlank(message = "Le type de cours ne doit pas être vide.")
    @Size(max = 50, message = "Le type de cours doit contenir au maximum 50 caractères.")
    private String typeOfCourse;

    // Getters and Setters

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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

    public Room getRoom() {
        return room;
    }

    public void setRoom(Room room) {
        this.room = room;
    }

    public Subscription getSubscription() {
        return subscription;
    }

    public void setSubscription(Subscription subscription) {
        this.subscription = subscription;
    }

    public String getIdentifier() {
        return identifier;
    }

    public void setIdentifier(String identifier) {
        this.identifier = identifier;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getSpecificEquipment() {
        return specificEquipment;
    }

    public void setSpecificEquipment(String specificEquipment) {
        this.specificEquipment = specificEquipment;
    }

    public String getTypeOfCourse() {
        return typeOfCourse;
    }

    public void setTypeOfCourse(String typeOfCourse) {
        this.typeOfCourse = typeOfCourse;
    }

    public void setLanguageId(Long languageId)
    {
        this.language = new Language();
        this.language.setId(languageId);
    }
    public void setRoomId(Long roomId)
    {
        this.room = new Room();
        this.room.setId(roomId);
    }

    public void setLevelId(Long levelId) {
        this.level = new Level();
        this.level.setId(levelId);
    }

    public void setSubscriptionId(Long subscriptionId) {
        this.subscription = new Subscription();
        this.subscription.setId(subscriptionId);
    }

}
