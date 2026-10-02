# PHÂN TÍCH TÁC ĐỘNG CỦA TÀI SẢN HỮU HÌNH ĐẾN GIÁ TRỊ DOANH NGHIỆP

**Dự án nhóm | R | Panel Data Analysis | Financial Econometrics**

## 1. Giới thiệu dự án

Dự án nghiên cứu mối quan hệ giữa tỷ lệ tài sản hữu hình và giá trị thị trường của các doanh nghiệp ngành Vận tải – Kho bãi niêm yết trên HOSE trong giai đoạn 2018–2024.

Thông qua việc sử dụng ngôn ngữ R và các mô hình hồi quy dữ liệu bảng, nghiên cứu phân tích mức độ ảnh hưởng của tài sản hữu hình đến giá trị doanh nghiệp, đồng thời xem xét các yếu tố kiểm soát như quy mô, khả năng sinh lời và tăng trưởng.

## 2. Dữ liệu nghiên cứu

- **Đối tượng:** 25 doanh nghiệp ngành Vận tải – Kho bãi.
- **Giai đoạn:** 2018–2024.
- **Số quan sát:** 175.
- **Loại dữ liệu:** Dữ liệu bảng (Panel Data).

Các biến nghiên cứu:

| Biến | Ý nghĩa |
|---|---|
| TOBIN_Q | Giá trị thị trường doanh nghiệp |
| TANG | Tỷ lệ tài sản hữu hình |
| SIZE | Quy mô doanh nghiệp |
| ROA | Tỷ suất sinh lời trên tổng tài sản |
| GROWTH | Tốc độ tăng trưởng doanh thu |

## 3. Công nghệ và thư viện

- **R:** Ngôn ngữ phân tích dữ liệu.
- **plm:** Ước lượng mô hình dữ liệu bảng.
- **psych:** Thống kê mô tả.
- **dplyr:** Xử lý dữ liệu.
- **ggplot2:** Trực quan hóa dữ liệu.
- **lmtest:** Thực hiện kiểm định thống kê.
- **sandwich:** Ước lượng sai số chuẩn vững.
- **stargazer, modelsummary:** Trình bày và xuất bảng kết quả.

## 4. Quy trình thực hiện

### Bước 1: Làm sạch dữ liệu

- Nhập dữ liệu từ file CSV.
- Chuyển đổi dữ liệu sang dạng panel theo doanh nghiệp và năm.
- Thống kê mô tả các biến.
- Xử lý giá trị ngoại lai bằng Winsorization tại ngưỡng 2,5% và 97,5%.
- Sử dụng phép biến đổi logarit đối với Tobin's Q để điều chỉnh phân phối lệch phải.

### Bước 2: Phân tích dữ liệu

- Thống kê mô tả các biến.
- Phân tích ma trận tương quan.
- Kiểm tra đa cộng tuyến bằng VIF.
- Trực quan hóa phân phối Tobin's Q trước và sau khi biến đổi logarit.

### Bước 3: Xây dựng mô hình hồi quy

Ước lượng và so sánh ba mô hình:

1. Pooled Ordinary Least Squares (Pooled OLS).
2. Fixed Effects Model (FEM).
3. Random Effects Model (REM).

Mô hình nghiên cứu:

ln(Tobin's Q) = β₀ + β₁TANG + β₂SIZE + β₃ROA + β₄GROWTH + ε

### Bước 4: Kiểm định mô hình

- F-test để so sánh Pooled OLS và FEM.
- Hausman Test để so sánh FEM và REM.
- Breusch–Pagan Test để kiểm tra phương sai sai số thay đổi.
- Breusch–Godfrey Test để kiểm tra tự tương quan.
- Pesaran CD Test để kiểm tra phụ thuộc chéo.
- Kiểm định nội sinh theo phương pháp được trình bày trong nghiên cứu.

### Bước 5: Hiệu chỉnh mô hình

Sử dụng sai số chuẩn Driscoll–Kraay để xử lý vấn đề suy luận thống kê khi tồn tại phương sai sai số thay đổi, tự tương quan và phụ thuộc chéo.

## 5. Kết quả nghiên cứu

Theo kết quả hồi quy FEM với sai số chuẩn Driscoll–Kraay:

| Biến | Hệ số ước lượng | Kết quả |
|---|---:|---|
| TANG | -0,677 | Có ý nghĩa thống kê |
| SIZE | 0,547 | Có ý nghĩa thống kê |
| ROA | -0,148 | Không có ý nghĩa thống kê |
| GROWTH | 0,030 | Không có ý nghĩa thống kê |

**R² (Within): 0,2787**

Trong phạm vi mẫu nghiên cứu:

- Tỷ lệ tài sản hữu hình có mối quan hệ âm với Tobin's Q.
- Quy mô doanh nghiệp có mối quan hệ dương với Tobin's Q.
- ROA và GROWTH không có ý nghĩa thống kê trong mô hình hiệu chỉnh.

Đây là kết quả thực nghiệm trên mẫu nghiên cứu, không mặc nhiên chứng minh quan hệ nhân quả.

## 6. Kỹ năng thể hiện qua dự án

- Xử lý và làm sạch dữ liệu bằng R.
- Phân tích dữ liệu bảng.
- Thống kê mô tả và trực quan hóa dữ liệu.
- Xử lý giá trị ngoại lai.
- Xây dựng và so sánh mô hình hồi quy.
- Thực hiện kiểm định giả thuyết thống kê.
- Phân tích và diễn giải kết quả nghiên cứu.
- Phối hợp thực hiện dự án nhóm.

## 7. Mã nguồn

Mã nguồn được trình bày trong file R của repository.

Dữ liệu đầu vào: `DATA - Nhóm 3.csv`.

**Lưu ý:** Nếu dữ liệu gốc không được công khai, người sử dụng cần chuẩn bị file CSV có cấu trúc tương ứng để chạy lại chương trình.

## 8. Thông tin dự án

- **Hình thức:** Dự án nhóm – 5 thành viên.
- **Học phần:** Gói phần mềm ứng dụng trong tài chính 2.
- **Trường:** Đại học Kinh tế – Luật, ĐHQG TP.HCM.
- **Thời gian:** 03/2026.

---

*Dự án được thực hiện phục vụ mục đích học tập và nghiên cứu.*
