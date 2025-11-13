<%@ page import="com.example.alcoholshop.dao.OrderDAO" %>
<%@ page import="com.example.alcoholshop.dao.impl.OrderDAOImpl" %>
<%@ page import="com.example.alcoholshop.model.Order" %>
<%@ page import="com.example.alcoholshop.model.UserAccount" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    // Ensure user is logged in
    UserAccount currentUser = (UserAccount) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    OrderDAO orderDAO = new OrderDAOImpl();
    java.util.List<Order> orders = orderDAO.findByUserId(currentUser.getId());
    request.setAttribute("orders", orders);
%>

<jsp:include page="/pages/includes/header.jsp" />
<jsp:include page="/pages/includes/topmenu.jsp" />

<div class="container mt-4">
    <div class="row">
        <div class="col-12">
            <h2>My Orders</h2>
            <p class="text-muted">Hello, <strong><c:out value="${sessionScope.currentUser.fullname}"/></strong>. Here are your orders.</p>

            <c:if test="${not empty orders}">
                <div class="table-responsive">
                    <table class="table table-dark table-hover">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Date</th>
                                <th>Total</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${orders}">
                                <tr>
                                    <td>#${order.id}</td>
                                    <td><fmt:formatDate value="${order.orderDate}" pattern="MMM dd, yyyy HH:mm"/></td>
                                    <td class="text-gold"><fmt:formatNumber value="${order.total}" type="currency" currencySymbol="$"/></td>
                                    <td>
                                        <span class="badge ${order.status == 'PENDING' ? 'bg-warning' : order.status == 'CONFIRMED' ? 'bg-info' : order.status == 'SHIPPED' ? 'bg-primary' : order.status == 'DELIVERED' ? 'bg-success' : order.status == 'COMPLETE' ? 'bg-secondary' : 'bg-danger'}">
                                            ${order.status}
                                        </span>
                                    </td>
                                    <td>
                                        <button type="button" class="btn btn-sm btn-outline-primary" onclick="showOrderModal(${order.id})">View</button>
                                    </td>
                                </tr>
                                <!-- Hidden order detail container for modal population -->
                                <div id="order-detail-${order.id}" class="d-none order-detail-data">
                                    <div class="p-3">
                                        <h5 class="text-gold">Order #${order.id}</h5>
                                        <p class="mb-1"><strong>Date:</strong> <fmt:formatDate value="${order.orderDate}" pattern="MMM dd, yyyy HH:mm"/></p>
                                        <p class="mb-1"><strong>Total:</strong> <fmt:formatNumber value="${order.total}" type="currency" currencySymbol="$"/></p>
                                        <p class="mb-2"><strong>Status:</strong> <span class="badge bg-info">${order.status}</span></p>

                                        <h6 class="mt-3">Items</h6>
                                        <ul>
                                            <c:forEach var="item" items="${order.orderItems}">
                                                <li><c:out value="${item.productName}"/> x <c:out value="${item.quantity}"/> - <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="$"/></li>
                                            </c:forEach>
                                        </ul>

                                        <hr/>
                                        <p class="mb-0"><strong>Contact email:</strong></p>
                                        <p class="small text-muted mb-0">${order.userEmail}</p>
                                    </div>
                                </div>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>
            <c:if test="${empty orders}">
                <div class="alert alert-info">You don't have any orders yet.</div>
            </c:if>
        </div>
    </div>
</div>

<!-- Order Details Modal (reused) -->
<div class="modal fade" id="orderDetailsModal" tabindex="-1" aria-labelledby="orderDetailsModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content bg-dark text-white">
            <div class="modal-header bg-gold text-dark">
                <h5 class="modal-title" id="orderDetailsModalLabel">Order Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="orderDetailsBody">
                <!-- Content populated by JS -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button>
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Go to Home</a>
            </div>
        </div>
    </div>
</div>

<script>
    function showOrderModal(orderId) {
        var container = document.getElementById('order-detail-' + orderId);
        var body = document.getElementById('orderDetailsBody');
        if (container && body) {
            body.innerHTML = container.innerHTML;
            var modalEl = document.getElementById('orderDetailsModal');
            var modal = new bootstrap.Modal(modalEl);
            modal.show();
        } else {
            // Fallback: redirect to detail page
            window.location.href = '${pageContext.request.contextPath}/order-detail?id=' + orderId;
        }
    }
</script>

<jsp:include page="/pages/includes/footer.jsp" />
