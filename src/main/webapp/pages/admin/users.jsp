<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../includes/header.jsp" />

<jsp:include page="../includes/topmenu.jsp" />

<!-- Admin Users -->
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
                        <a class="nav-link text-secondary" href="${pageContext.request.contextPath}/admin/orders">
                            <i class="fas fa-shopping-cart me-2"></i>Orders
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active text-gold" href="${pageContext.request.contextPath}/admin/users">
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
                <h1 class="h2 text-gold">User Management</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <div class="btn-group me-2">
                        <button type="button" class="btn btn-outline-primary" onclick="exportUsers()">
                            <i class="fas fa-download me-1"></i>Export
                        </button>
                    </div>
                </div>
            </div>
            
            <!-- User Statistics -->
            <div class="row mb-4">
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card bg-glass border-left-primary shadow h-100 py-2">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-gold text-uppercase mb-1">Total Users</div>
                                    <div class="h5 mb-0 font-weight-bold text-white">${totalUsers}</div>
                                </div>
                                <div class="col-auto">
                                    <i class="fas fa-users fa-2x text-gold"></i>
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
                                    <div class="text-xs font-weight-bold text-gold text-uppercase mb-1">Admins</div>
                                    <div class="h5 mb-0 font-weight-bold text-white">${adminUsers}</div>
                                </div>
                                <div class="col-auto">
                                    <i class="fas fa-user-shield fa-2x text-info"></i>
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
                                    <div class="text-xs font-weight-bold text-gold text-uppercase mb-1">Customers</div>
                                    <div class="h5 mb-0 font-weight-bold text-white">${customerUsers}</div>
                                </div>
                                <div class="col-auto">
                                    <i class="fas fa-user fa-2x text-success"></i>
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
                                    <div class="text-xs font-weight-bold text-gold text-uppercase mb-1">Active Users</div>
                                    <div class="h5 mb-0 font-weight-bold text-white">${activeUsers}</div>
                                </div>
                                <div class="col-auto">
                                    <i class="fas fa-user-check fa-2x text-warning"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Filters -->
            <div class="card bg-glass mb-4">
                <div class="card-body">
                    <form method="get" action="${pageContext.request.contextPath}/admin/users" class="row g-3">
                        <div class="col-md-3">
                            <label for="role" class="form-label text-gold">Role</label>
                            <select class="form-select" id="role" name="role">
                                <option value="">All Roles</option>
                                <option value="ADMIN" ${param.role == 'ADMIN' ? 'selected' : ''}>Admin</option>
                                <option value="CUSTOMER" ${param.role == 'CUSTOMER' ? 'selected' : ''}>Customer</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label for="search" class="form-label text-gold">Search</label>
                            <input type="text" class="form-control" id="search" name="search" 
                                   placeholder="Search users..." value="${param.search}">
                        </div>
                        <div class="col-md-3">
                            <label for="status" class="form-label text-gold">Status</label>
                            <select class="form-select" id="status" name="status">
                                <option value="">All Status</option>
                                <option value="active" ${param.status == 'active' ? 'selected' : ''}>Active</option>
                                <option value="inactive" ${param.status == 'inactive' ? 'selected' : ''}>Inactive</option>
                            </select>
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
            
            <!-- Users Table -->
            <div class="card bg-glass">
                <div class="card-header">
                    <h6 class="m-0 font-weight-bold text-gold">
                        <i class="fas fa-list me-2"></i>Users (${users.size()})
                    </h6>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-dark table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Avatar</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Birth Date</th>
                                    <th>Address</th>
                                    <th>Role</th>
                                    <th>Status</th>
                                    <th>Created</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty users}">
                                        <c:forEach var="user" items="${users}">
                                            <tr>
                                                <td>${user.id}</td>
                                                <td>
                                                    <div class="avatar-circle">
                                                        <i class="fas fa-user"></i>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div>
                                                        <strong>${user.fullname}</strong>
                                                        <br>
                                                        <small class="text-muted">@${user.username}</small>
                                                    </div>
                                                </td>
                                                <td>${user.email}</td>
                                                <td>
                                                        ${user.birthDate}
                                                </td>
                                                <td style="max-width:200px;">
                                                    <small class="text-muted">${user.address}</small>
                                                </td>
                                                <td>
                                                    <span class="badge ${user.role == 'ADMIN' ? 'bg-danger' : 'bg-primary'}">
                                                        ${user.role}
                                                    </span>
                                                </td>
                                                <td>
                                                    <span class="badge ${user.active ? 'bg-success' : 'bg-secondary'}">
                                                        ${user.active ? 'Active' : 'Inactive'}
                                                    </span>
                                                </td>
                                                <td>
                                                        ${user.birthDate}
                                                </td>
                                                <td>
                                                    <div class="btn-group" role="group">
                                                        <a href="${pageContext.request.contextPath}/admin/users?action=view&id=${user.id}" 
                                                           class="btn btn-outline-info btn-sm">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/admin/users?action=edit&id=${user.id}" 
                                                           class="btn btn-outline-primary btn-sm">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <c:if test="${user.role != 'ADMIN' || user.id != sessionScope.currentUser.id}">
                                                            <a href="${pageContext.request.contextPath}/admin/users?action=delete&id=${user.id}" 
                                                               class="btn btn-outline-danger btn-sm"
                                                               onclick="return confirm('Are you sure you want to delete this user?')">
                                                                <i class="fas fa-trash"></i>
                                                            </a>
                                                        </c:if>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="10" class="text-center text-muted py-4">
                                                <i class="fas fa-users fa-2x mb-2"></i>
                                                <br>No users found
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
function exportUsers() {
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

.border-left-info {
    border-left: 0.25rem solid #17a2b8 !important;
}

.border-left-success {
    border-left: 0.25rem solid #28a745 !important;
}

.border-left-warning {
    border-left: 0.25rem solid #ffc107 !important;
}

.avatar-circle {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background: var(--gradient-gold);
    display: flex;
    align-items: center;
    justify-content: center;
    color: var(--text-dark);
    font-size: 1.2rem;
}

@media (max-width: 767.98px) {
    .sidebar {
        top: 5rem;
    }
}
</style>

<jsp:include page="../includes/footer.jsp" />
