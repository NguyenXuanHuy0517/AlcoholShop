<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../includes/header.jsp" />

<jsp:include page="../includes/topmenu.jsp" />

<!-- Admin Orders -->
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <nav class="col-md-3 col-lg-2 d-md-block bg-dark sidebar collapse">
            <div class="position-sticky pt-3">
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link text-secondary" href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-secondary" href="${pageContext.request.contextPath}/admin/products">
                            <i class="fas fa-box me-2"></i>Products
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active text-gold" href="${pageContext.request.contextPath}/admin/orders">
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
                <h1 class="h2 text-gold">Order Management</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <div class="btn-group me-2">
                        <button type="button" class="btn btn-outline-primary" onclick="exportOrders()">
                            <i class="fas fa-download me-1"></i>Export
                        </button>
                    </div>
                </div>
            </div>

            <!-- flash messages -->
            <c:if test="${not empty sessionScope.success}">
                <div class="alert alert-success" role="alert">
                    ${sessionScope.success}
                </div>
                <c:remove var="success" scope="session" />
            </c:if>
            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-danger" role="alert">
                    ${sessionScope.error}
                </div>
                <c:remove var="error" scope="session" />
            </c:if>

            <!-- Order Statistics -->
            <div class="row mb-4">
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card bg-glass border-left-primary shadow h-100 py-2">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-gold text-uppercase mb-1">Total Orders</div>
                                    <div class="h5 mb-0 font-weight-bold text-white">${totalOrders}</div>
                                </div>
                                <div class="col-auto">
                                    <i class="fas fa-shopping-cart fa-2x text-gold"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card bg-glass border-left-warning shadow h-100 py-2">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-gold text-uppercase mb-1">Pending</div>
                                    <div class="h5 mb-0 font-weight-bold text-white">${pendingOrders}</div>
                                </div>
                                <div class="col-auto">
                                    <i class="fas fa-clock fa-2x text-warning"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card bg-glass border-left-info shadow h-100 py-2">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-gold text-uppercase mb-1">Confirmed</div>
                                    <div class="h5 mb-0 font-weight-bold text-white">${confirmedOrders}</div>
                                </div>
                                <div class="col-auto">
                                    <i class="fas fa-check-circle fa-2x text-info"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card bg-glass border-left-success shadow h-100 py-2">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-gold text-uppercase mb-1">Delivered</div>
                                    <div class="h5 mb-0 font-weight-bold text-white">${deliveredOrders}</div>
                                </div>
                                <div class="col-auto">
                                    <i class="fas fa-truck fa-2x text-success"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Revenue Summary -->
            <div class="row mb-4">
                <div class="col-xl-4 col-md-6 mb-4">
                    <div class="card bg-glass border-left-success shadow h-100 py-2">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-gold text-uppercase mb-1">Total Revenue</div>
                                    <div class="h5 mb-0 font-weight-bold text-white">
                                        <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="$" />
                                    </div>
                                </div>
                                <div class="col-auto">
                                    <i class="fas fa-dollar-sign fa-2x text-success"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-8 col-md-6 mb-4">
                    <div class="card bg-glass shadow h-100 py-2">
                        <div class="card-body">
                            <div class="text-xs font-weight-bold text-gold text-uppercase mb-2">Revenue per Customer</div>
                            <div class="row">
                                <c:forEach var="entry" items="${revenuePerUser.entrySet()}">
                                    <div class="col-md-4 mb-2">
                                        <div class="card bg-dark p-2">
                                            <div class="small text-muted">${entry.key}</div>
                                            <div class="h6 text-gold">
                                                <fmt:formatNumber value="${entry.value}" type="currency" currencySymbol="$" />
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filters -->
            <div class="card bg-glass mb-4">
                <div class="card-body">
                    <form method="get" action="${pageContext.request.contextPath}/admin/orders" class="row g-3">
                        <div class="col-md-3">
                            <label for="status" class="form-label text-gold">Status</label>
                            <select class="form-select" id="status" name="status">
                                <option value="">All Status</option>
                                <option value="PENDING" ${param.status == 'PENDING' ? 'selected' : ''}>Pending</option>
                                <option value="CONFIRMED" ${param.status == 'CONFIRMED' ? 'selected' : ''}>Confirmed</option>
                                <option value="SHIPPED" ${param.status == 'SHIPPED' ? 'selected' : ''}>Shipped</option>
                                <option value="DELIVERED" ${param.status == 'DELIVERED' ? 'selected' : ''}>Delivered</option>
                                <option value="CANCELLED" ${param.status == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label for="search" class="form-label text-gold">Search</label>
                            <input type="text" class="form-control" id="search" name="search" 
                                   placeholder="Search orders..." value="${param.search}">
                        </div>
                        <div class="col-md-3">
                            <label for="dateFrom" class="form-label text-gold">From Date</label>
                            <input type="date" class="form-control" id="dateFrom" name="dateFrom" value="${param.dateFrom}">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">&nbsp;</label>
                            <div class="d-grid">
                                <button type="submit" class="btn btn-outline-primary">
                                    <i class="fas fa-search me-1"></i>Filter
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            
            <!-- Orders Table -->
            <div class="card bg-glass">
                <div class="card-header">
                    <h6 class="m-0 font-weight-bold text-gold">
                        <i class="fas fa-list me-2"></i>Orders (${orders.size()})
                    </h6>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-dark table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>Order ID</th>
                                    <th>Customer</th>
                                    <th>Total</th>
                                    <th>Status</th>
                                    <th>Date</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty orders}">
                                        <c:forEach var="order" items="${orders}">
                                            <tr>
                                                <td>
                                                    <strong>#${order.id}</strong>
                                                </td>
                                                <td>
                                                    <div>
                                                        <strong>${order.userFullname}</strong>
                                                        <br>
                                                        <small class="text-muted">${order.userEmail}</small>
                                                    </div>
                                                </td>
                                                <td class="text-gold">
                                                    <fmt:formatNumber value="${order.total}" type="currency" currencySymbol="$" />
                                                </td>
                                                <td>
                                                    <span class="badge ${order.status == 'PENDING' ? 'bg-warning' : order.status == 'CONFIRMED' ? 'bg-info' : order.status == 'SHIPPED' ? 'bg-primary' : order.status == 'DELIVERED' ? 'bg-success' : order.status == 'COMPLETE' ? 'bg-secondary' : 'bg-danger'}">
                                                         ${order.status}
                                                     </span>
                                                 </td>
                                                 <td>
                                                         ${order.createdAt}
                                                     <br>
                                                    <small class="text-muted">
                                                            ${order.createdAt}
                                                    </small>
                                                 </td>
                                                <td>
                                                    <div class="btn-group" role="group">
                                                        <a href="${pageContext.request.contextPath}/admin/orders?action=update&id=${order.id}&status=CONFIRMED"
                                                           class="btn btn-outline-success btn-sm"
                                                           title="Set to Confirmed">
                                                            <i class="fas fa-check"></i>
                                                        </a>

                                                        <a href="${pageContext.request.contextPath}/admin/orders?action=update&id=${order.id}&status=DELIVERED"
                                                           class="btn btn-outline-primary btn-sm"
                                                           title="Set to Delivered">
                                                            <i class="fas fa-truck"></i>
                                                        </a>

                                                        <a href="${pageContext.request.contextPath}/admin/orders?action=update&id=${order.id}&status=SHIPPED"
                                                           class="btn btn-outline-secondary btn-sm"
                                                           title="Set to Shipped">
                                                            <i class="fas fa-shipping-fast"></i>
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>`
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="6" class="text-center text-muted py-4">
                                                <i class="fas fa-shopping-cart fa-2x mb-2"></i>
                                                <br>No orders found
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script>
function exportOrders() {
    // Implement export functionality
    alert('Export functionality will be implemented');
}
</script>

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

.border-left-warning {
    border-left: 0.25rem solid #ffc107 !important;
}

.border-left-info {
    border-left: 0.25rem solid #17a2b8 !important;
}

.border-left-success {
    border-left: 0.25rem solid #28a745 !important;
}

@media (max-width: 767.98px) {
    .sidebar {
        top: 5rem;
    }
}
</style>

<jsp:include page="../includes/footer.jsp" />
