package com.example.alcoholshop.servlet.admin;

import com.example.alcoholshop.dao.*;
import com.example.alcoholshop.dao.impl.*;
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
import java.time.format.DateTimeFormatter;
import java.util.List;

// PDFBox imports
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDType1Font;

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

        String action = request.getParameter("action");

        try {
            if ("exportPdf".equals(action)) {
                exportPdf(request, response);
                return;
            }

            // Product statistics
            int totalProducts = productDAO.getTotalCount();
            int productsInStock = productDAO.findInStock().size();

            // Order statistics
            int totalOrders = orderDAO.getTotalCount();
            int pendingOrders = orderDAO.getCountByStatus("PENDING");
            int confirmedOrders = orderDAO.getCountByStatus("CONFIRMED");
            int shippedOrders = orderDAO.getCountByStatus("SHIPPED");
            int deliveredOrders = orderDAO.getCountByStatus("DELIVERED");

            // User statistics
            int totalUsers = userDAO.getTotalCount();
            int adminUsers = userDAO.getCountByRole("ADMIN");
            int customerUsers = userDAO.getCountByRole("CUSTOMER");

            // Contact statistics
            int totalContacts = contactDAO.getTotalCount();

            List<Order> allOrders = orderDAO.findAll();
            // recent orders: first 5
            List<Order> recentOrders = allOrders;
            if (recentOrders.size() > 5) recentOrders = recentOrders.subList(0, 5);

            // Compute total revenue from order items (getTotalAmount)
            BigDecimal totalRevenue = BigDecimal.ZERO;
            for (Order o : allOrders) {
                if (o.getTotalAmount() != null) {
                    totalRevenue = totalRevenue.add(o.getTotalAmount());
                }
            }

            // Set attributes used by JSP directly
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("productsInStock", productsInStock);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("pendingOrders", pendingOrders);
            request.setAttribute("confirmedOrders", confirmedOrders);
            request.setAttribute("shippedOrders", shippedOrders);
            request.setAttribute("deliveredOrders", deliveredOrders);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("adminUsers", adminUsers);
            request.setAttribute("customerUsers", customerUsers);
            request.setAttribute("totalContacts", totalContacts);
            request.setAttribute("recentOrders", recentOrders);
            request.setAttribute("totalRevenue", totalRevenue);

            logger.info("Admin dashboard loaded for user: " + currentUser.getUsername());
            request.getRequestDispatcher("/pages/admin/dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            logger.error("Error loading admin dashboard", e);
            request.setAttribute("error", "Unable to load dashboard. Please try again later.");
            request.getRequestDispatcher("/pages/error/500.jsp").forward(request, response);
        }
    }

    /**
     * Export dashboard summary to PDF
     */
    private void exportPdf(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Recompute the data needed for the PDF (use order items totals)
        List<Order> allOrders = orderDAO.findAll();
        List<Order> recentOrders = allOrders;
        if (recentOrders.size() > 5) recentOrders = recentOrders.subList(0, 5);

        BigDecimal totalRevenue = BigDecimal.ZERO;
        for (Order o : allOrders) {
            if (o.getTotalAmount() != null) totalRevenue = totalRevenue.add(o.getTotalAmount());
        }

        // Build a simple PDF
        try (PDDocument doc = new PDDocument()) {
            PDPage page = new PDPage();
            doc.addPage(page);

            PDPageContentStream cs = new PDPageContentStream(doc, page);
            cs.beginText();
            cs.setFont(PDType1Font.HELVETICA_BOLD, 16);
            cs.newLineAtOffset(50, 750);
            cs.showText("Admin Dashboard Report");

            cs.setFont(PDType1Font.HELVETICA, 12);
            cs.newLineAtOffset(0, -25);
            cs.showText("Total Revenue: $" + totalRevenue.toString());

            cs.newLineAtOffset(0, -20);
            cs.showText("Recent Orders:");

            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
            for (Order o : recentOrders) {
                cs.newLineAtOffset(0, -15);
                String totalStr = o.getTotalAmount() != null ? o.getTotalAmount().toString() : "0.00";
                String line = "#" + o.getId() + " - " + (o.getUserFullname() != null ? o.getUserFullname() : "Unknown") + " - $" + totalStr + " - " + (o.getCreatedAt() != null ? o.getCreatedAt().format(dtf) : "");
                cs.showText(line);
            }

            cs.endText();
            cs.close();

            // Set response headers
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=dashboard-report.pdf");
            doc.save(response.getOutputStream());
            response.getOutputStream().flush();
        } catch (IOException e) {
            logger.error("Error generating PDF", e);
            throw e;
        }
    }
}
