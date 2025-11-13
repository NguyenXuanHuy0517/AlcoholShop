<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../includes/header.jsp" />
<jsp:include page="../includes/topmenu.jsp" />

<div class="container py-4">
    <div class="row">
        <div class="col-md-10 offset-md-1">
            <div class="card bg-glass mb-4">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0 text-gold">Contact Message Details</h5>
                </div>
                <div class="card-body">
                    <c:if test="${not empty message}">
                        <dl class="row">
                            <dt class="col-sm-3">ID</dt>
                            <dd class="col-sm-9">${message.id}</dd>

                            <dt class="col-sm-3">Name</dt>
                            <dd class="col-sm-9">${message.name}</dd>

                            <dt class="col-sm-3">Email</dt>
                            <dd class="col-sm-9"><a href="mailto:${message.email}">${message.email}</a></dd>

                            <dt class="col-sm-3">Phone</dt>
                            <dd class="col-sm-9">${message.phone}</dd>

                            <dt class="col-sm-3">Subject</dt>
                            <dd class="col-sm-9">${message.subject}</dd>

                            <dt class="col-sm-3">Message</dt>
                            <dd class="col-sm-9" style="white-space:pre-wrap;">${message.message}</dd>

                            <dt class="col-sm-3">Received</dt>
                            <dd class="col-sm-9">
                                <c:choose>
                                    <c:when test="${not empty message.createdAtAsDate}">
                                        <fmt:formatDate value="${message.createdAtAsDate}" pattern="MMM dd, yyyy HH:mm" />
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">-</span>
                                    </c:otherwise>
                                </c:choose>
                            </dd>
                        </dl>
                    </c:if>
                    <c:if test="${empty message}">
                        <div class="alert alert-warning">Message not found.</div>
                    </c:if>
                </div>
                <div class="card-footer">
                    <a href="${pageContext.request.contextPath}/admin/contacts" class="btn btn-outline-secondary">Back to Messages</a>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../includes/footer.jsp" />
