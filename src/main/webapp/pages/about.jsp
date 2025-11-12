<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>About Us | AlcoholShop</title>

    <!-- Bootstrap + AOS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">

    <!-- Custom CSS -->
    <style>
        body {
            background-color: #1e1e1e;
            color: #f5f5dc; /* màu be */
            font-family: 'Poppins', sans-serif;
        }
        h1, h3, h5 {
            color: #d9b26c; /* vàng đồng */
        }
        .text-muted {
            color: #d9c49c !important;
        }
        .section-title {
            letter-spacing: 1px;
            font-weight: 700;
        }
        .card {
            background-color: #2a2a2a;
            border: 1px solid #3b3b3b;
            transition: all 0.3s ease;
        }
        .card:hover {
            transform: translateY(-5px);
            border-color: #d9b26c;
        }
        .btn-outline-light {
            border-color: #d9b26c;
            color: #d9b26c;
        }
        .btn-outline-light:hover {
            background-color: #d9b26c;
            color: #1e1e1e;
        }
        hr {
            border-color: #d9b26c;
        }
    </style>
</head>

<body>

<!-- HEADER -->
<jsp:include page="/pages/includes/header.jsp" />
<jsp:include page="/pages/includes/topmenu.jsp" />
<!-- MAIN CONTENT -->
<main class="container py-5 mt-5" data-aos="fade-up">

    <!-- Intro -->
    <section class="text-center mb-5">
        <h1 class="section-title mb-3 text-uppercase">
            About Our Project
        </h1>
        <p class="lead text-muted mx-auto" style="max-width: 750px;">
            AlcoholShop là đồ án môn học của nhóm 3 thành viên, được phát triển với mục tiêu tạo ra
            một nền tảng thương mại điện tử hiện đại chuyên cung cấp các loại rượu cao cấp,
            mang lại trải nghiệm tinh tế và thuận tiện cho người dùng.
        </p>
    </section>

    <!-- Project Goals -->
    <section class="row align-items-center mb-5" data-aos="fade-right">
        <div class="col-lg-6 mb-4 mb-lg-0">
            <img src="${pageContext.request.contextPath}/static/images/about.jpg" alt="Wine Shop" class="img-fluid rounded shadow">
        </div>
        <div class="col-lg-6">
            <h3 class="fw-bold mb-3">Mục tiêu của dự án</h3>
            <p class="text-muted">
                Dự án “AlcoholShop” mô phỏng hệ thống bán hàng trực tuyến, nơi khách hàng có thể duyệt,
                tìm kiếm và đặt mua các sản phẩm rượu đa dạng. Đồng thời, trang web cung cấp
                công cụ quản trị sản phẩm, đơn hàng, và người dùng cho admin.
            </p>
            <ul class="text-muted">
                <li>Giao diện hiện đại, hiển thị tốt trên mọi thiết bị.</li>
                <li>Giỏ hàng, thanh toán, đăng ký & đăng nhập tài khoản.</li>
                <li>Trang quản trị dễ dùng, trực quan.</li>
                <li>Công nghệ: Java Servlet/JSP, Bootstrap, MySQL.</li>
            </ul>
        </div>
    </section>

    <!-- Tech Stack -->
    <section class="text-center mb-5" data-aos="fade-up">
        <h3 class="fw-bold mb-4">Công nghệ sử dụng</h3>
        <div class="row justify-content-center text-muted">
            <div class="col-md-3 col-6 mb-3">
                <i class="fab fa-java fa-2x mb-2 text-light"></i>
                <p>Java Servlet & JSP</p>
            </div>
            <div class="col-md-3 col-6 mb-3">
                <i class="fas fa-database fa-2x mb-2 text-light"></i>
                <p>MySQL Database</p>
            </div>
            <div class="col-md-3 col-6 mb-3">
                <i class="fab fa-bootstrap fa-2x mb-2 text-light"></i>
                <p>Bootstrap 5</p>
            </div>
            <div class="col-md-3 col-6 mb-3">
                <i class="fas fa-code fa-2x mb-2 text-light"></i>
                <p>HTML, CSS, JS</p>
            </div>
        </div>
    </section>

    <!-- Team Members -->
    <section class="text-center" data-aos="fade-up">
        <h3 class="fw-bold mb-4">Nhóm phát triển</h3>
        <div class="row justify-content-center">
            <div class="col-md-4 mb-4">
                <div class="card text-light h-100">
                    <div class="card-body">
                        <h5 class="fw-bold">Nguyễn Xuân Huy</h5>
                        <p class="text-muted">Leader & Backend Developer</p>
                        <p class="small text-muted">Xây dựng logic hệ thống, quản lý cấu trúc project, kết nối cơ sở dữ liệu.</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card text-light h-100">
                    <div class="card-body">
                        <h5 class="fw-bold">Phùng Tuấn Anh</h5>
                        <p class="text-muted">Frontend Developer</p>
                        <p class="small text-muted">Thiết kế giao diện, phối màu, bố cục, và tối ưu trải nghiệm người dùng.</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card text-light h-100">
                    <div class="card-body">
                        <h5 class="fw-bold">Nguyễn Xuân Ngọc Long</h5>
                        <p class="text-muted">Database & Testing</p>
                        <p class="small text-muted">Thiết kế, tối ưu cơ sở dữ liệu và kiểm thử toàn bộ chức năng website.</p>
                    </div>
                </div>
            </div>
        </div>

        <p class="text-muted mt-4">
            <i class="fas fa-calendar-alt me-2"></i>
            Project completed on:
            <fmt:formatDate value="<%=new java.util.Date()%>" pattern="dd/MM/yyyy" />
        </p>
    </section>

</main>

<!-- FOOTER -->
<jsp:include page="/pages/includes/footer.jsp" />

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script src="https://kit.fontawesome.com/a2d9a64e56.js" crossorigin="anonymous"></script>
<script>
    AOS.init({ duration: 1000, easing: 'ease-in-out', once: true, offset: 100 });
</script>
</body>
</html>
