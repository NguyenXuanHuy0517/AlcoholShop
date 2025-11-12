package com.example.alcoholshop.dao.impl;

import com.example.alcoholshop.dao.OrderDAO;
import com.example.alcoholshop.model.Order;
import com.example.alcoholshop.model.OrderItem;
import com.example.alcoholshop.util.DBUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Implementation of OrderDAO using JDBC
 */
public class OrderDAOImpl implements OrderDAO {
    private static final Logger logger = LoggerFactory.getLogger(OrderDAOImpl.class);

    @Override
    public List<Order> findAll() {
        String sql = "SELECT o.*, u.fullname as user_fullname, u.email as user_email FROM orders o " +
                     "LEFT JOIN user_account u ON o.user_id = u.id " +
                     "ORDER BY o.created_at DESC";
        List<Order> orders = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                // load order items so totals compute correctly
                loadOrderItems(order);
                orders.add(order);
            }

        } catch (SQLException e) {
            logger.error("Error finding all orders", e);
        }

        return orders;
    }

    @Override
    public Order findById(int id) {
        String sql = "SELECT o.*, u.fullname as user_fullname, u.email as user_email FROM orders o " +
                     "LEFT JOIN user_account u ON o.user_id = u.id " +
                     "WHERE o.id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Order order = mapResultSetToOrder(rs);
                    loadOrderItems(order);
                    return order;
                }
            }

        } catch (SQLException e) {
            logger.error("Error finding order by ID: " + id, e);
        }

        return null;
    }

    @Override
    public List<Order> findByUserId(int userId) {
        String sql = "SELECT o.*, u.fullname as user_fullname, u.email as user_email FROM orders o " +
                     "LEFT JOIN user_account u ON o.user_id = u.id " +
                     "WHERE o.user_id = ? " +
                     "ORDER BY o.created_at DESC";
        List<Order> orders = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Order order = mapResultSetToOrder(rs);
                    loadOrderItems(order);
                    orders.add(order);
                }
            }

        } catch (SQLException e) {
            logger.error("Error finding orders by user ID: " + userId, e);
        }

        return orders;
    }

    @Override
    public List<Order> findByStatus(String status) {
        String sql = "SELECT o.*, u.fullname as user_fullname, u.email as user_email FROM orders o " +
                     "LEFT JOIN user_account u ON o.user_id = u.id " +
                     "WHERE o.status = ? " +
                     "ORDER BY o.created_at DESC";
        List<Order> orders = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Order order = mapResultSetToOrder(rs);
                    loadOrderItems(order);
                    orders.add(order);
                }
            }

        } catch (SQLException e) {
            logger.error("Error finding orders by status: " + status, e);
        }

        return orders;
    }

    @Override
    public boolean create(Order order) {
        String sql = "INSERT INTO orders (user_id, total, status) VALUES (?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, order.getUserId());
            stmt.setBigDecimal(2, order.getTotal());
            stmt.setString(3, order.getStatus());

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        order.setId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }

        } catch (SQLException e) {
            logger.error("Error creating order", e);
        }

        return false;
    }

    @Override
    public boolean update(Order order) {
        String sql = "UPDATE orders SET user_id = ?, total = ?, status = ? WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, order.getUserId());
            stmt.setBigDecimal(2, order.getTotal());
            stmt.setString(3, order.getStatus());
            stmt.setInt(4, order.getId());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            logger.error("Error updating order: " + order.getId(), e);
        }

        return false;
    }

    @Override
    public boolean updateStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, orderId);

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            logger.error("Error updating order status: " + orderId, e);
        }

        return false;
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM orders WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            logger.error("Error deleting order: " + id, e);
        }

        return false;
    }

    @Override
    public int getTotalCount() {
        String sql = "SELECT COUNT(*) FROM orders";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            logger.error("Error getting total order count", e);
        }

        return 0;
    }

    @Override
    public int getCountByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM orders WHERE status = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            logger.error("Error getting order count by status: " + status, e);
        }

        return 0;
    }

    @Override
    public int getCountByUser(int userId) {
        String sql = "SELECT COUNT(*) FROM orders WHERE user_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            logger.error("Error getting order count by user: " + userId, e);
        }

        return 0;
    }

    /**
     * Map ResultSet to Order object
     */
    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setUserId(rs.getInt("user_id"));
        order.setUserFullname(rs.getString("user_fullname"));
        order.setUserEmail(rs.getString("user_email"));
        order.setTotal(rs.getBigDecimal("total"));
        order.setStatus(rs.getString("status"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            order.setCreatedAt(createdAt.toLocalDateTime());
        }

        return order;
    }

    /**
     * Load order items for a given order and set into Order.orderItems
     */
    private void loadOrderItems(Order order) {
        if (order == null) return;
        String sql = "SELECT oi.*, p.name as product_name, p.code as product_code FROM order_item oi " +
                     "LEFT JOIN product p ON oi.product_id = p.id WHERE oi.order_id = ?";
        List<OrderItem> items = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, order.getId());
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    OrderItem it = new OrderItem();
                    it.setId(rs.getInt("id"));
                    it.setOrderId(rs.getInt("order_id"));
                    it.setProductId(rs.getInt("product_id"));
                    it.setProductName(rs.getString("product_name"));
                    it.setProductCode(rs.getString("product_code"));
                    it.setQuantity(rs.getInt("quantity"));
                    it.setPrice(rs.getBigDecimal("price"));
                    items.add(it);
                }
            }

        } catch (SQLException e) {
            logger.error("Error loading order items for order: " + order.getId(), e);
        }

        order.setOrderItems(items);
    }
}
