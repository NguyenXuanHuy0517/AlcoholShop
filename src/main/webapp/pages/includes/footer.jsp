<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!-- Footer: categories removed, layout redistributed -->
<footer class="bg-dark text-light py-5 mt-5 footer-with-beige">
    <div class="container">
        <div class="row gy-4 align-items-start">
            <!-- Company Info (left) -->
            <div class="col-lg-4 col-md-12">
                <h5 class="fw-bold mb-3">
                    <i class="fas fa-wine-bottle me-2"></i>AlcoholShop
                </h5>
                <p class="text-muted mb-3">
                    Your premium destination for fine spirits, wines, and craft beverages.
                    We offer the finest selection for discerning customers.
                </p>

                <div class="mb-3">
                    <a href="#" class="text-light me-3" aria-label="facebook"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="text-light me-3" aria-label="twitter"><i class="fab fa-twitter"></i></a>
                    <a href="#" class="text-light me-3" aria-label="instagram"><i class="fab fa-instagram"></i></a>
                    <a href="#" class="text-light" aria-label="linkedin"><i class="fab fa-linkedin-in"></i></a>
                </div>

                <p class="small text-muted mb-0">
                    <i class="fas fa-map-marker-alt me-2"></i>UNETI, ngõ 218, đường Lĩnh Nam, Hoàng Mai, Hà Nội
                </p>
            </div>

            <!-- Quick Links (center) -->
            <div class="col-lg-3 col-md-6">
                <h6 class="fw-bold mb-3">Quick Links</h6>
                <ul class="list-unstyled">
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/" class="link-muted text-decoration-none">
                            <i class="fas fa-home me-2"></i>Home
                        </a>
                    </li>
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/products" class="link-muted text-decoration-none">
                            <i class="fas fa-store me-2"></i>Products
                        </a>
                    </li>
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/contact" class="link-muted text-decoration-none">
                            <i class="fas fa-envelope me-2"></i>Contact
                        </a>
                    </li>
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/about" class="link-muted text-decoration-none">
                            <i class="fas fa-info-circle me-2"></i>About Us
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Contact Info (right) -->
            <div class="col-lg-5 col-md-6">
                <h6 class="fw-bold mb-3">Contact Information</h6>

                <ul class="list-unstyled contact-list">
                    <li class="mb-2 text-muted">
                        <i class="fas fa-phone me-2"></i>+84 868686868
                    </li>
                    <li class="mb-2 text-muted">
                        <i class="fas fa-envelope me-2"></i>3anhemsieunhan@alcoholshop.com
                    </li>
                    <li class="mb-2 text-muted">
                        <i class="fas fa-clock me-2"></i>Mon-Fri: 9AM-6PM, Sat: 10AM-4PM
                    </li>
                </ul>

                <!-- small map / CTA placeholder (keeps layout đầy đặn) -->
                <div class="mt-3">
                    <a href="${pageContext.request.contextPath}/contact" class="btn btn-outline-light btn-sm">
                        <i class="fas fa-directions me-2"></i>Get directions
                    </a>
                </div>
            </div>
        </div>

        <hr class="my-4 border-secondary">

        <!-- Bottom row: copyright + team + legal -->
        <div class="row align-items-center gy-2">
            <div class="col-md-6">
                <p class="text-muted mb-0 small">&copy; 2025 AlcoholShop. All rights reserved.</p>
            </div>

            <div class="col-md-6 text-md-end">
                <p class="text-muted mb-1 small">
                    <i class="fas fa-exclamation-triangle me-1"></i>Must be 18+ to purchase. Please drink responsibly.
                </p>
            </div>

            <!-- Development Team (full width under on small screens) -->
            <div class="col-12">
                <div class="d-flex flex-column flex-sm-row justify-content-between align-items-start align-items-sm-center gap-2">
                    <div>
                        <small class="text-muted">
                            <i class="fas fa-code me-2"></i>
                            Development Team:
                        </small>
                        <div class="small text-light">
                            Phùng Tuấn Anh, Nguyễn Xuân Huy, Nguyễn Xuân Ngọc Long
                        </div>
                    </div>

                    <div class="text-sm-end">
                        <small class="text-muted">
                            <i class="fas fa-calendar me-1"></i>
                            Project completed on:
                        </small>
                        <div class="small text-muted">
                            <fmt:formatDate value="<%=new java.util.Date()%>" pattern="dd/MM/yyyy" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<!-- AOS Animation Library -->
<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<!-- Custom JS -->
<script src="${pageContext.request.contextPath}/static/js/scripts.js"></script>

<script>
    AOS.init({
        duration: 1000,
        easing: 'ease-in-out',
        once: true,
        offset: 100
    });
</script>

<!-- Optional: small CSS tweak để text-muted thành tone be (không đổi global) -->
<style>
    /* chỉ áp dụng cho footer này, an toàn hơn là thay toàn cục */
    .footer-with-beige {
        --footer-muted: #D9C49C; /* tone be bạn thích */
    }
    .footer-with-beige .text-muted,
    .footer-with-beige .link-muted,
    .footer-with-beige .contact-list .text-muted {
        color: var(--footer-muted) !important;
        opacity: 1;
    }
    /* link hover */
    .footer-with-beige .link-muted:hover {
        color: #fff !important;
    }
    /* nhỏ gọn trên mobile */
    @media (max-width: 576px) {
        .footer-with-beige .contact-list li { font-size: .95rem; }
    }
</style>
