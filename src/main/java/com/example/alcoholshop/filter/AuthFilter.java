package com.example.alcoholshop.filter;

import com.example.alcoholshop.dao.UserDAO;
import com.example.alcoholshop.dao.impl.UserDAOImpl;
import com.example.alcoholshop.model.UserAccount;
import com.example.alcoholshop.util.AppConfig;
import com.example.alcoholshop.util.HmacUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.Arrays;

/**
 * Filter to check user authentication for protected resources
 */
public class AuthFilter implements Filter {
    private static final Logger logger = LoggerFactory.getLogger(AuthFilter.class);

    private UserDAO userDAO;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        logger.info("AuthFilter initialized");
        // Initialize a lightweight UserDAO for remember-me cookie resolution
        try {
            this.userDAO = new UserDAOImpl();
        } catch (Exception e) {
            logger.warn("Failed to initialize UserDAO in AuthFilter", e);
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());

        logger.debug("AuthFilter checking path: " + path);

        // Check if user is logged in
        UserAccount currentUser = null;
        if (session != null) {
            currentUser = (UserAccount) session.getAttribute("currentUser");
        }

        if (currentUser == null) {
            // Try to restore from remember-me cookie
            try {
                String cookieName = AppConfig.getOrDefault("security.rememberMe.cookieName", "alcoholshop_remember");
                Cookie[] cookies = httpRequest.getCookies();
                if (cookies != null) {
                    Cookie rm = Arrays.stream(cookies).filter(c -> cookieName.equals(c.getName())).findFirst().orElse(null);
                    if (rm != null && rm.getValue() != null && rm.getValue().contains("|")) {
                        String[] parts = rm.getValue().split("\\|");
                        // Expect username|expiryMillis|sig but split may produce extra, so process carefully
                        if (parts.length >= 3) {
                            String username = parts[0];
                            String expiryStr = parts[1];
                            String sig = parts[2];
                            long expiry = Long.parseLong(expiryStr);
                            if (System.currentTimeMillis() <= expiry) {
                                String secret = AppConfig.getOrDefault("security.rememberMe.secret", "change-me-please");
                                String data = username + "|" + expiryStr;
                                String expected = HmacUtil.hmacSha256Hex(secret, data);
                                if (expected.equals(sig)) {
                                    // signature valid; load user
                                    if (userDAO != null) {
                                        UserAccount u = userDAO.findByUsername(username);
                                        if (u != null && u.isAdult()) {
                                            HttpSession newSession = httpRequest.getSession(true);
                                            newSession.setAttribute("currentUser", u);
                                            // set reasonable timeout
                                            newSession.setMaxInactiveInterval(30 * 60);
                                            logger.info("Restored session from remember-me cookie for user: {}", username);
                                            currentUser = u;
                                        }
                                    }
                                }
                            } else {
                                // expired - remove cookie
                                Cookie del = new Cookie(cookieName, "");
                                del.setMaxAge(0);
                                del.setPath(contextPath.isEmpty() ? "/" : contextPath);
                                httpResponse.addCookie(del);
                                logger.debug("Removed expired remember-me cookie for path: {}", path);
                            }
                        }
                    }
                }
            } catch (Exception e) {
                logger.warn("Error checking remember-me cookie", e);
            }
        }

        if (currentUser == null) {
            logger.info("Unauthenticated access attempt to: " + path);

            // Store the original URL for redirect after login
            session = httpRequest.getSession(true);
            session.setAttribute("originalURL", requestURI);

            // Redirect to login page
            httpResponse.sendRedirect(contextPath + "/pages/auth/login.jsp");
            return;
        }

        logger.debug("Authenticated user access to: " + path + " by user: " + currentUser.getUsername());
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        logger.info("AuthFilter destroyed");
    }
}
