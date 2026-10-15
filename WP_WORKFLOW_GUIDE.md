# 📖 WordPress Master Squad - Cẩm Nang Quy Trình Thực Chiến

> **Dành cho mọi dự án WordPress chuyên nghiệp.**  
> Bộ cẩm nang này hướng dẫn chi tiết cách phối hợp 8 chuyên gia AI trong suốt vòng đời phát triển sản phẩm (từ ý tưởng đến khi release).

---

## 🎯 1. Sơ Đồ Quy Trình Phát Triển 5 Bước Chuẩn

```
[Bước 1: Kiến trúc] ➔ [Bước 2: Lập trình] ➔ [Bước 3: Tối ưu & SEO] ➔ [Bước 4: Bảo mật] ➔ [Bước 5: Thẩm định]
  agency-wp-          agency-wp-            agency-wp-                 agency-wp-           agency-wp-
  product-manager     cms-developer         performance-engineer       security-auditor     reality-checker
                      woocommerce-eng       seo-specialist
```

---

## 🚀 2. Chi Tiết Từng Bước & Mẫu Prompt Thực Chiến

### Bước 1: Khảo sát & Định hình Kiến trúc (Architecture & PRD)
* **Chuyên gia:** `agency-wp-product-manager`
* **Mục tiêu:** Chuyển hóa yêu cầu của bạn hoặc khách hàng thành bản đặc tả kỹ thuật WordPress rõ ràng (CPT, Taxonomies, ACF fields, User roles).
* **Mẫu Prompt kích hoạt:**
  > *"Dùng skill `agency-wp-product-manager` giúp tôi lập bản WP-PRD cho tính năng [Mô tả tính năng, ví dụ: Hệ thống tuyển dụng và nộp CV trực tiếp trên web]. Hãy xác định rõ: Custom Post Types, Taxonomies, các trường Meta Fields cần thiết và tiêu chí nghiệm thu."*

---

### Bước 2: Lập trình Theme / Plugin / WooCommerce (Core Build)
* **Chuyên gia:** 
  * `agency-wp-cms-developer` (Cho Theme, Custom Plugin, Gutenberg Blocks)
  * `agency-wp-woocommerce-engineer` (Cho giỏ hàng, thanh toán, cổng PSP)
* **Mục tiêu:** Viết code PHP/JS chuẩn WordPress Coding Standards (WPCS), sử dụng action hooks và filters, tuyệt đối không sửa core hay parent theme.
* **Mẫu Prompt kích hoạt (Theme/Plugin):**
  > *"Dùng skill `agency-wp-cms-developer` viết cho tôi một Custom Plugin để xử lý form nộp CV ở Bước 1. Yêu cầu: Tuân thủ nghiêm ngặt WORDPRESS_CODING_STANDARDS.md, có check `defined('ABSPATH') || exit;`, dùng `$wpdb->prepare`, có Nonce bảo vệ form và sanitize toàn bộ input."*
* **Mẫu Prompt kích hoạt (WooCommerce):**
  > *"Dùng skill `agency-wp-woocommerce-engineer` giúp tôi tùy biến trang thanh toán: thêm trường chọn thời gian giao hàng và tính phụ phí 30.000đ khi giao hỏa tốc qua hook của WooCommerce."*

---

### Bước 3: Tối ưu Tốc độ & SEO Kỹ thuật (Performance & SEO)
* **Chuyên gia:** 
  * `agency-wp-performance-engineer`
  * `agency-wp-seo-specialist`
* **Mục tiêu:** Đảm bảo trang load dưới 1.5s trên 4G, Core Web Vitals đạt chuẩn xanh, có Schema JSON-LD đầy đủ.
* **Mẫu Prompt kích hoạt:**
  > *"Dùng skill `agency-wp-performance-engineer` kiểm tra và tối ưu hóa câu lệnh query hiển thị danh sách bài viết này. Hãy thêm Transients API với thời gian cache 1 giờ, dùng `no_found_rows => true` và hướng dẫn cách khử bỏ autoload rác trong `wp_options`."*
  > 
  > *"Dùng skill `agency-wp-seo-specialist` bổ sung Schema JSON-LD dạng JobPosting cho trang chi tiết tuyển dụng để Google có thể hiển thị dạng Rich Results."*

