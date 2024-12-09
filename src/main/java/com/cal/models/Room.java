package com.cal.models;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;

import java.io.Serializable;

@Entity
@Table(name = "rooms")
public class Room implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Le nom de la salle est obligatoire")
    @Size(max = 50, message = "Le nom de la salle doit comporter moins de 50 caractères")
    @Column(name = "name", nullable = false, unique = true, length = 50)
    private String name;

    @Size(max = 255, message = "L'équipement doit comporter moins de 255 caractères")
    @Column(name = "equipment", columnDefinition = "TEXT")
    private String equipment;

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

    public String getEquipment() {
        return equipment;
    }

    public void setEquipment(String equipment) {
        this.equipment = equipment;
    }
}