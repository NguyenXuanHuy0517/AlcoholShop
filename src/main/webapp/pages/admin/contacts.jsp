<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:include page="../includes/header.jsp" />
<jsp:include page="../includes/topmenu.jsp" />

<!-- Admin Contacts -->
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <nav class="col-md-3 col-lg-2 d-md-block bg-dark sidebar collapse">
            <div class="position-sticky pt-3">
                <ul class="nav flex-column">
                    <li class="nav-item"><a class="nav-link text-secondary" href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-tachometer-alt me-2"></i>Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link text-secondary" href="${pageContext.request.contextPath}/admin/products"><i class="fas fa-box me-2"></i>Products</a></li>
                    <li class="nav-item"><a class="nav-link text-secondary" href="${pageContext.request.contextPath}/admin/orders"><i class="fas fa-shopping-cart me-2"></i>Orders</a></li>
                    <li class="nav-item"><a class="nav-link text-secondary" href="${pageContext.request.contextPath}/admin/users"><i class="fas fa-users me-2"></i>Users</a></li>
                    <li class="nav-item"><a class="nav-link active text-gold" href="${pageContext.request.contextPath}/admin/contacts"><i class="fas fa-envelope me-2"></i>Messages</a></li>
                </ul>
            </div>
        </nav>

        <!-- Main content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2 text-gold">Contact Messages</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <div class="btn-group me-2">
                        <button type="button" class="btn btn-outline-primary" onclick="exportMessages()">
                            <i class="fas fa-download me-1"></i>Export
                        </button>
                    </div>
                </div>
            </div>

            <!-- Message Statistics -->
            <div class="row mb-4">
                <c:forEach var="stat" items="${stats}">
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card bg-glass border-left-${stat.color} shadow h-100 py-2">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-gold text-uppercase mb-1">${stat.label}</div>
                                        <div class="h5 mb-0 font-weight-bold text-white">${stat.value}</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="${stat.icon} fa-2x text-${stat.color}"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- Filters -->
            <div class="card bg-glass mb-4">
                <div class="card-body">
                    <form method="get" action="${pageContext.request.contextPath}/admin/contacts" class="row g-3">
                        <div class="col-md-3">
                            <label for="email" class="form-label text-gold">Email</label>
                            <input type="email" class="form-control" id="email" name="email" placeholder="Search by email..." value="${param.email}">
                        </div>
                        <div class="col-md-3">
                            <label for="status" class="form-label text-gold">Status</label>
                            <select class="form-select" id="status" name="status">
                                <option value="">All Status</option>
                                <option value="NEW" ${param.status == 'NEW' ? 'selected' : ''}>New</option>
                                <option value="READ" ${param.status == 'READ' ? 'selected' : ''}>Read</option>
                                <option value="REPLIED" ${param.status == 'REPLIED' ? 'selected' : ''}>Replied</option>
                            </select>
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

            <!-- Messages Table -->
            <div class="card bg-glass">
                <div class="card-header">
                    <h6 class="m-0 font-weight-bold text-gold">
                        <i class="fas fa-list me-2"></i>Messages (<c:out value="${fn:length(messages)}"/>)
                    </h6>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-dark table-hover mb-0">
                            <thead>
                            <tr>
                                <th>ID</th><th>Name</th><th>Email</th><th>Subject</th><th>Message</th><th>Date</th><th>Status</th><th>Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty messages}">
                                    <c:forEach var="message" items="${messages}">
                                        <tr>
                                            <td><c:out value="${message.id}"/></td>
                                            <td><strong><c:out value="${message.name}"/></strong></td>
                                            <td><a href="mailto:${message.email}" class="text-gold"><c:out value="${message.email}"/></a></td>
                                            <td><strong><c:out value="${message.subject}"/></strong></td>
                                            <td>
                                                <div class="message-preview">
                                                    <c:choose>
                                                        <c:when test="${fn:length(message.message) > 50}">
                                                            <c:out value="${fn:substring(message.message, 0, 50)}"/>...
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:out value="${message.message}"/>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty message.createdAtAsDate}">
                                                        <fmt:formatDate value="${message.createdAtAsDate}" pattern="MMM dd, yyyy" />
                                                        <br><small class="text-muted"><fmt:formatDate value="${message.createdAtAsDate}" pattern="HH:mm" /></small>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">-</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty message.status}">
                                                        <c:choose>
                                                            <c:when test="${fn:toUpperCase(message.status) == 'NEW'}">
                                                                <span class="badge bg-warning"><c:out value="${message.status}"/></span>
                                                            </c:when>
                                                            <c:when test="${fn:toUpperCase(message.status) == 'READ'}">
                                                                <span class="badge bg-info"><c:out value="${message.status}"/></span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-success"><c:out value="${message.status}"/></span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">UNKNOWN</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="btn-group" role="group">
                                                    <a href="${pageContext.request.contextPath}/admin/contacts?action=view&id=${message.id}" class="btn btn-outline-info btn-sm"><i class="fas fa-eye"></i></a>
                                                    <a href="mailto:${message.email}?subject=Re: ${message.subject}" class="btn btn-outline-primary btn-sm"><i class="fas fa-reply"></i></a>
                                                    <a href="${pageContext.request.contextPath}/admin/contacts?action=delete&id=${message.id}" class="btn btn-outline-danger btn-sm" onclick="return confirm('Are you sure you want to delete this message?')"><i class="fas fa-trash"></i></a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="8" class="text-center text-muted py-4">
                                            <i class="fas fa-envelope fa-2x mb-2"></i><br>No messages found
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
    function exportMessages() {
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

    .message-preview {
        max-width: 200px;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
    }

    @media (max-width: 767.98px) {
        .sidebar {
            top: 5rem;
        }
    }
</style>

<jsp:include page="../includes/footer.jsp" />
