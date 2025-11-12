<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../includes/header.jsp" />
<jsp:include page="../includes/topmenu.jsp" />

<div class="container-fluid">
    <div class="row">
        <nav class="col-md-3 col-lg-2 d-md-block bg-dark sidebar collapse">
            <div class="position-sticky pt-3">
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link text-secondary" href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active text-gold" href="${pageContext.request.contextPath}/admin/products">
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

        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2 text-gold">Edit Product</h1>
                <div>
                    <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-outline-secondary">Back to products</a>
                </div>
            </div>

            <div class="card bg-glass mb-4">
                <div class="card-body">
                    <c:if test="${not empty errors}">
                        <div class="alert alert-danger">
                            <ul>
                                <c:forEach var="err" items="${errors.values()}">
                                    <li>${err}</li>
                                </c:forEach>
                            </ul>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/admin/products?action=update" method="post">
                        <input type="hidden" name="id" value="${product.id}" />
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="code" class="form-label text-gold">Product Code</label>
                                <input type="text" id="code" name="code" class="form-control" value="${product.code}" required />
                            </div>
                            <div class="col-md-6">
                                <label for="name" class="form-label text-gold">Name</label>
                                <input type="text" id="name" name="name" class="form-control" value="${product.name}" required />
                            </div>

                            <div class="col-md-6">
                                <label for="price" class="form-label text-gold">Price</label>
                                <input type="number" step="0.01" id="price" name="price" class="form-control" value="${product.price}" required />
                            </div>
                            <div class="col-md-6">
                                <label for="stock" class="form-label text-gold">Stock</label>
                                <input type="number" id="stock" name="stock" class="form-control" value="${product.stock}" required />
                            </div>

                            <div class="col-md-6">
                                <label for="categoryId" class="form-label text-gold">Category</label>
                                <select id="categoryId" name="categoryId" class="form-select" required>
                                    <option value="">Select category</option>
                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat.id}" ${product.categoryId == cat.id ? 'selected' : ''}>${cat.name}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-md-6">
                                <label for="alcoholPercentage" class="form-label text-gold">Alcohol %</label>
                                <input type="number" step="0.1" min="0" max="100" id="alcoholPercentage" name="alcoholPercentage" class="form-control" value="${product.alcoholPercentage}" required />
                            </div>

                            <div class="col-12">
                                <label for="image" class="form-label text-gold">Image filename or URL</label>
                                <input type="text" id="image" name="image" class="form-control" value="${product.image}" placeholder="image.jpg or https://..." />
                            </div>

                            <div class="col-12">
                                <label for="description" class="form-label text-gold">Description</label>
                                <textarea id="description" name="description" rows="6" class="form-control" required>${product.description}</textarea>
                            </div>

                            <div class="col-12 text-end">
                                <button type="submit" class="btn btn-primary">Save Changes</button>
                                <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-outline-secondary ms-2">Cancel</a>
                            </div>
                        </div>
                    </form>
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
</style>

<jsp:include page="../includes/footer.jsp" />

