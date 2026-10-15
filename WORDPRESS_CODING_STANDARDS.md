# 🛡️ WordPress Coding & Security Standards (WPCS)
> **MAMFLOW WP Standard Specification**
> Áp dụng bắt buộc cho mọi dòng code PHP, JS, CSS sinh ra trong dự án WordPress.

---

## 1. Nguyên tắc An toàn Cốt lõi (Security First)

### 1.1 Chống truy cập trực tiếp (Direct File Access)
Mọi file PHP trong Theme hoặc Plugin bắt buộc phải có dòng kiểm tra này ở dòng đầu tiên ngay sau thẻ `<?php`:
```php
<?php
defined( 'ABSPATH' ) || exit;
```

### 1.2 Nguyên tắc "Sanitize Sớm - Escape Muộn" (Sanitize Early, Escape Late)

#### A. Sanitize Input (Khi nhận dữ liệu từ `$_POST`, `$_GET`, REST API):
* Chuỗi text 1 dòng: `sanitize_text_field( wp_unslash( $_POST['user_name'] ?? '' ) )`
* Chuỗi text nhiều dòng: `sanitize_textarea_field( wp_unslash( $_POST['user_bio'] ?? '' ) )`
* Email: `sanitize_email( wp_unslash( $_POST['email'] ?? '' ) )`
* Số nguyên / ID: `absint( $_POST['item_id'] ?? 0 )` hoặc `intval()`
* Key / Slug: `sanitize_key( $_POST['slug'] ?? '' )`
* URL: `esc_url_raw( wp_unslash( $_POST['website'] ?? '' ) )`
* Mảng: Duyệt `array_map()` với hàm sanitize tương ứng.

#### B. Escape Output (Ngay trước khi in ra HTML):
* In text thường (loại bỏ mọi thẻ HTML): `<?php echo esc_html( $text ); ?>`
* In trong thuộc tính HTML (`title`, `placeholder`, `value`): `<?php echo esc_attr( $val ); ?>`
* In đường dẫn link (`href`, `src`): `<?php echo esc_url( $url ); ?>`
* In HTML an toàn (cho phép các thẻ định dạng bài viết cơ bản): `<?php echo wp_kses_post( $rich_content ); ?>`
* In chuỗi vào thẻ JavaScript inline: `<?php echo esc_js( $js_variable ); ?>`

---

## 2. Bảo mật Form, AJAX & Phân quyền (Nonces & Capabilities)

### 2.1 Kiểm tra phân quyền (User Capabilities)
Không bao giờ tin tưởng việc người dùng đã đăng nhập là có quyền thực hiện tác vụ:
```php
if ( ! current_user_can( 'manage_options' ) ) {
    wp_die( esc_html__( 'Bạn không có quyền thực hiện hành động này.', 'textdomain' ), 403 );
}
```

### 2.2 Xác thực Nonce trong Form và AJAX
* **Tạo nonce trong form:**
  ```php
  wp_nonce_field( 'my_action_name', 'my_nonce_field' );
  ```
* **Xác thực nonce trong POST:**
  ```php
  if ( ! isset( $_POST['my_nonce_field'] ) || ! wp_verify_nonce( sanitize_text_field( wp_unslash( $_POST['my_nonce_field'] ) ), 'my_action_name' ) ) {
      wp_die( esc_html__( 'Yêu cầu không hợp lệ hoặc đã hết hạn.', 'textdomain' ), 403 );
  }
  ```
* **Xác thực nonce trong AJAX:**
  ```php
  check_ajax_referer( 'my_ajax_nonce_key', 'security' );
  ```

---

## 3. Thao tác Cơ sở Dữ liệu an toàn (Database Standards)

### 3.1 Tuyệt đối cấm nối chuỗi SQL trực tiếp
* ❌ **CẤM:** `$wpdb->query( "SELECT * FROM {$wpdb->posts} WHERE ID = " . $_GET['id'] );` (Gây SQL Injection)
* ✅ **BẮT BUỘC DÙNG `$wpdb->prepare`:**
  ```php
  global $wpdb;
  $post_id = absint( $_GET['id'] ?? 0 );
  $results = $wpdb->get_results(
      $wpdb->prepare(
          "SELECT * FROM {$wpdb->posts} WHERE ID = %d AND post_status = %s",
          $post_id,
          'publish'
      )
  );
  ```

### 3.2 Tối ưu hóa `WP_Query`
* ❌ **CẤM:** `posts_per_page => -1` trên các trang frontend (gây tràn bộ nhớ khi database lớn).
* ✅ **BẮT BUỘC:** Luôn giới hạn `posts_per_page` cụ thể (ví dụ: `10`, `20`).
* ✅ Nếu không cần phân trang, luôn thêm `'no_found_rows' => true` để MySQL không phải chạy hàm tính tổng số dòng `SQL_CALC_FOUND_ROWS`.

---

## 4. Kiến trúc Hook-Driven (Không sửa Core / Parent Theme)

* **Tuyệt đối không can thiệp file mã nguồn của WordPress Core** hoặc Theme cha (Parent Theme).
* Mọi tính năng tùy biến phải đặt trong:
  1. **Custom Plugin** (Khuyến khích cho logic nghiệp vụ, CPT, shortcode, API).
  2. **Child Theme** (Cho template, layout, style).
* Tận dụng tối đa `add_action()` và `add_filter()`.
* Đăng ký Script/Style đúng chuẩn qua hook:
  ```php
  add_action( 'wp_enqueue_scripts', 'my_custom_enqueue_assets' );
  function my_custom_enqueue_assets() {
      wp_enqueue_style( 'my-style', get_stylesheet_directory_uri() . '/assets/css/main.css', array(), '1.0.0' );
      wp_enqueue_script( 'my-script', get_stylesheet_directory_uri() . '/assets/js/main.js', array( 'jquery' ), '1.0.0', true );
      
      // Truyền dữ liệu an toàn sang JS
      wp_localize_script( 'my-script', 'myAppConfig', array(
          'ajaxUrl' => admin_url( 'admin-ajax.php' ),
          'nonce'   => wp_create_nonce( 'my_ajax_nonce' ),
      ) );
  }
  ```

---

## 5. Quy chuẩn Đặt tên & Cấu trúc (Naming Conventions)

* **Prefixing:** Tất cả hàm, class, biến toàn cục, action/filter tự tạo phải có prefix riêng của dự án (ví dụ: `mamflow_`, `MAMFLOW_`).
* **Hàm và biến:** Dùng `snake_case` (ví dụ: `mamflow_get_user_orders()`, `$order_total`).
* **Class:** Dùng `PascalCase` với prefix (ví dụ: `MAMFLOW_Order_Handler`).
* **Hằng số:** Dùng `UPPERCASE_SNAKE` (ví dụ: `MAMFLOW_VERSION`).
* **Files:** Dùng `kebab-case` (ví dụ: `class-order-handler.php`, `template-order-detail.php`).

---

## 6. Tối ưu Hiệu năng & Cache

* **Transients API:** Dùng cho dữ liệu tính toán nặng hoặc gọi API bên ngoài:
  ```php
  $cache_key = 'mamflow_featured_products';
  $products  = get_transient( $cache_key );
  if ( false === $products ) {
      $products = mamflow_compute_heavy_query();
      set_transient( $cache_key, $products, 2 * HOUR_IN_SECONDS );
  }
  ```
* **Bảng `wp_options`:** Không tự ý lưu các khối dữ liệu khổng lồ với `autoload = yes`. Chỉ những cấu hình cần nạp ở mọi request mới bật autoload.
