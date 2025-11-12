package com.example.alcoholshop.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Product model class representing products in the shop
 */
public class Product {
    private int id;
    private String code;
    private String name;
    private String description;
    private BigDecimal price;
    private int stock;
    private String image;
    private int categoryId;
    private String categoryName;
    private BigDecimal alcoholPercentage;
    private LocalDateTime createdAt;
    
    // Constructors
    public Product() {}
    
    public Product(String code, String name, String description, BigDecimal price, 
                  int stock, String image, int categoryId, BigDecimal alcoholPercentage) {
        this.code = code;
        this.name = name;
        this.description = description;
        this.price = price;
        this.stock = stock;
        this.image = image;
        this.categoryId = categoryId;
        this.alcoholPercentage = alcoholPercentage;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getCode() {
        return code;
    }
    
    public void setCode(String code) {
        this.code = code;
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
    
    public BigDecimal getPrice() {
        return price;
    }
    
    public void setPrice(BigDecimal price) {
        this.price = price;
    }
    
    public int getStock() {
        return stock;
    }
    
    public void setStock(int stock) {
        this.stock = stock;
    }
    
    public String getImage() {
        return image;
    }
    
    public void setImage(String image) {
        this.image = image;
    }
    
    public int getCategoryId() {
        return categoryId;
    }
    
    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }
    
    public String getCategoryName() {
        return categoryName;
    }
    
    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }
    
    public BigDecimal getAlcoholPercentage() {
        return alcoholPercentage;
    }
    
    public void setAlcoholPercentage(BigDecimal alcoholPercentage) {
        this.alcoholPercentage = alcoholPercentage;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    /**
     * Check if product is in stock
     */
    public boolean isInStock() {
        return stock > 0;
    }
    
    /**
     * Check if product has sufficient stock for given quantity
     */
    public boolean hasStock(int quantity) {
        return stock >= quantity;
    }
    
    /**
     * Convenience accessor so JSP/EL can use `${product.active}`
     */
    public boolean isActive() {
        return isInStock();
    }

    // also provide getActive for frameworks that expect getX naming
    public boolean getActive() {
        return isActive();
    }

    /**
     * Get formatted price string
     */
    public String getFormattedPrice() {
        return String.format("$%.2f", price);
    }
    
    /**
     * Get formatted alcohol percentage
     */
    public String getFormattedAlcoholPercentage() {
        return String.format("%.1f%%", alcoholPercentage);
    }
    
    @Override
    public String toString() {
        return "Product{" +
                "id=" + id +
                ", code='" + code + '\'' +
                ", name='" + name + '\'' +
                ", price=" + price +
                ", stock=" + stock +
                ", alcoholPercentage=" + alcoholPercentage +
                '}';
    }
}
