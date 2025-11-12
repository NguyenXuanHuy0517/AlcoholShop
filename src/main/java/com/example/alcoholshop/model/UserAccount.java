package com.example.alcoholshop.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * UserAccount model class representing user accounts in the system
 */
public class UserAccount {
    private int id;
    private String username;
    private String fullname;
    private String email;
    private String passwordHash;
    private String role;
    private LocalDate birthDate;
    private String address;
    private LocalDateTime createdAt;
    // active flag (not persisted yet unless DB schema updated)
    private boolean active = true;

    // Constructors
    public UserAccount() {}
    
    public UserAccount(String username, String fullname, String email, String passwordHash, 
                      String role, LocalDate birthDate, String address) {
        this.username = username;
        this.fullname = fullname;
        this.email = email;
        this.passwordHash = passwordHash;
        this.role = role;
        this.birthDate = birthDate;
        this.address = address;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getFullname() {
        return fullname;
    }
    
    public void setFullname(String fullname) {
        this.fullname = fullname;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPasswordHash() {
        return passwordHash;
    }
    
    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }
    
    public String getRole() {
        return role;
    }
    
    public void setRole(String role) {
        this.role = role;
    }
    
    public LocalDate getBirthDate() {
        return birthDate;
    }
    
    public void setBirthDate(LocalDate birthDate) {
        this.birthDate = birthDate;
    }
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isActiveFlag() {
        return active;
    }

    public void setActiveFlag(boolean active) {
        this.active = active;
    }

    /**
     * Check if user is admin
     */
    public boolean isAdmin() {
        return "ADMIN".equals(role);
    }
    
    /**
     * Check if user is customer
     */
    public boolean isCustomer() {
        return "CUSTOMER".equals(role);
    }
    
    /**
     * Check if user is 18 or older
     */
    public boolean isAdult() {
        if (birthDate == null) return false;
        return birthDate.plusYears(18).isBefore(LocalDate.now()) || 
               birthDate.plusYears(18).isEqual(LocalDate.now());
    }

    /**
     * Convenience methods for JSP/EL and server-side filters
     */
    public boolean isActive() {
        return active;
    }

    public boolean getActive() {
        return isActive();
    }

    @Override
    public String toString() {
        return "UserAccount{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", fullname='" + fullname + '\'' +
                ", email='" + email + '\'' +
                ", role='" + role + '\'' +
                ", birthDate=" + birthDate +
                ", createdAt=" + createdAt +
                '}';
    }
}
