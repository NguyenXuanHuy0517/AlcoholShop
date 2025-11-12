package com.example.alcoholshop.servlet.auth;

import com.example.alcoholshop.util.AppConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

/**
 * Logout servlet to handle user logout
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(LogoutServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session != null) {
            String username = "Unknown";
            Object currentUser = session.getAttribute("currentUser");
            if (currentUser != null) {
                username = currentUser.toString();
            }

            // Invalidate session
            session.invalidate();
            logger.info("User logged out: " + username);
        }

        // Remove remember-me cookie if present
        try {
            String cookieName = AppConfig.getOrDefault("security.rememberMe.cookieName", "alcoholshop_remember");
            Cookie del = new Cookie(cookieName, "");
            del.setMaxAge(0);
            String contextPath = request.getContextPath();
            del.setPath(contextPath == null || contextPath.isEmpty() ? "/" : contextPath);
            del.setHttpOnly(true);
            del.setSecure(request.isSecure());
            response.addCookie(del);
        } catch (Exception e) {
            logger.warn("Failed to remove remember-me cookie on logout", e);
        }

        // Redirect to home page
        response.sendRedirect(request.getContextPath() + "/");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
