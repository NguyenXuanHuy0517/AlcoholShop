<%@ page import="com.example.alcoholshop.dao.impl.CategoryDAOImpl" %>
<%@ page import="com.example.alcoholshop.dao.CategoryDAO" %>
<%@ page import="com.example.alcoholshop.model.Category" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    // --- 1. TẠO LIST MẪU (dev) VÀ ĐẶT VÀO request SCOPE ---
    // đặt TRƯỚC phần HTML dùng ${categories} !

        List<Category> categories = new ArrayList<>();
        categories.add(new Category(1, "Whiskey"));
        categories.add(new Category(2, "Vodka"));
        categories.add(new Category(3, "Wine"));
        categories.add(new Category(4, "Beer"));
        categories.add(new Category(5, "Liqueur"));
        request.setAttribute("categories", categories); // quan trọng

%>


<nav class="navbar navbar-expand-lg navbar-dark sticky-top">
    <div class="container">
        <!-- Brand -->
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/home">
            <i class="fas fa-wine-bottle me-2"></i>AlcoholShop
        </a>
        
        <!-- Mobile toggle -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <!-- Navigation -->
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/home">
                        <i class="fas fa-home me-1"></i>Home
                    </a>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-th-large me-1"></i>Categories
                    </a>
                    <ul class="dropdown-menu">
                        <c:forEach var="category" items="${categories}">
                            <li>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/products?category=${category.id}">
                                    <c:out value="${category.name}" />
                                </a>
                            </li>
                        </c:forEach>
                    </ul>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/products">
                        <i class="fas fa-store me-1"></i>All Products
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/contact">
                        <i class="fas fa-envelope me-1"></i>Contact
                    </a>
                </li>
            </ul>
            
            <!-- Search form -->
            <form class="d-flex me-3" action="${pageContext.request.contextPath}/products" method="get">
                <input class="form-control me-2" type="search" name="search" placeholder="Search products..." 
                       value="${param.search}" style="min-width: 200px;">
                <button class="btn btn-outline-light" type="submit">
                    <i class="fas fa-search"></i>
                </button>
            </form>
            
            <!-- User menu -->
            <ul class="navbar-nav">
                <c:choose>
                    <c:when test="${sessionScope.currentUser != null}">
                        <!-- Cart -->
                        <li class="nav-item">
                            <a class="nav-link position-relative" href="${pageContext.request.contextPath}/cart">
                                <i class="fas fa-shopping-cart me-1"></i>Cart
                                <c:if test="${sessionScope.cart != null && !empty sessionScope.cart}">
                                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                        ${sessionScope.cart.size()}
                                    </span>
                                </c:if>
                            </a>
                        </li>
                        
                        <!-- User dropdown -->
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                                <i class="fas fa-user me-1"></i>
                                <c:out value="${sessionScope.currentUser.fullname}" />
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><h6 class="dropdown-header">Welcome, <c:out value="${sessionScope.currentUser.fullname}" />!</h6></li>
                                <li><hr class="dropdown-divider"></li>

                                <!-- Admin menu -->
                                <c:if test="${sessionScope.currentUser.role == 'ADMIN'}">
                                    <li><h6 class="dropdown-header">Admin Panel</h6></li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard">
                                            <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/products">
                                            <i class="fas fa-box me-2"></i>Products
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/orders">
                                            <i class="fas fa-shopping-bag me-2"></i>Orders
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/users">
                                            <i class="fas fa-users me-2"></i>Users
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/contact">
                                            <i class="fas fa-envelope me-2"></i>Messages
                                        </a>
                                    </li>
                                    <li><hr class="dropdown-divider"></li>
                                </c:if>

                                <!-- User menu -->
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/pages/profile.jsp">
                                        <i class="fas fa-user-circle me-2"></i>Profile
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/pages/myorders.jsp">
                                        <i class="fas fa-history me-2"></i>My Orders
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                                        <i class="fas fa-sign-out-alt me-2"></i>Logout
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <!-- Guest menu -->
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/login">
                                <i class="fas fa-sign-in-alt me-1"></i>Login
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/register">
                                <i class="fas fa-user-plus me-1"></i>Register
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>
