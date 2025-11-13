TUTORIAL - AlcoholShop (Tiếng Việt)
===================================

Mục tiêu
--------
Tài liệu này mô tả cấu trúc dự án Java Web "AlcoholShop", chức năng của các file/danh mục chính, cách các servlet liên kết tới JSP, giải thích các servlet quan trọng, cách hoạt động của JSP (EL, JSTL), và mô tả ngắn về JS/CSS dùng trong project. Cuối tài liệu có những lưu ý về lỗi thường gặp (ví dụ LocalDateTime vs java.util.Date) và các gợi ý cải tiến.

1. Tổng quan project
--------------------
- Loại: Java web application (WAR)
- Build: Maven (có wrapper `mvnw` / `mvnw.cmd`)
- Môi trường chạy: Servlet container (ví dụ GlassFish/Tomcat)
- Vị trí chính:
  - Source Java: `src/main/java`
  - JSP / tài nguyên web: `src/main/webapp`
  - Cấu hình: `src/main/resources/application.properties`
  - SQL mẫu: `src/main/resources/db/alcohol_shop.sql` và `db/alcohol_shop.sql`
  - Kết quả build: `target/AlcoholShop.war` hoặc `target/AlcoholShop/`

2. Cấu trúc thư mục chính (tóm tắt)
-----------------------------------
- `pom.xml` - cấu hình Maven, dependencies, packaging WAR.
- `docker-compose.yml` - nếu có cấu hình container (nếu được sử dụng cho DB hoặc app).
- `src/main/java/com/example/alcoholshop`:
  - `model/` - các POJO (ví dụ `UserAccount`, `ContactMessage`, `Product`, ...) 
  - `dao/` & `dao/impl/` - Data Access Objects, kết nối DB
  - `servlet/` hoặc `servlet/admin/` - các Servlet xử lý request (ví dụ AdminContactServlet, ProductServlet...)
  - `filter/` - các servlet filters (EncodingFilter, AdminFilter,...)
  - `service/` (nếu tồn tại) - business logic
- `src/main/webapp/`:
  - `pages/` - các JSP page của app (user pages & admin pages)
  - `pages/includes/` - `header.jsp`, `footer.jsp`, `topmenu.jsp` dùng chung
  - `static/` - css, js, images
  - `WEB-INF/web.xml` - cấu hình servlet mappings (nếu dùng)

3. Các file quan trọng và chức năng
----------------------------------
- `pom.xml`: khai báo dependencies (JSTL, JDBC driver, HikariCP, logging...), plugin xây dựng.
- `src/main/resources/application.properties`: cấu hình DB (JDBC URL, username, password), các cấu hình ứng dụng.
- `db/alcohol_shop.sql` (và resources/db/): schema & dữ liệu mẫu.
- `src/main/java/com/example/alcoholshop/model/*`: định nghĩa các thực thể (POJO). Ví dụ:
  - `ContactMessage.java`: lưu thông tin form contact (id, name, email, message, status, createdAt). Lưu ý: model có `LocalDateTime createdAt` và thêm helper `getCreatedAtAsDate()` để JSTL `fmt:formatDate` hoạt động.
  - `UserAccount.java`: thông tin user, có `LocalDateTime createdAt` — có thể cần helper tương tự nếu dùng `fmt:formatDate`.
- `src/main/java/com/example/alcoholshop/servlet/*`: các servlet xử lý request/response. Mỗi servlet thường:
  - Đọc param từ request
  - Gọi DAO/service để thao tác DB
  - Đặt attributes vào request (request.setAttribute)
  - forward/redirect tới JSP tương ứng
- `src/main/webapp/pages/*.jsp` và `src/main/webapp/pages/admin/*.jsp`: giao diện. Các file include chung (header/footer/topmenu) giúp đồng bộ UI.

4. Sơ đồ liên kết Servlet -> JSP (ví dụ thực tế)
-----------------------------------------------
Dựa trên cấu trúc project, các mapping thường thấy (ví dụ):
- `AdminContactServlet` -> xử lý `/admin/contacts`:
  - action=view&id=... -> forward tới `pages/admin/contact-detail.jsp`
  - mặc định -> `pages/admin/contacts.jsp`
