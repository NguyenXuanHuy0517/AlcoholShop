package com.example.alcoholshop.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;
import com.example.alcoholshop.model.OrderItem;

/**
 * Order model class representing customer orders
 */
public class Order {
    private int id;
    private int userId;
    private String userFullname;
    private String userEmail;
    private BigDecimal total;
    private String status;
    private LocalDateTime createdAt;
    private List<OrderItem> orderItems;

    // Constructors
    public Order() {}
    
    public Order(int userId, BigDecimal total, String status) {
        this.userId = userId;
        this.total = total;
        this.status = status;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getUserFullname() {
        return userFullname;
    }
    
    public void setUserFullname(String userFullname) {
        this.userFullname = userFullname;
    }
    
    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public BigDecimal getTotal() {
        return total;
    }
    
    public void setTotal(BigDecimal total) {
        this.total = total;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public List<OrderItem> getOrderItems() {
        return orderItems;
    }
    
    public void setOrderItems(List<OrderItem> orderItems) {
        this.orderItems = orderItems;
    }
    
    /**
     * Get formatted total price (null-safe)
     */
    public String getFormattedTotal() {
        BigDecimal amount = (this.total != null) ? this.total : getTotalAmount();
        if (amount == null) {
            return "$0.00";
        }
        return String.format("$%.2f", amount.doubleValue());
    }

    /**
     * Provide a java.util.Date representation of the order date for JSP fmt:formatDate
     */
    public Date getOrderDate() {
        if (this.createdAt == null) {
            return null;
        }
        return Date.from(this.createdAt.atZone(ZoneId.systemDefault()).toInstant());
    }
    
    /**
     * Check if order is pending
     */
    public boolean isPending() {
        return "PENDING".equals(status);
    }
    
    /**
     * Check if order is confirmed
     */
    public boolean isConfirmed() {
        return "CONFIRMED".equals(status);
    }
    
    /**
     * Check if order is shipped
     */
    public boolean isShipped() {
        return "SHIPPED".equals(status);
    }
    
    /**
     * Check if order is delivered
     */
    public boolean isDelivered() {
        return "DELIVERED".equals(status);
    }
    
    /**
     * Check if order is cancelled
     */
    public boolean isCancelled() {
        return "CANCELLED".equals(status);
    }
    
    @Override
    public String toString() {
        return "Order{" +
                "id=" + id +
                ", userId=" + userId +
                ", total=" + total +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
    public BigDecimal getTotalAmount() {
        if (orderItems == null || orderItems.isEmpty()) {
            return BigDecimal.ZERO;
        }

        return orderItems.stream()
                .map(item -> item.getPrice().multiply(BigDecimal.valueOf(item.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
}
