<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="includes/header.jsp" />
<jsp:include page="includes/topmenu.jsp" />

<!-- Contact Section -->
<section class="py-5">
    <div class="container">
        <div class="row">
            <div class="col-12">
                <h1 class="display-4 fw-bold text-gold mb-4" data-aos="fade-up">
                    <i class="fas fa-envelope me-3"></i>Contact Us
                </h1>
                <p class="lead text-secondary mb-5" data-aos="fade-up" data-aos-delay="200">
                    We'd love to hear from you. Send us a message and we'll respond as soon as possible.
                </p>
            </div>
        </div>

        <div class="row">
            <!-- Contact Form -->
            <div class="col-lg-8">
                <div class="card bg-glass mb-4">
                    <div class="card-header">
                        <h5 class="mb-0 text-gold">
                            <i class="fas fa-paper-plane me-2"></i>Send us a Message
                        </h5>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger" data-aos="fade-up">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                <c:out value="${error}" />
                            </div>
                        </c:if>

                        <c:if test="${not empty success}">
                            <div class="alert alert-success" data-aos="fade-up">
                                <i class="fas fa-check-circle me-2"></i>
                                <c:out value="${success}" />
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/contact" method="post" id="contactForm">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="name" class="form-label text-gold">Full Name *</label>
                                    <input type="text" class="form-control" id="name" name="name" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="email" class="form-label text-gold">Email Address *</label>
                                    <input type="email" class="form-control" id="email" name="email" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="subject" class="form-label text-gold">Subject *</label>
                                <input type="text" class="form-control" id="subject" name="subject" required>
                            </div>

                            <div class="mb-3">
                                <label for="message" class="form-label text-gold">Message *</label>
                                <textarea class="form-control" id="message" name="message" rows="6" required></textarea>
                            </div>

                            <div class="form-check mb-4">
                                <input class="form-check-input" type="checkbox" id="ageConfirm" required>
                                <label class="form-check-label text-gold" for="ageConfirm">
                                    I confirm that I am 18 years of age or older
                                </label>
                            </div>

                            <div class="d-grid">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="fas fa-paper-plane me-2"></i>Send Message
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Contact Information -->
            <div class="col-lg-4">
                <div class="card bg-glass mb-4">
                    <div class="card-header">
                        <h5 class="mb-0 text-gold">
                            <i class="fas fa-info-circle me-2"></i>Contact Information
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="contact-item mb-4">
                            <div class="d-flex align-items-center">
                                <div class="contact-icon me-3">
                                    <i class="fas fa-map-marker-alt fa-2x text-gold"></i>
                                </div>
                                <div>
                                    <h6 class="text-gold mb-1">Address</h6>
                                    <p class="text-secondary mb-0">
                                        UNETI<br>
                                        ngõ 218, đường Lĩnh Nam<br>
                                        Hoàng Mai, Hà Nội
                                    </p>
                                </div>
                            </div>
                        </div>

                        <div class="contact-item mb-4">
                            <div class="d-flex align-items-center">
                                <div class="contact-icon me-3">
                                    <i class="fas fa-phone fa-2x text-gold"></i>
                                </div>
                                <div>
                                    <h6 class="text-gold mb-1">Phone</h6>
                                    <p class="text-secondary mb-0">
                                        (+84)868686868<br>
                                        Mon-Fri: 9AM-6PM
                                    </p>
                                </div>
                            </div>
                        </div>

                        <div class="contact-item mb-4">
                            <div class="d-flex align-items-center">
                                <div class="contact-icon me-3">
                                    <i class="fas fa-envelope fa-2x text-gold"></i>
                                </div>
                                <div>
                                    <h6 class="text-gold mb-1">Email</h6>
                                    <p class="text-secondary mb-0">
                                        3anhemsieunhan@alcoholshop.com<br>
                                        support@alcoholshop.com
                                    </p>
                                </div>
                            </div>
                        </div>

                        <div class="contact-item">
                            <div class="d-flex align-items-center">
                                <div class="contact-icon me-3">
                                    <i class="fas fa-clock fa-2x text-gold"></i>
                                </div>
                                <div>
                                    <h6 class="text-gold mb-1">Business Hours</h6>
                                    <p class="text-secondary mb-0">
                                        Monday - Friday: 9:00 AM - 6:00 PM<br>
                                        Saturday: 10:00 AM - 4:00 PM<br>
                                        Sunday: Closed
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Social Media -->
                <div class="card bg-glass">
                    <div class="card-header">
                        <h5 class="mb-0 text-gold">
                            <i class="fas fa-share-alt me-2"></i>Follow Us
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="social-links">
                            <a href="#" class="social-link"><i class="fab fa-facebook-f"></i></a>
                            <a href="#" class="social-link"><i class="fab fa-twitter"></i></a>
                            <a href="#" class="social-link"><i class="fab fa-instagram"></i></a>
                            <a href="#" class="social-link"><i class="fab fa-linkedin-in"></i></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const contactForm = document.getElementById('contactForm');
        if (!contactForm) return;

        contactForm.addEventListener('submit', function(e) {
            const ageConfirm = document.getElementById('ageConfirm');
            if (!ageConfirm?.checked) {
                e.preventDefault();
                alert('You must confirm that you are 18 years of age or older.');
                return;
            }

            const submitBtn = this.querySelector('button[type="submit"]');
            if (submitBtn) {
                const originalText = submitBtn.innerHTML;
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Sending...';
                submitBtn.disabled = true;

                setTimeout(() => {
                    submitBtn.innerHTML = originalText;
                    submitBtn.disabled = false;
                }, 4000);
            }
        });
    });
</script>

<style>
    .contact-item {
        padding: 1rem 0;
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    }

    .contact-item:last-child {
        border-bottom: none;
    }

    .contact-icon {
        width: 50px;
        height: 50px;
        display: flex;
        align-items: center;
        justify-content: center;
        background: rgba(212, 175, 55, 0.1);
        border-radius: 50%;
    }

    .social-links {
        display: flex;
        gap: 1rem;
        justify-content: center;
    }

    .social-link {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        width: 45px;
        height: 45px;
        background: rgba(255, 255, 255, 0.1);
        color: var(--text-secondary);
        border-radius: 50%;
        transition: var(--transition-normal);
        text-decoration: none;
    }

    .social-link:hover {
        background: var(--gradient-gold);
        color: var(--text-dark);
        transform: translateY(-3px);
        box-shadow: var(--shadow-gold);
    }
</style>

<jsp:include page="includes/footer.jsp" />