- `AuthServlet`/`LoginServlet` -> `/auth/login` -> `pages/auth/login.jsp`
- `UserProfileServlet`/`ProfileServlet` -> `/profile`, edit -> `/edit-profile` -> `pages/edit-profile.jsp` hoặc `pages/profile.jsp`

Lưu ý: kiểm tra `WEB-INF/web.xml` hoặc annotation `@WebServlet` trong mã nguồn để biết mapping chính xác.

5. Giải thích mẫu code Servlet (cấu trúc, ví dụ)
-----------------------------------------------
Các servlet điển hình có 2 phương thức: `doGet(HttpServletRequest, HttpServletResponse)` và `doPost(...)`.
- doGet: thường dùng để hiển thị trang, đọc dữ liệu từ DB và set attribute, sau đó `request.getRequestDispatcher("/pages/...").forward(request, response);`.
- doPost: xử lý form submit, validate, gọi DAO để cập nhật DB, rồi `response.sendRedirect(...)` (PRG pattern) hoặc forward nếu cần giữ thông báo.

Ví dụ (ý tưởng):
- Lấy danh sách messages:
  - messages = dao.findMessages(filter...)
  - request.setAttribute("messages", messages)
  - forward -> `/pages/admin/contacts.jsp`
- Xem chi tiết message:
  - id = request.getParameter("id")
  - message = dao.findById(id)
  - request.setAttribute("message", message)
  - forward -> `/pages/admin/contact-detail.jsp`

Error handling: servlet nên bọc try/catch, log exception và forward tới trang lỗi (ví dụ `pages/error/500.jsp`) hoặc set attribute `error`.

6. Giải thích JSP (EL, JSTL, include, formatDate)
-------------------------------------------------
- JSTL core (taglib uri `http://java.sun.com/jsp/jstl/core`) và fmt (`http://java.sun.com/jsp/jstl/fmt`) được sử dụng.
- EL (Expression Language) truy cập thuộc tính bean: `${message.subject}` tương đương với `message.getSubject()` trong Java.
- Includes: `<jsp:include page="../includes/header.jsp" />` để nhúng header.
- fmt:formatDate: chỉ hoạt động với `java.util.Date` hoặc `java.util.Calendar`. Nếu model dùng `java.time.LocalDateTime` thì cần convert trước (trong model cung cấp `getCreatedAtAsDate()` trả về `java.util.Date`).
- So sánh chuỗi nên chú ý case: `${message.status == 'NEW'}` nếu status dùng uppercase. Dùng JSTL functions `fn:toUpperCase(message.status)` để bình thường hoá.
- Khi thuộc tính có thể null, luôn kiểm tra `empty` trước khi sử dụng, ví dụ:
  - `<c:when test="${not empty message.createdAtAsDate}"> <fmt:formatDate value="${message.createdAtAsDate}" pattern="..."/> </c:when>`

Lỗi phổ biến:
- "Cannot convert ... LocalDateTime to java.util.Date" — do dùng `fmt:formatDate` trên `LocalDateTime` thẳng; fix: thêm helper getter trả về `Date` trong model.
- "PropertyNotFoundException: class XYZ does not have property 'status'" — đảm bảo model có getter tên `getStatus()`; nếu dùng khác tên (ví dụ `isActive`), cập nhật JSP tương ứng.

7. Giải thích file JS / CSS
---------------------------
- `src/main/webapp/static/js/scripts.js` (hoặc `target/.../static/js`) chứa các hàm client-side (UI behaviours, modal show/hide, AJAX nếu có).
- `static/css/styles.css` chứa theme/biến màu, giúp các trang đồng bộ giao diện.
- Bao quát: các `.jsp` include CSS/JS trong `header.jsp`.

8. Chi tiết một số Servlet/JSP quan trọng (ví dụ)
------------------------------------------------
- AdminContactServlet (ví dụ):
  - Nhiệm vụ: quản lý contact messages (liệt kê, xem, xóa, đánh dấu đã đọc/replied)
  - Luồng: read params (action,id,filters) -> gọi DAO -> setAttribute -> forward/redirect.
  - Lưu ý: khi set `List<ContactMessage>` cho JSP, mỗi `ContactMessage` phải cung cấp getters cho tất cả thuộc tính JSP cần dùng (id, name, email, message, status, createdAtAsDate).

