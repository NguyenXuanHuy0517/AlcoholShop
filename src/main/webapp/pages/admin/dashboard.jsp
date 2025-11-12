<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../includes/header.jsp" />

<jsp:include page="../includes/topmenu.jsp" />

<!-- Admin Dashboard -->
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <nav class="col-md-3 col-lg-2 d-md-block bg-dark sidebar collapse">
            <div class="position-sticky pt-3">
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link active text-gold" href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-secondary" href="${pageContext.request.contextPath}/admin/products">
                            <i class="fas fa-box me-2"></i>Products
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-secondary" href="${pageContext.request.contextPath}/admin/orders">
                            <i class="fas fa-shopping-cart me-2"></i>Orders
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-secondary" href="${pageContext.request.contextPath}/admin/users">
                            <i class="fas fa-users me-2"></i>Users
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-secondary" href="${pageContext.request.contextPath}/admin/contacts">
                            <i class="fas fa-envelope me-2"></i>Messages
                        </a>
                    </li>
                </ul>
            </div>
        </nav>

        <!-- Main content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2 text-gold">Admin Dashboard</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <div class="btn-group me-2">
                        <a href="${pageContext.request.contextPath}/admin/dashboard?action=exportPdf" class="btn btn-outline-primary">
                            <i class="fas fa-download me-1"></i>Export
                        </a>
                    </div>
                </div>
            </div>

            <!-- Statistics Cards -->
            <div class="row mb-4">
                <div class="col-xl-3 col-md-6 mb-4" data-aos="fade-up">
                    <div class="card bg-glass border-left-primary shadow h-100 py-2">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-gold text-uppercase mb-1">Total Products</div>
                                    <div class="h5 mb-0 font-weight-bold text-white">${totalProducts}</div>
                                </div>
                                <div class="col-auto">
                                    <i class="fas fa-box fa-2x text-gold"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6 mb-4" data-aos="fade-up" data-aos-delay="100">
                    <div class="card bg-glass border-left-success shadow h-100 py-2">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-gold text-uppercase mb-1">Total Orders</div>
                                    <div class="h5 mb-0 font-weight-bold text-white">${totalOrders}</div>
                                </div>
                                <div class="col-auto">
                                    <i class="fas fa-shopping-cart fa-2x text-success"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6 mb-4" data-aos="fade-up" data-aos-delay="200">
                    <div class="card bg-glass border-left-info shadow h-100 py-2">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-gold text-uppercase mb-1">Total Users</div>
                                    <div class="h5 mb-0 font-weight-bold text-white">${totalUsers}</div>
                                </div>
                                <div class="col-auto">
                                    <i class="fas fa-users fa-2x text-info"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6 mb-4" data-aos="fade-up" data-aos-delay="300">
                    <div class="card bg-glass border-left-warning shadow h-100 py-2">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-gold text-uppercase mb-1">Pending Orders</div>
                                    <div class="h5 mb-0 font-weight-bold text-white">${pendingOrders}</div>
                                </div>
                                <div class="col-auto">
                                    <i class="fas fa-clock fa-2x text-warning"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Orders -->
            <div class="row">
                <div class="col-lg-8">
                    <div class="card bg-glass mb-4">
                        <div class="card-header">
                            <h6 class="m-0 font-weight-bold text-gold">
                                <i class="fas fa-shopping-cart me-2"></i>Recent Orders
                            </h6>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-dark table-hover">
                                    <thead>
                                    <tr>
                                        <th>Order ID</th>
                                        <th>Customer</th>
                                        <th>Total</th>
                                        <th>Status</th>
                                        <th>Date</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:choose>
                                        <c:when test="${not empty recentOrders}">
                                            <c:forEach var="order" items="${recentOrders}">
                                                <tr>
                                                    <td>#${order.id}</td>
                                                    <td>${order.userFullname}</td>
                                                    <td class="text-gold">
                                                        <fmt:formatNumber value="${order.total}" type="currency" currencySymbol="$" />
                                                    </td>
                                                    <td>
                                                            <span class="badge bg-${order.status == 'PENDING' ? 'warning' : order.status == 'CONFIRMED' ? 'info' : order.status == 'SHIPPED' ? 'primary' : order.status == 'DELIVERED' ? 'success' : 'danger'}">
                                                                    ${order.status}
                                                            </span>
                                                    </td>
                                                    <td>
                                                        <fmt:formatDate value="${order.orderDate}" pattern="MMM dd, yyyy" />
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="5" class="text-center text-muted">No recent orders</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="col-lg-4">
                    <div class="card bg-glass mb-4">
                        <div class="card-header">
                            <h6 class="m-0 font-weight-bold text-gold">
                                <i class="fas fa-bolt me-2"></i>Quick Actions
                            </h6>
                        </div>
                        <div class="card-body">
                            <div class="d-grid gap-2">
                                <a href="${pageContext.request.contextPath}/admin/products?action=add" class="btn btn-primary">
                                    <i class="fas fa-plus me-2"></i>Add New Product
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-primary">
                                    <i class="fas fa-list me-2"></i>View All Orders
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-info">
                                    <i class="fas fa-users me-2"></i>Manage Users
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/contacts" class="btn btn-outline-warning">
                                    <i class="fas fa-envelope me-2"></i>View Messages
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- System Status -->
                    <div class="card bg-glass">
                        <div class="card-header">
                            <h6 class="m-0 font-weight-bold text-gold">
                                <i class="fas fa-server me-2"></i>System Status
                            </h6>
                        </div>
                        <div class="card-body">
                            <div class="mb-2">
                                <span class="text-secondary">Database:</span>
                                <span class="badge bg-success float-end">Online</span>
                            </div>
                            <div class="mb-2">
                                <span class="text-secondary">Server:</span>
                                <span class="badge bg-success float-end">Running</span>
                            </div>
                            <div class="mb-2">
                                <span class="text-secondary">SSL:</span>
                                <span class="badge bg-success float-end">Active</span>
                            </div>
                            <div class="mb-0">
                                <span class="text-secondary">Last Backup:</span>
                                <span class="text-muted small">Today</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<style>
    .sidebar {
        position: fixed;
        top: 0;
        bottom: 0;
        left: 0;
        z-index: 100;
        padding: 48px 0 0;
        box-shadow: inset -1px 0 0 rgba(0, 0, 0, .1);
    }

    .sidebar .nav-link {
        color: #333;
        border-radius: 0;
        padding: 0.75rem 1rem;
    }

    .sidebar .nav-link:hover {
        color: var(--primary-gold);
        background-color: rgba(212, 175, 55, 0.1);
    }

    .sidebar .nav-link.active {
        color: var(--primary-gold);
        background-color: rgba(212, 175, 55, 0.2);
    }

    .border-left-primary {
        border-left: 0.25rem solid var(--primary-gold) !important;
    }

    .border-left-success {
        border-left: 0.25rem solid #28a745 !important;
    }

    .border-left-info {
        border-left: 0.25rem solid #17a2b8 !important;
    }

    .border-left-warning {
        border-left: 0.25rem solid #ffc107 !important;
    }

    @media (max-width: 767.98px) {
        .sidebar {
            top: 5rem;
        }
    }
</style>

<jsp:include page="../includes/footer.jsp" />
