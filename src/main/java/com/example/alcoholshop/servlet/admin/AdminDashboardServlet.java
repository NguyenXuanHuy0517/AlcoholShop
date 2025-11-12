package com.example.alcoholshop.servlet.admin;

import com.example.alcoholshop.dao.*;
import com.example.alcoholshop.dao.impl.*;
import com.example.alcoholshop.model.Category;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Admin dashboard servlet
 */
@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(AdminDashboardServlet.class);
    private CategoryDAO categoryDAO;
    private ProductDAO productDAO;
    private OrderDAO orderDAO;
    private UserDAO userDAO;
    private ContactDAO contactDAO;
    
    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAOImpl();
        orderDAO = new OrderDAOImpl();
        userDAO = new UserDAOImpl();
        contactDAO = new ContactDAOImpl();
        categoryDAO = new CategoryDAOImpl();
        logger.info("AdminDashboardServlet initialized");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get all categories for navigation
        List<Category> categories = categoryDAO.findAll();
        request.setAttribute("categories", categories);
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp");
            return;
        }
        
        UserAccount currentUser = (UserAccount) session.getAttribute("currentUser");
        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/pages/error/403.jsp");
            return;
        }
        
        try {
            // Get dashboard statistics
            Map<String, Object> stats = new HashMap<>();
            
            // Product statistics
            stats.put("totalProducts", productDAO.getTotalCount());
            stats.put("productsInStock", productDAO.findInStock().size());
            
            // Order statistics
            stats.put("totalOrders", orderDAO.getTotalCount());
            stats.put("pendingOrders", orderDAO.getCountByStatus("PENDING"));
            stats.put("confirmedOrders", orderDAO.getCountByStatus("CONFIRMED"));
            stats.put("shippedOrders", orderDAO.getCountByStatus("SHIPPED"));
            stats.put("deliveredOrders", orderDAO.getCountByStatus("DELIVERED"));
            
            // User statistics
            stats.put("totalUsers", userDAO.getTotalCount());
            stats.put("adminUsers", userDAO.getCountByRole("ADMIN"));
            stats.put("customerUsers", userDAO.getCountByRole("CUSTOMER"));
            
            // Contact statistics
            stats.put("totalContacts", contactDAO.getTotalCount());
            
            request.setAttribute("stats", stats);
            
            logger.info("Admin dashboard loaded for user: " + currentUser.getUsername());
            request.getRequestDispatcher("/pages/admin/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            logger.error("Error loading admin dashboard", e);
            request.setAttribute("error", "Unable to load dashboard. Please try again later.");
            request.getRequestDispatcher("/pages/error/500.jsp").forward(request, response);
        }
    }
}

