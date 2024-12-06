package com.cal.models;

import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

import java.io.Serializable;

@Entity
@Table(name = "users")
public class User implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Le nom ne doit pas être vide.")
    @Size(max = 100, message = "Le nom doit contenir au maximum 100 caractères.")
    private String name;

    @NotBlank(message = "L'email ne doit pas être vide.")
    @Email(message = "L'email doit être valide.")
    private String email;

    @NotBlank(message = "Le mot de passe ne doit pas être vide.")
    @Size(min = 8, message = "Le mot de passe doit contenir au moins 8 caractères.")
    private String password;

    // Getters and Setters


    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}