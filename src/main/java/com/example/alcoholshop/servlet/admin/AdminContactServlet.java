package com.example.alcoholshop.servlet.admin;

import com.example.alcoholshop.dao.CategoryDAO;
import com.example.alcoholshop.dao.ContactDAO;
import com.example.alcoholshop.dao.ProductDAO;
import com.example.alcoholshop.dao.impl.CategoryDAOImpl;
import com.example.alcoholshop.dao.impl.ContactDAOImpl;
import com.example.alcoholshop.model.Category;
import com.example.alcoholshop.model.ContactMessage;
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

/**
 * Admin contact management servlet
 */
@WebServlet("/admin/contacts")
public class AdminContactServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(AdminContactServlet.class);

    private ContactDAO contactDAO;
    @Override
    public void init() throws ServletException {
        contactDAO = new ContactDAOImpl();
        logger.info("AdminContactServlet initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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
        String email = request.getParameter("email");

        try {
            if ("view".equals(action)) {
                viewContactMessage(request, response);
            } else if ("delete".equals(action)) {
                deleteContactMessage(request, response);
            } else {
                showContactList(request, response, email);
            }

        } catch (Exception e) {
            logger.error("Error in AdminContactServlet", e);
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
     * Show contact message list
     */
    private void showContactList(HttpServletRequest request, HttpServletResponse response, String email)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        UserAccount currentUser = (UserAccount) session.getAttribute("currentUser");

        List<ContactMessage> messages;

        if (email != null && !email.trim().isEmpty()) {
            messages = contactDAO.findByEmail(email);
            request.setAttribute("searchEmail", email);
        } else {
            messages = contactDAO.findAll();
        }

        request.setAttribute("messages", messages);
        request.setAttribute("totalMessages", contactDAO.getTotalCount());


        logger.info("Showing contact list for admin: " + currentUser.getUsername());
        request.getRequestDispatcher("/pages/admin/contacts.jsp").forward(request, response);
    }

    /**
     * View contact message detail
     */
    private void viewContactMessage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String messageIdStr = request.getParameter("id");
        if (messageIdStr == null || messageIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/contacts");
            return;
        }

        try {
            int messageId = Integer.parseInt(messageIdStr);
            ContactMessage message = contactDAO.findById(messageId);

            if (message == null) {
                request.setAttribute("error", "Contact message not found");
                response.sendRedirect(request.getContextPath() + "/admin/contacts");
                return;
            }

            request.setAttribute("message", message);
            request.getRequestDispatcher("/pages/admin/contact-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            logger.error("Invalid message ID: " + messageIdStr, e);
            response.sendRedirect(request.getContextPath() + "/admin/contacts");
        }
    }

    /**
     * Delete contact message
     */
    private void deleteContactMessage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String messageIdStr = request.getParameter("id");
        if (messageIdStr == null || messageIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/contacts");
            return;
        }

        try {
            int messageId = Integer.parseInt(messageIdStr);

            if (contactDAO.delete(messageId)) {
                logger.info("Contact message deleted: " + messageId);
                request.setAttribute("success", "Contact message deleted successfully");
            } else {
                logger.error("Failed to delete contact message: " + messageId);
                request.setAttribute("error", "Failed to delete contact message");
            }

            response.sendRedirect(request.getContextPath() + "/admin/contacts");

        } catch (NumberFormatException e) {
            logger.error("Invalid message ID: " + messageIdStr, e);
            response.sendRedirect(request.getContextPath() + "/admin/contacts");
        }
    }
}
