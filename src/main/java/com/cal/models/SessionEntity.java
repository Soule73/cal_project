package com.cal.models;

import jakarta.persistence.*;

import java.sql.Timestamp;

@Entity
@Table(name = "sessions")
public class SessionEntity {

    @Id
    private String id;

    @Lob
    @Column(name = "data")
    private byte[] data;

    @Column(name = "last_accessed")
    private Timestamp lastAccessed;

    // Getters and Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public byte[] getData() {
        return data;
    }

    public void setData(byte[] data) {
        this.data = data;
    }

    public Timestamp getLastAccessed() {
        return lastAccessed;
    }

    public void setLastAccessed(Timestamp lastAccessed) {
        this.lastAccessed = lastAccessed;
    }
}