---

### Bước 4: Kiểm tra An toàn & Lỗ hổng (Security Audit)
* **Chuyên gia:** `agency-wp-security-auditor`
* **Mục tiêu:** Rà soát lại toàn bộ code trước khi đưa lên môi trường staging/production.
* **Mẫu Prompt kích hoạt:**
  > *"Dùng skill `agency-wp-security-auditor` quét toàn bộ các file PHP vừa viết trong plugin `my-feature`. Kiểm tra kỹ lỗ hổng SQL Injection, XSS, CSRF và thiếu kiểm tra phân quyền `current_user_can()`. Nếu có lỗi, hãy chỉ rõ dòng và đưa ra code sửa chữa an toàn."*

---

### Bước 5: Thẩm định Nghiệm thu Thực tế (Reality Check)
* **Chuyên gia:** `agency-wp-reality-checker`
* **Mục tiêu:** Nghiệm thu khắt khe, mặc định là "NEEDS WORK", chỉ phê duyệt khi có bằng chứng thực tế.
* **Mẫu Prompt kích hoạt:**
  > *"Dùng skill `agency-wp-reality-checker` thực hiện kiểm định nghiệm thu tính năng này. Hãy kiểm tra xem file `wp-content/debug.log` có sinh ra Warning/Notice nào không, giao diện có vỡ trên màn hình mobile 375px không và xác nhận xem tính năng đã thực sự sẵn sàng lên Production chưa."*

---

### Bước 6: Rà Soát & Chuẩn Hóa Label Cài Đặt (Admin Settings Label Audit)
* **Chuyên gia:** `agency-wp-options-auditor`
* **Mục tiêu:** Quét toàn bộ codebase, tìm các nhãn hiển thị (Label/Title/Description/Tooltip trên UI Admin), đọc code bao quanh để hiểu tính năng thực tế. Kiểm tra ngữ pháp tiếng Anh và sự khớp nhau giữa Label với tính năng (bỏ qua hoàn toàn các giá trị value nội bộ như `value_1`). Kết xuất ra 2 file báo cáo: `options-audit-report.md` và `options-audit-report.html`.
* **Mẫu Prompt kích hoạt:**
  > *"Dùng skill `agency-wp-options-auditor` quét toàn bộ giao diện cài đặt của plugin trong thư mục này. Hãy tìm tất cả Label/Title/Description hiển thị cho admin, đọc code để hiểu chức năng thực tế của từng setting, đối chiếu xem Label đã chuẩn tiếng Anh và chuẩn tính năng chưa (bỏ qua các giá trị value nội bộ như `value_1`), chỉ rõ nơi hiển thị trên Admin UI (ví dụ: Settings > General) và xuất kết quả ra 2 file `options-audit-report.md` cùng `options-audit-report.html`."*

---

## 🎛️ 3. Phím Tắt: Điều Phối Tự Động Toàn Bộ (Autonomous Mode)

Nếu bạn muốn AI tự động vận hành trọn gói cả chu trình mà không cần gọi từng người, hãy dùng **Nhạc trưởng**:
* **Chuyên gia:** `agency-wp-agents-orchestrator`
* **Mẫu Prompt kích hoạt:**
  > *"Dùng skill `agency-wp-agents-orchestrator` điều phối trọn gói việc xây dựng tính năng [Tên tính năng]. Hãy tự động gọi PM lập PRD -> CMS Dev viết code -> Security Auditor rà soát -> Reality Checker nghiệm thu. Hãy báo cáo tiến độ từng chặng cho tôi."*
