package com.example.alcoholshop.servlet.admin;

import com.example.alcoholshop.dao.CategoryDAO;
import com.example.alcoholshop.dao.OrderDAO;
import com.example.alcoholshop.dao.impl.CategoryDAOImpl;
import com.example.alcoholshop.dao.impl.OrderDAOImpl;
import com.example.alcoholshop.model.Category;
import com.example.alcoholshop.model.Order;
import com.example.alcoholshop.model.UserAccount;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Admin order management servlet
 */
@WebServlet("/admin/orders")
public class AdminOrderServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(AdminOrderServlet.class);
    private CategoryDAO categoryDAO;
    private OrderDAO orderDAO;
    
    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAOImpl();
        categoryDAO = new CategoryDAOImpl();
        logger.info("AdminOrderServlet initialized");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp");
            return;
        }
        // Get all categories for navigation
        List<Category> categories = categoryDAO.findAll();
        request.setAttribute("categories", categories);
        UserAccount currentUser = (UserAccount) session.getAttribute("currentUser");
        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/pages/error/403.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        String status = request.getParameter("status");
        
        try {
            if ("update".equals(action)) {
                updateOrderStatus(request, response);
            } else {
                showOrderList(request, response, status);
            }
        } catch (Exception e) {
            logger.error("Error in AdminOrderServlet", e);
            request.setAttribute("error", "Unable to process request. Please try again later.");
            request.getRequestDispatcher("/pages/error/500.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    /**
     * Show order list
     */
    private void showOrderList(HttpServletRequest request, HttpServletResponse response, String status)
            throws IOException {

        HttpSession session = request.getSession(false);
        UserAccount currentUser = (UserAccount) session.getAttribute("currentUser");
        
        List<Order> orders;
        
        if (status != null && !status.trim().isEmpty()) {
            orders = orderDAO.findByStatus(status);
            request.setAttribute("selectedStatus", status);
        } else {
            orders = orderDAO.findAll();
        }
        
        request.setAttribute("orders", orders);
        
        // Compute revenue totals
        BigDecimal totalRevenue = BigDecimal.ZERO;
        Map<String, BigDecimal> revenuePerUser = new HashMap<>();
        for (Order o : orders) {
            BigDecimal t = o.getTotal() != null ? o.getTotal() : BigDecimal.ZERO;
            totalRevenue = totalRevenue.add(t);
            String key = o.getUserEmail() != null ? o.getUserEmail() : o.getUserFullname();
            revenuePerUser.put(key, revenuePerUser.getOrDefault(key, BigDecimal.ZERO).add(t));
        }

        // Get order statistics
        request.setAttribute("totalOrders", orderDAO.getTotalCount());
        request.setAttribute("pendingOrders", orderDAO.getCountByStatus("PENDING"));
        request.setAttribute("confirmedOrders", orderDAO.getCountByStatus("CONFIRMED"));
        request.setAttribute("shippedOrders", orderDAO.getCountByStatus("SHIPPED"));
        request.setAttribute("deliveredOrders", orderDAO.getCountByStatus("DELIVERED"));
        request.setAttribute("cancelledOrders", orderDAO.getCountByStatus("CANCELLED"));

        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("revenuePerUser", revenuePerUser);

        logger.info("Showing order list for admin: " + currentUser.getUsername());
        try {
            request.getRequestDispatcher("/pages/admin/orders.jsp").forward(request, response);
        } catch (ServletException e) {
            logger.error("ServletException forwarding to admin orders", e);
            throw new IOException(e);
        }
    }
    
    /**
     * Update order status
     */
    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String orderIdStr = request.getParameter("id");
        String newStatus = request.getParameter("status");
        
        if (orderIdStr == null || orderIdStr.isEmpty() || newStatus == null || newStatus.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(orderIdStr);
            
            // Validate status
            if (!isValidStatus(newStatus)) {
                request.setAttribute("error", "Invalid order status");
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }

            HttpSession session = request.getSession(); // lấy session để lưu flash message

            if (orderDAO.updateStatus(orderId, newStatus)) {
                logger.info("Order status updated: " + orderId + " -> " + newStatus);
                session.setAttribute("success", "Order status updated successfully");
            } else {
                logger.error("Failed to update order status: " + orderId);
                session.setAttribute("error", "Failed to update order status");
            }

            response.sendRedirect(request.getContextPath() + "/admin/orders");


        } catch (NumberFormatException e) {
            logger.error("Invalid order ID: " + orderIdStr, e);
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }
    
    /**
     * Check if status is valid
     */
    private boolean isValidStatus(String status) {
        return "PENDING".equals(status) || "CONFIRMED".equals(status) || 
               "SHIPPED".equals(status) || "DELIVERED".equals(status) || 
               "CANCELLED".equals(status);
    }
}
