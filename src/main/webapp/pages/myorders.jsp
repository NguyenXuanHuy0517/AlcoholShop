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
                                        <a class="btn btn-sm btn-outline-primary" href="${pageContext.request.contextPath}/order-detail?id=${order.id}">View</a>
                                    </td>
                                </tr>
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

<jsp:include page="/pages/includes/footer.jsp" />
