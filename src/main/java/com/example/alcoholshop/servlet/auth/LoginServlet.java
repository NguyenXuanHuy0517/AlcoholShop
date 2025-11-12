package com.example.alcoholshop.servlet.auth;

import com.example.alcoholshop.dao.UserDAO;
import com.example.alcoholshop.dao.impl.UserDAOImpl;
import com.example.alcoholshop.model.UserAccount;
import com.example.alcoholshop.util.AppConfig;
import com.example.alcoholshop.util.HmacUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.time.Duration;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Login servlet to handle user authentication
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(LoginServlet.class);

    private UserDAO userDAO;

    // Simple in-memory cache: username -> CachedUser
    private static final ConcurrentHashMap<String, CachedUser> loginCache = new ConcurrentHashMap<>();
    // TTL for cached entries (milliseconds) - 10 minutes
    private static final long CACHE_TTL_MS = Duration.ofMinutes(10).toMillis();

    private static class CachedUser {
        final UserAccount user;
        final long expiryMillis;

        CachedUser(UserAccount user, long expiryMillis) {
            this.user = user;
            this.expiryMillis = expiryMillis;
        }

        boolean isExpired() {
            return System.currentTimeMillis() > expiryMillis;
        }
    }

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAOImpl();
        logger.info("LoginServlet initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            // User is already logged in, redirect to home
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // Show login form
        request.getRequestDispatcher("/pages/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

        Map<String, String> errors = new HashMap<>();

        // Validate input
        if (username == null || username.trim().isEmpty()) {
            errors.put("username", "Username is required");
        }

        if (password == null || password.isEmpty()) {
            errors.put("password", "Password is required");
        }

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("username", username);
            request.getRequestDispatcher("/pages/auth/login.jsp").forward(request, response);
            return;
        }

        try {
            // Try cache first
            UserAccount user = getCachedUser(username.trim());
            if (user == null) {
                // Find user by username from DB
                user = userDAO.findByUsername(username.trim());
                if (user != null) {
                    cacheUser(user);
                }
            }

            if (user == null) {
                logger.warn("Login attempt with non-existent username: " + username);
                errors.put("username", "Invalid username or password");
                request.setAttribute("errors", errors);
                request.setAttribute("username", username);
                request.getRequestDispatcher("/pages/auth/login.jsp").forward(request, response);
                return;
            }

            // Verify password
            if (!BCrypt.checkpw(password, user.getPasswordHash())) {
                logger.warn("Login attempt with invalid password for user: " + username);
                // On invalid password, consider evicting cached entry to avoid locked outdated cache
                loginCache.remove(username.trim());
                errors.put("password", "Invalid username or password");
                request.setAttribute("errors", errors);
                request.setAttribute("username", username);
                request.getRequestDispatcher("/pages/auth/login.jsp").forward(request, response);
                return;
            }

            // Check if user is adult (18+)
            if (!user.isAdult()) {
                logger.warn("Login attempt by underage user: " + username);
                errors.put("age", "You must be at least 18 years old to access this site");
                request.setAttribute("errors", errors);
                request.setAttribute("username", username);
                request.getRequestDispatcher("/pages/auth/login.jsp").forward(request, response);
                return;
            }

            // Login successful
            HttpSession session = request.getSession(true);
            session.setAttribute("currentUser", user);

            // Set session timeout based on remember me
            if ("on".equals(rememberMe)) {
                session.setMaxInactiveInterval(7 * 24 * 60 * 60); // 7 days
            } else {
                session.setMaxInactiveInterval(30 * 60); // 30 minutes
            }

            // If rememberMe requested, set a persistent signed cookie that survives redeploys
            if ("on".equals(rememberMe)) {
                try {
                    String cookieName = AppConfig.getOrDefault("security.rememberMe.cookieName", "alcoholshop_remember");
                    String secret = AppConfig.getOrDefault("security.rememberMe.secret", "change-me-please");
                    int ttlDays = Integer.parseInt(AppConfig.getOrDefault("security.rememberMe.ttlDays", "14"));

                    long expiryMillis = System.currentTimeMillis() + Duration.ofDays(ttlDays).toMillis();
                    String data = user.getUsername() + "|" + expiryMillis;
                    String sig = HmacUtil.hmacSha256Hex(secret, data);
                    String cookieValue = data + "|" + sig;

                    Cookie c = new Cookie(cookieName, cookieValue);
                    c.setHttpOnly(true);
                    c.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
                    c.setMaxAge(ttlDays * 24 * 60 * 60);
                    // Mark secure only if request was secure
                    c.setSecure(request.isSecure());
                    response.addCookie(c);
                } catch (Exception e) {
                    logger.warn("Failed to set remember-me cookie", e);
                }
            }

            logger.info("User logged in successfully: " + username + " (Role: " + user.getRole() + ")");

            // Redirect to original URL or home page
            String originalURL = (String) session.getAttribute("originalURL");
            if (originalURL != null && !originalURL.isEmpty()) {
                session.removeAttribute("originalURL");
                response.sendRedirect(originalURL);
            } else {
                response.sendRedirect(request.getContextPath() + "/");
            }

        } catch (Exception e) {
            logger.error("Error during login", e);
            request.setAttribute("error", "Login failed. Please try again later.");
            request.getRequestDispatcher("/pages/auth/login.jsp").forward(request, response);
        }
    }

    private UserAccount getCachedUser(String username) {
        CachedUser cached = loginCache.get(username);
        if (cached == null) return null;
        if (cached.isExpired()) {
            loginCache.remove(username);
            return null;
        }
        return cached.user;
    }

    private void cacheUser(UserAccount user) {
        if (user == null || user.getUsername() == null) return;
        long expiry = System.currentTimeMillis() + CACHE_TTL_MS;
        loginCache.put(user.getUsername(), new CachedUser(user, expiry));
    }
}
