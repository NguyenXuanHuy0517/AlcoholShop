package com.example.alcoholshop.servlet.admin;

import com.example.alcoholshop.dao.CategoryDAO;
import com.example.alcoholshop.dao.UserDAO;
import com.example.alcoholshop.dao.impl.CategoryDAOImpl;
import com.example.alcoholshop.dao.impl.UserDAOImpl;
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
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;

/**
 * Admin user management servlet
 */
@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(AdminUserServlet.class);

    private UserDAO userDAO;
    private CategoryDAO categoryDAO;
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAOImpl();
        categoryDAO = new CategoryDAOImpl();
        logger.info("AdminUserServlet initialized");
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
        String role = request.getParameter("role");

        try {
            if ("updateRole".equals(action)) {
                updateUserRole(request, response);
            } else {
                // Pass search and status through to showUserList
                String search = request.getParameter("search");
                String status = request.getParameter("status");
                showUserList(request, response, role, search, status);
            }

        } catch (Exception e) {
            logger.error("Error in AdminUserServlet", e);
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
     * Show user list
     */
    private void showUserList(HttpServletRequest request, HttpServletResponse response, String role, String search, String status)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        UserAccount currentUser = (UserAccount) session.getAttribute("currentUser");

        List<UserAccount> users;

        if (role != null && !role.trim().isEmpty()) {
            users = userDAO.findByRole(role);
            request.setAttribute("selectedRole", role);
        } else {
            users = userDAO.findAll();
        }

        // Apply status filter (active/inactive)
        if (status != null && !status.trim().isEmpty()) {
            if ("active".equalsIgnoreCase(status)) {
                users = users.stream().filter(u -> u.isActive()).collect(Collectors.toList());
            } else if ("inactive".equalsIgnoreCase(status)) {
                users = users.stream().filter(u -> !u.isActive()).collect(Collectors.toList());
            }
            request.setAttribute("selectedStatus", status);
        }

        // Apply search filter (username, fullname, email) case-insensitive
        if (search != null && !search.trim().isEmpty()) {
            String q = search.trim().toLowerCase(Locale.ROOT);
            users = users.stream().filter(u -> {
                String username = u.getUsername() != null ? u.getUsername().toLowerCase(Locale.ROOT) : "";
                String fullname = u.getFullname() != null ? u.getFullname().toLowerCase(Locale.ROOT) : "";
                String email = u.getEmail() != null ? u.getEmail().toLowerCase(Locale.ROOT) : "";
                return username.contains(q) || fullname.contains(q) || email.contains(q);
            }).collect(Collectors.toList());
            request.setAttribute("searchKeyword", search.trim());
        }

        request.setAttribute("users", users);

        // Get user statistics
        request.setAttribute("totalUsers", userDAO.getTotalCount());
        request.setAttribute("adminUsers", userDAO.getCountByRole("ADMIN"));
        request.setAttribute("customerUsers", userDAO.getCountByRole("CUSTOMER"));

        logger.info("Showing user list for admin: " + currentUser.getUsername());
        request.getRequestDispatcher("/pages/admin/users.jsp").forward(request, response);
    }

    /**
     * Update user role
     */
    private void updateUserRole(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userIdStr = request.getParameter("id");
        String newRole = request.getParameter("role");

        if (userIdStr == null || userIdStr.isEmpty() || newRole == null || newRole.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdStr);

            // Validate role
            if (!isValidRole(newRole)) {
                request.setAttribute("error", "Invalid user role");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }

            // Prevent admin from changing their own role
            UserAccount currentUser = (UserAccount) request.getSession().getAttribute("currentUser");
            if (currentUser != null && currentUser.getId() == userId) {
                request.setAttribute("error", "You cannot change your own role");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }

            if (userDAO.updateRole(userId, newRole)) {
                logger.info("User role updated: " + userId + " -> " + newRole);
                request.setAttribute("success", "User role updated successfully");
            } else {
                logger.error("Failed to update user role: " + userId);
                request.setAttribute("error", "Failed to update user role");
            }

            response.sendRedirect(request.getContextPath() + "/admin/users");

        } catch (NumberFormatException e) {
            logger.error("Invalid user ID: " + userIdStr, e);
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }

    /**
     * Check if role is valid
     */
    private boolean isValidRole(String role) {
        return "ADMIN".equals(role) || "CUSTOMER".equals(role);
    }
}
