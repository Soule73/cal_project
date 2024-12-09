package com.cal.models;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;

import java.io.Serializable;

@Entity
@Table(name = "levels")
public class Level implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Le nom du niveau est obligatoire")
    @Size(max = 10, message = "Le nom du niveau doit comporter moins de 10 caractères")
    @Column(name = "name", nullable = false, unique = true, length = 10)
    private String name;

    @NotBlank(message = "Le statut est obligatoire")
    @Size(max = 50, message = "Le statut doit comporter moins de 50 caractères")
    @Column(name = "status", nullable = false, length = 50)
    private String status;

    @Size(max = 255, message = "La description doit comporter moins de 255 caractères")
    @Column(name = "description", length = 255)
    private String description;

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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}