- files under `pages/admin/contacts.jsp` và `pages/admin/contact-detail.jsp`:
  - `contacts.jsp` hiển thị bảng, filter form, và dùng `${message.createdAtAsDate}` cho formatDate.
  - `contact-detail.jsp` hiển thị chi tiết message và kiểm tra `empty message`.

9. Lỗi bạn gặp và cách khắc phục (tổng hợp)
-------------------------------------------
- Lỗi 1: "Cannot convert 2025-11-11T16:05:10 of type class java.time.LocalDateTime to class java.util.Date"
  - Nguyên nhân: `fmt:formatDate` được gọi trên `LocalDateTime` instance.
  - Khắc phục: Thêm trong model (ví dụ `ContactMessage`) một helper:
    - public Date getCreatedAtAsDate() { return Date.from(this.createdAt.atZone(ZoneId.systemDefault()).toInstant()); }
  - Và trong JSP dùng `${message.createdAtAsDate}` để `fmt:formatDate` hoạt động.

- Lỗi 2: "PropertyNotFoundException: ... does not have property 'status'"
  - Nguyên nhân: JSP truy cập `${message.status}` nhưng class không có phương thức `getStatus()` hoặc attribute thực tế khác tên.
  - Khắc phục: Đảm bảo model có `public String getStatus()`; hoặc đổi JSP để dùng tên getter thực tế.

10. Hướng dẫn build & run (nhanh)
---------------------------------
- Build: `./mvnw package` (Linux/macOS) hoặc `mvnw.cmd package` (Windows).
- Deploy: triển khai file WAR (`target/AlcoholShop.war`) lên server (GlassFish/Tomcat).
- Local dev: nếu dùng embedded server hoặc Docker, tham khảo `docker-compose.yml` (nếu có cấu hình).

11. Gợi ý cải tiến và thay đổi bạn đã yêu cầu
-------------------------------------------
- Loại bỏ cache login: nếu dự án dùng cache (ví dụ Caffeine) để lưu session/login, xóa cấu hình cache liên quan hoặc chuyển sang session-based auth mặc định.
- Edit profile & change password: flow nên như bạn mô tả:
  - `edit-profile.jsp` chứa form edit, Save -> POST -> servlet cập nhật DB và redirect về `/profile?success=1` hoặc hiển thị modal xác nhận.
  - Change password: modal trong `profile.jsp` gửi POST tới `/change-password`, servlet kiểm tra mật khẩu cũ, cập nhật hash mới trong DB, redirect về `/profile?pwSuccess=1`.
- UI: đồng nhất `header.jsp`/`footer.jsp`/`topmenu.jsp` để tất cả trang cùng theme.

12. Troubleshooting nhanh
-------------------------
- Nếu gặp lỗi JSTL/EL: kiểm tra taglib URIs dùng trong JSP. Thông thường dùng:
  - core: <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
  - fmt:  <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
  - fn:   <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
- Kiểm tra `target/` để biết JSP đã được chuyển thành servlet (các file .java trong target khi build), giúp debug lỗi runtime.

13. Tài liệu thêm / Next steps
-----------------------------
- Viết unit tests cho DAO.
- Thêm helper convert cho tất cả model có `LocalDateTime` (ví dụ `getXxxAsDate()`), tránh lỗi `fmt:formatDate`.
- Chuẩn hóa `status` enum (ví dụ tạo enum `ContactStatus { NEW, READ, REPLIED }`) để tránh so sánh chuỗi và lỗi khác.
- Tạo tập tin hướng dẫn deploy (README deploy) nếu cần.

Kết luận
--------
Tệp này là bản tóm tắt để bạn nhanh nắm dự án và sửa các lỗi liên quan đến JSTL/EL (LocalDateTime vs Date, property not found). Nếu bạn muốn, tôi có thể:
- Tự động tạo/hoàn thiện các helper methods cho mọi model (ví dụ `getCreatedAtAsDate()` cho `UserAccount`),
- Chuẩn hóa enum trạng thái, hoặc
- Viết các servlet/JS để hoàn thiện flow edit-profile & change-password theo yêu cầu.

Xin cho biết bước tiếp theo bạn muốn tôi thực hiện (ví dụ: tự động sửa `UserAccount` để thêm getCreatedAtAsDate, hoặc chuẩn hoá status enums, hoặc implement edit-profile servlet + JSP).
