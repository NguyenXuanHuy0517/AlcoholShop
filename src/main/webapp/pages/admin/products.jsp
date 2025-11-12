<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:include page="../includes/header.jsp" />

<jsp:include page="../includes/topmenu.jsp" />

<!-- Admin Products -->
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
        
        <!-- Main content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2 text-gold">Product Management</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <div class="btn-group me-2">
                        <a href="${pageContext.request.contextPath}/admin/products?action=add" class="btn btn-primary">
                            <i class="fas fa-plus me-1"></i>Add Product
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- Filters -->
            <div class="card bg-glass mb-4">
                <div class="card-body">
                    <form id="filterForm" method="get" action="${pageContext.request.contextPath}/admin/products" class="row g-3">
                        <div class="col-md-3">
                            <label for="category" class="form-label text-gold">Category</label>
                            <select class="form-select" id="category" name="category">
                                <option value="">All Categories</option>
                                <c:forEach var="category" items="${categories}">
                                    <option value="${category.id}" <c:if test="${param.category == category.id}">selected</c:if>>
                                        ${category.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label for="search" class="form-label text-gold">Search</label>
                            <input type="text" class="form-control" id="search" name="search" 
                                   placeholder="Search products..." value="${param.search}">
                        </div>
                        <div class="col-md-3">
                            <label for="status" class="form-label text-gold">Status</label>
                            <select class="form-select" id="status" name="status">
                                <option value="">All Status</option>
                                <option value="active" <c:if test="${param.status == 'active'}">selected</c:if>>Active</option>
                                <option value="inactive" <c:if test="${param.status == 'inactive'}">selected</c:if>>Inactive</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">&nbsp;</label>
                            <div class="d-grid">
                                <button id="filterButton" type="button" class="btn btn-outline-primary">
                                    <i class="fas fa-search me-1"></i>Filter
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            
            <!-- Products Table -->
            <div class="card bg-glass">
                <div class="card-header">
                    <h6 class="m-0 font-weight-bold text-gold">
                        <i class="fas fa-list me-2"></i>Products (<span id="productCount">${totalProducts}</span>)
                    </h6>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-dark table-hover mb-0" id="productsTable">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Image</th>
                                    <th>Name</th>
                                    <th>Description</th>
                                    <th>Category</th>
                                    <th>Price</th>
                                    <th>Alcohol %</th>
                                    <th>Created</th>
                                    <th>Stock</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="product" items="${products}">
                                    <tr class="product-row"
                                        data-id="${product.id}"
                                        data-name="${fn:toLowerCase(product.name)}"
                                        data-code="${fn:toLowerCase(product.code)}"
                                        data-desc="${fn:toLowerCase(product.description)}"
                                        data-category-id="${product.categoryId}"
                                        data-stock="${product.stock}"
                                        data-status="${product.active ? 'active' : 'inactive'}">
                                        <td>${product.id}</td>
                                        <td>
                                            <img src="${pageContext.request.contextPath}/static/images/products/${product.image}"
                                                 alt="${product.name}" class="img-thumbnail" style="width: 50px; height: 50px; object-fit: cover;"
                                                 onerror="this.src='https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?ixlib=rb-4.0.3&auto=format&fit=crop&w=100&q=80'">
                                        </td>
                                        <td>
                                            <div>
                                                <strong>${product.name}</strong>
                                                <br>
                                                <small class="text-muted">${product.code}</small>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="text-truncate" style="max-width:300px;">
                                                <small class="text-muted">
                                                    ${product.description != null && product.description.length() > 80 ? product.description.substring(0,80) + '...' : product.description}
                                                </small>
                                            </div>
                                        </td>
                                        <td>${product.categoryName}</td>
                                        <td class="text-gold">
                                            <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="$" />
                                        </td>
                                        <td>
                                            <fmt:formatNumber value="${product.alcoholPercentage}" pattern="#0.0" />%
                                        </td>
                                        <td>
                                                ${product.createdAt.toLocalDate()}

                                        </td>
                                        <td>
                                            <span class="badge ${product.stock > 0 ? 'bg-success' : 'bg-danger'}">
                                                ${product.stock}
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge ${product.active ? 'bg-success' : 'bg-secondary'}">
                                                ${product.active ? 'Active' : 'Inactive'}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="btn-group" role="group">
                                                <a href="${pageContext.request.contextPath}/admin/products?action=edit&id=${product.id}"
                                                   class="btn btn-outline-primary btn-sm">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/product?id=${product.id}"
                                                   class="btn btn-outline-info btn-sm" target="_blank">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/products?action=delete&id=${product.id}"
                                                   class="btn btn-outline-danger btn-sm"
                                                   onclick="return confirm('Are you sure you want to delete this product?')">
                                                    <i class="fas fa-trash"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>

                                <!-- Always present hidden row shown when no products match client filters -->
                                <tr id="noProductsRow" style="display: none;">
                                    <td colspan="11" class="text-center text-muted py-4">
                                        <i class="fas fa-box fa-2x mb-2"></i>
                                        <br>No products found
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script>
    (function() {
        // Utilities
        function qs(selector, root) { return (root || document).querySelector(selector); }
        function qsa(selector, root) { return Array.prototype.slice.call((root || document).querySelectorAll(selector)); }

        var filterForm = qs('#filterForm');
        var categoryEl = qs('#category');
        var searchEl = qs('#search');
        var statusEl = qs('#status');
        var filterButton = qs('#filterButton');
        var productRows = qsa('.product-row');
        var productCountEl = qs('#productCount');
        var noProductsRow = qs('#noProductsRow');

        function normalize(str) {
            return (str || '').toLowerCase();
        }

        function filterProducts() {
            var category = categoryEl.value;
            var search = normalize(searchEl.value || '');
            var status = statusEl.value;

            var visible = 0;

            productRows.forEach(function(row) {
                var name = row.getAttribute('data-name') || '';
                var code = row.getAttribute('data-code') || '';
                var desc = row.getAttribute('data-desc') || '';
                var catId = row.getAttribute('data-category-id') || '';
                var stock = parseInt(row.getAttribute('data-stock') || '0', 10);
                var rowStatus = row.getAttribute('data-status') || (stock > 0 ? 'active' : 'inactive');

                var matchesCategory = !category || category === '' || String(catId) === String(category);
                var matchesStatus = !status || status === '' || rowStatus === status;
                var matchesSearch = !search || name.indexOf(search) !== -1 || code.indexOf(search) !== -1 || desc.indexOf(search) !== -1;

                if (matchesCategory && matchesStatus && matchesSearch) {
                    row.style.display = '';
                    visible++;
                } else {
                    row.style.display = 'none';
                }
            });

            productCountEl.textContent = visible;

            if (noProductsRow) {
                if (visible === 0) {
                    noProductsRow.style.display = '';
                } else {
                    noProductsRow.style.display = 'none';
                }
            }
        }

        // Bind events
        filterButton.addEventListener('click', function(e) {
            e.preventDefault();
            filterProducts();
        });

        // Live search: debounce
        var debounceTimer;
        searchEl.addEventListener('input', function() {
            clearTimeout(debounceTimer);
            debounceTimer = setTimeout(filterProducts, 250);
        });

        categoryEl.addEventListener('change', filterProducts);
        statusEl.addEventListener('change', filterProducts);

        // Initial run (apply any params present)
        // If server sent totalProducts, productCountEl is set; but websocket this will compute actual visible
        filterProducts();
    })();
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

@media (max-width: 767.98px) {
    .sidebar {
        top: 5rem;
    }
}
</style>

<jsp:include page="../includes/footer.jsp" />
