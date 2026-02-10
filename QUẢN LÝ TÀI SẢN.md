# Use case

HỆ THỐNG QUẢN LÝ TÀI SẢN THIẾT BỊ TRƯỜNG HỌC  
CÁC ACTOR CHÍNH (4 actors)

1. **Hiệu trưởng/Phó hiệu trưởng** \- Quản lý cấp cao, phê duyệt mua sắm lớn, giám sát hệ thống  
2. **Trưởng phòng Tài chính \- Kế toán** \- Quản lý tài sản, quản lý hệ thống  
3. **Nhân viên quản lý tài sản** \- Thực hiện các nghiệp vụ quản lý tài sản hàng ngày, phê duyệt yêu cầu cấp phát  
4. **Trưởng/Phụ trách bộ môn** \- Yêu cầu và quản lý tài sản cho bộ môn/phòng học  
   

---

### NHÓM 1: QUẢN LÝ DANH MỤC TÀI SẢN (4 use cases) \_ Quang

**UC01: Tạo danh mục tài sản mới**

* Actor: Nhân viên quản lý tài sản  
* Mô tả: Tạo danh mục phân loại tài sản (Thiết bị dạy học, Máy tính, Đồ dùng văn phòng, Thiết bị phòng thí nghiệm...)

**UC02: Cập nhật thông tin danh mục**

* Actor: Nhân viên quản lý tài sản  
* Mô tả: Chỉnh sửa tên, mô tả, thuộc tính của danh mục tài sản

**UC03: Xóa danh mục tài sản**

* Actor: Nhân viên quản lý tài sản  
* Mô tả: Xóa danh mục không còn sử dụng (kiểm tra không có tài sản nào thuộc danh mục)

**UC04: Xem và tìm kiếm danh sách danh mục**

* Actor: Tất cả các actor  
* Mô tả: Hiển thị danh sách các danh mục tài sản có phân cấp, tìm kiếm và lọc theo từ khóa, mã danh mục

---

### NHÓM 2: QUẢN LÝ TÀI SẢN (6 use cases) \_ Hiếu

**UC05: Thêm mới tài sản vào hệ thống**

* Actor: Nhân viên quản lý tài sản  
* Mô tả: Nhập thông tin tài sản mới, hệ thống tự động tạo và gán mã tài sản theo danh mục (VD: MT-2024-001)

**UC06: Xem và tìm kiếm danh sách tài sản**

* Actor: Tất cả các actor  
* Mô tả: Xem danh sách tài sản, tìm kiếm và lọc theo mã, tên, danh mục, vị trí, trạng thái

**UC07: Xem chi tiết tài sản**

* Actor: Tất cả các actor  
* Mô tả: Xem đầy đủ thông tin, lịch sử điều chuyển, vị trí hiện tại của tài sản

**UC08: Cập nhật thông tin tài sản**

* Actor: Nhân viên quản lý tài sản  
* Mô tả: Chỉnh sửa thông tin chi tiết, giá trị tài sản

**UC09: Cập nhật trạng thái tài sản**

* Actor: Nhân viên quản lý tài sản, HOD  
* Mô tả: Thay đổi trạng thái (Mới, Đang sử dụng, Hỏng, Bảo trì, Thanh lý), báo cáo tình trạng

**UC10: Xóa/Thanh lý tài sản**

* Actor: Nhân viên quản lý tài sản  
* Mô tả: Đánh dấu tài sản thanh lý, hỏng không sử dụng được

---

### NHÓM 3: GHI NHẬN TĂNG TÀI SẢN (9 use cases) \_ Khang \+ Giáp \+ Hiếu

**UC11: Tạo yêu cầu cấp phát tài sản**

* Actor: Trưởng bộ môn  
* Mô tả: Gửi yêu cầu cần tài sản cho phòng học/bộ môn

**UC12: Xem danh sách yêu cầu cấp phát tài sản**

* Actor: Nhân viên quản lý tài sản, Trưởng phòng TC-KT, Trưởng bộ môn, Giáo viên  
* Mô tả: Xem các yêu cầu cấp phát tài sản theo trạng thái (chờ duyệt, đã duyệt, từ chối)

**UC13: Kiểm tra tồn kho tài sản**

* Actor: Nhân viên quản tài sản  
* Mô tả: Kiểm tra xem tài sản được yêu cầu có sẵn trong kho không

**UC14: Phê duyệt/Từ chối yêu cầu cấp phát tài sản**

* Actor: Nhân viên quản lý tài sản  
* Mô tả: Xét duyệt hoặc từ chối các yêu cầu cấp phát tài sản (kèm lý do nếu từ chối)

**UC15: Hủy yêu cầu cấp phát tài sản**

* Actor: Trưởng bộ môn(người tạo yêu cầu)  
* Mô tả: Hủy yêu cầu cấp phát đã tạo khi chưa được phê duyệt

**UC16: Tạo yêu cầu mua sắm tài sản**

* Actor: Nhân viên quản lý tài sản  
* Mô tả: Lập đề xuất mua sắm khi không có tài sản trong kho để đáp ứng yêu cầu

**UC17: Xem danh sách yêu cầu mua sắm tài sản**

* Actor: Nhân viên quản lý tài sản, Trưởng phòng TC-KT, Hiệu trưởng/Phó hiệu trưởng  
* Mô tả: Xem các yêu cầu mua sắm theo trạng thái (chờ duyệt, đã duyệt, từ chối)

**UC18: Phê duyệt/Từ chối yêu cầu mua sắm**

* Actor: Hiệu trưởng/Phó hiệu trưởng  
* Mô tả: Phê duyệt hoặc từ chối đề xuất mua sắm tài sản mới (đặc biệt với giá trị lớn), kèm lý do nếu từ chối

**UC19: Hủy yêu cầu mua sắm tài sản**

* Actor: Nhân viên quản lý tài sản (người tạo yêu cầu)  
* Mô tả: Hủy yêu cầu mua sắm đã tạo khi chưa được phê duyệt

---

### NHÓM 4: ĐIỀU CHUYỂN TÀI SẢN (6 use cases)\_Tùng

**UC20: Tạo phiếu điều chuyển tài sản**

* Actor: Nhân viên quản lý tài sản  
* Mô tả: Lập phiếu chuyển tài sản từ phòng này sang phòng khác

**UC21: Xem và tìm kiếm phiếu điều chuyển**

* Actor: Nhân viên quản lý tài sản, Trưởng phòng TC-KT, Trưởng bộ môn  
* Mô tả: Xem lịch sử các phiếu điều chuyển, tìm kiếm và lọc theo thời gian, phòng, tài sản, trạng thái

**UC22: Phê duyệt/Từ chối điều chuyển tài sản**

* Actor: Trưởng phòng TC-KT  
* Mô tả: Xét duyệt hoặc từ chối phiếu điều chuyển (kèm lý do nếu từ chối)

**UC23: Xác nhận bàn giao tài sản**

* Actor: Trưởng bộ môn  
* Mô tả: Xác nhận bàn giao tài sản khi chuyển đi từ phòng/bộ môn mình

**UC24: Xác nhận nhận tài sản**

* Actor: Trưởng bộ môn  
* Mô tả: Xác nhận đã nhận tài sản tại vị trí mới

**UC25: Hủy phiếu điều chuyển**

* Actor: Nhân viên quản lý tài sản, Trưởng phòng TC-KT  
* Mô tả: Hủy phiếu điều chuyển chưa thực hiện hoặc chưa được phê duyệt

---

### **NHÓM 5: BÁO CÁO VÀ PHÂN TÍCH (2 use cases)**

**UC26: Xem báo cáo tài sản**

* Actor: Hiệu trưởng/Phó hiệu trưởng, Trưởng phòng TC-KT, Nhân viên quản lý tài sản, Trưởng bộ môn

* Mô tả: Xem các loại báo cáo với khả năng lọc và tùy chỉnh theo quyền hạn:

   **Hiệu trưởng/Phó hiệu trưởng:**

  * Báo cáo tổng quan tài sản (dashboard): thống kê tổng số lượng, giá trị, phân bổ theo danh mục/phòng/trạng thái  
  * Báo cáo yêu cầu và mua sắm: tổng hợp yêu cầu cấp phát, mua sắm theo thời gian và trạng thái  
* **Trưởng phòng TC-KT:**

  * Báo cáo tổng quan tài sản (dashboard): thống kê tổng số lượng, giá trị, phân bổ theo danh mục/phòng/trạng thái  
  * Báo cáo tài sản chi tiết: theo danh mục, phòng học, trạng thái, nguồn kinh phí (có filter)  
  * Báo cáo yêu cầu và mua sắm: tổng hợp yêu cầu cấp phát, mua sắm theo thời gian và trạng thái  
  * Báo cáo điều chuyển: lịch sử điều chuyển tài sản theo thời gian, phòng ban  
* **Nhân viên quản lý tài sản:**

  * Báo cáo tài sản chi tiết: theo danh mục, phòng học, trạng thái (có filter)  
  * Báo cáo yêu cầu và mua sắm: tổng hợp yêu cầu cấp phát, mua sắm theo thời gian và trạng thái  
  * Báo cáo điều chuyển: lịch sử điều chuyển tài sản  
* **Trưởng bộ môn:**

  * Báo cáo tài sản bộ môn: tài sản thuộc bộ môn theo phòng học, trạng thái  
  * Báo cáo yêu cầu: lịch sử yêu cầu cấp phát của bộ môn

**UC27: Xuất báo cáo ra file**

* Actor: Hiệu trưởng/Phó hiệu trưởng, Trưởng phòng TC-KT, Nhân viên quản lý tài sản, Trưởng bộ môn  
* Mô tả: Xuất các báo cáo đã xem/lọc ra file Excel, PDF để lưu trữ hoặc trình bày (chỉ xuất được các báo cáo mà actor có quyền xem)

---

### NHÓM 6: COMMON (5 use cases)\_Giáp

**UC28: Đăng nhập hệ thống**

* Actor: Tất cả các actor  
* Mô tả: Xác thực tài khoản bằng username/email và mật khẩu để truy cập hệ thống

**UC29: Đăng xuất hệ thống**

* Actor: Tất cả các actor  
* Mô tả: Kết thúc phiên làm việc và thoát khỏi hệ thống

**UC30: Quản lý hồ sơ cá nhân**

* Actor: Tất cả các actor  
* Mô tả: Xem, cập nhật thông tin cá nhân (họ tên, email, số điện thoại, ảnh đại diện...)

**UC31: Quên mật khẩu**

* Actor: Tất cả các actor  
* Mô tả: Yêu cầu khôi phục mật khẩu qua email khi quên mật khẩu

**UC32: Đổi mật khẩu**

* Actor: Tất cả các actor  
* Mô tả: Thay đổi mật khẩu hiện tại (yêu cầu nhập mật khẩu cũ để xác thực)

---

GHI CHÚ 

**Quản lý Danh mục vs Quản lý Tài sản:**

* **Danh mục**: Là các loại/nhóm tài sản (VD: Máy tính, Bàn ghế, Thiết bị thí nghiệm) \- đây là template/khuôn mẫu  
* **Tài sản**: Là các thiết bị cụ thể thuộc danh mục (VD: Máy tính Dell Latitude E7450 \- mã MT-2024-001)  
* **Mã tài sản tự động**: Khi thêm tài sản mới (UC05), hệ thống tự động tạo mã dựa theo quy tắc của danh mục

**Quy trình Yêu cầu Tài sản:**

1. Giáo viên/Trưởng bộ môn tạo yêu cầu cấp phát (UC11)  
2. Nhân viên quản lý tài sản kiểm tra tồn kho (UC13)  
3. Nếu có: Nhân viên phê duyệt và cấp phát (UC14)  
4. Nếu không có: Nhân viên tạo yêu cầu mua sắm (UC16)  
5. Hiệu trưởng/Phó hiệu trưởng phê duyệt mua sắm (UC18)

**Phân quyền theo cấp:**

* **Hiệu trưởng/Phó hiệu trưởng**: Phê duyệt mua sắm lớn, xem các báo cáo chiến lược  
* **Trưởng phòng TC-KT**: Quản lý danh mục, thanh lý tài sản, phê duyệt điều chuyển, quản lý hệ thống  
* **Nhân viên quản lý tài sản**: Thực hiện nghiệp vụ hàng ngày, phê duyệt yêu cầu cấp phát  
* **Trưởng bộ môn**: Yêu cầu và quản lý tài sản cấp bộ môn, xác nhận điều chuyển  
* **Giáo viên**: Yêu cầu tài sản, báo cáo tình trạng

# Workflow

MAIN PROCESS 1: QUẢN LÝ DANH MỤC TÀI SẢN

**Actor chính:** Trưởng phòng TC-KT

**Trình tự thực hiện:**

1. **Đăng nhập hệ thống** (UC28)  
2. **Truy cập module Quản lý Danh mục**  
3. **Xem và tìm kiếm danh sách danh mục** (UC04)  
4. **Decision Point:** Muốn thực hiện hành động gì?  
   * **Tạo mới** → UC01: Tạo danh mục tài sản mới  
     * Nhập thông tin danh mục (tên, mô tả, quy tắc mã tự động)  
     * Lưu danh mục  
     * Quay lại danh sách (UC04)  
   * **Cập nhật** → UC02: Cập nhật thông tin danh mục  
     * Chọn danh mục cần sửa  
     * Chỉnh sửa thông tin  
     * Lưu thay đổi  
     * Quay lại danh sách (UC04)  
   *  	**Xóa** → UC03: Xóa danh mục tài sản  
     * Chọn danh mục cần xóa  
     * **Decision Point:** Có tài sản thuộc danh mục không?  
       * **Có** → Hiển thị cảnh báo, không cho xóa  
       * **Không** → Xác nhận xóa → Xóa thành công  
     * Quay lại danh sách (UC04)  
   * **Xem chi tiết** → Xem thông tin chi tiết danh mục  
5. **Đăng xuất** (UC29)

---

MAIN PROCESS 2: QUẢN LÝ TÀI SẢN

**Actor chính:** Nhân viên quản lý tài sản, Trưởng phòng TC-KT, Giáo viên

Quy trình A: Thêm mới và cập nhật tài sản (Nhân viên quản lý tài sản)

1. **Đăng nhập hệ thống** (UC28)  
2. **Truy cập module Quản lý Tài sản**  
3. **Xem và tìm kiếm danh sách tài sản** (UC06)  
4. **Decision Point:** Muốn thực hiện hành động gì?  
   * **Thêm mới** → UC05: Thêm mới tài sản vào hệ thống  
     * Chọn danh mục tài sản  
     * Nhập thông tin tài sản (tên, mô tả, giá trị, nhà cung cấp, ngày mua...)  
     * Hệ thống tự động tạo mã tài sản (VD: MT-2024-001)  
     * Lưu tài sản  
     * Quay lại danh sách (UC06)  
   * **Cập nhật thông tin** → UC08: Cập nhật thông tin tài sản  
     * Chọn tài sản cần sửa  
     * Chỉnh sửa thông tin chi tiết, giá trị  
     * Lưu thay đổi  
   * **Cập nhật trạng thái** → UC09: Cập nhật trạng thái tài sản  
     * Chọn tài sản  
     * Thay đổi trạng thái (Mới, Đang sử dụng, Hỏng, Bảo trì, Thanh lý)  
     * Nhập ghi chú (nếu cần)  
     * Lưu thay đổi  
   * **Xem chi tiết** → UC07: Xem chi tiết tài sản  
     * Xem đầy đủ thông tin  
     * Xem lịch sử điều chuyển  
     * Xem vị trí hiện tại  
   * **Xóa/Thanh lý tài sản**  
     * Chọn tài sản cần thanh lý  
     * Nhập lý do thanh lý  
     * Xác nhận thanh lý  
     * Tài sản được đánh dấu trạng thái "Thanh lý"  
5. **Đăng xuất** (UC29)

---

MAIN PROCESS 3: GHI NHẬN TĂNG TÀI SẢN (YÊU CẦU VÀ MUA SẮM)

**Actor:** Giáo viên/Trưởng bộ môn → Nhân viên quản lý tài sản → Hiệu trưởng/Phó hiệu trưởng

Quy trình đầy đủ:

**BƯỚC 1: Tạo yêu cầu cấp phát (Giáo viên/Trưởng bộ môn)**

1. **Đăng nhập hệ thống** (UC28)  
2. **UC11: Tạo yêu cầu cấp phát tài sản**  
   * Chọn danh mục tài sản cần yêu cầu  
   * Nhập số lượng, mô tả, lý do cần  
   * Chọn phòng học/bộ môn nhận  
   * Gửi yêu cầu  
3. **UC12: Xem danh sách yêu cầu cấp phát tài sản**  
   * Theo dõi trạng thái yêu cầu  
4. **Decision Point:** Yêu cầu có được phê duyệt không?  
   * **Chờ duyệt** → Tiếp tục theo dõi  
   * **Từ chối** → Xem lý do từ chối → **Decision Point:**  
     * Chấp nhận → Kết thúc  
     * Không chấp nhận → UC15: Hủy yêu cầu và tạo yêu cầu mới  
   * **Đã duyệt** → Chờ nhận tài sản  
5. **Đăng xuất** (UC29)

**BƯỚC 2: Xử lý yêu cầu cấp phát (Nhân viên quản lý tài sản)**

1. **Đăng nhập hệ thống** (UC28)

2. **UC12: Xem danh sách yêu cầu cấp phát tài sản**

   * Xem các yêu cầu đang chờ duyệt  
3. **UC13: Kiểm tra tồn kho tài sản**

   * Kiểm tra tài sản có sẵn trong kho  
4. **Decision Point:** Có đủ tài sản trong kho không?

    **TH1: CÓ đủ tài sản**

   * **UC14: Phê duyệt yêu cầu cấp phát tài sản**  
     * Xác nhận phê duyệt  
     * Gán tài sản cụ thể cho yêu cầu  
     * Thông báo cho người yêu cầu  
   * **Kết thúc quy trình**  
5. **TH2: KHÔNG đủ tài sản**

   * **UC14: Từ chối yêu cầu cấp phát** (tạm thời)  
     * Nhập lý do: "Không đủ tài sản trong kho"  
   * **UC16: Tạo yêu cầu mua sắm tài sản**  
     * Lập đề xuất mua sắm  
     * Nhập thông tin: tài sản cần mua, số lượng, giá ước tính, nhà cung cấp  
     * Đính kèm yêu cầu cấp phát gốc  
     * Gửi yêu cầu mua sắm lên Hiệu trưởng  
   * **Chuyển sang BƯỚC 3**  
6. **Đăng xuất** (UC29)

**BƯỚC 3: Phê duyệt mua sắm (Hiệu trưởng/Phó hiệu trưởng)**

1. **Đăng nhập hệ thống** (UC28)

2. **UC17: Xem danh sách yêu cầu mua sắm tài sản**

   * Xem các yêu cầu đang chờ phê duyệt  
3. **Xem chi tiết yêu cầu mua sắm**

   * Kiểm tra thông tin: lý do, giá trị, nguồn kinh phí  
4. **Decision Point:** Phê duyệt hay từ chối?

    **Phê duyệt:**

   * **UC18: Phê duyệt yêu cầu mua sắm**  
     * Xác nhận phê duyệt  
     * Chọn nguồn kinh phí  
     * Thông báo cho Nhân viên quản lý tài sản  
   * Sau khi mua về → Nhân viên quản lý tài sản thực hiện **UC05: Thêm mới tài sản vào hệ thống**  
   * Quay lại **UC14: Phê duyệt yêu cầu cấp phát** cho yêu cầu gốc  
5. **Từ chối:**

   * **UC18: Từ chối yêu cầu mua sắm**  
     * Nhập lý do từ chối  
     * Thông báo cho Nhân viên quản lý tài sản  
   * Nhân viên quản lý tài sản thực hiện **UC14: Từ chối yêu cầu cấp phát** cho yêu cầu gốc (với lý do cụ thể)  
6. **Đăng xuất** (UC29)

**Lưu ý:**

* Người tạo yêu cầu có thể thực hiện **UC15: Hủy yêu cầu cấp phát** hoặc **UC19: Hủy yêu cầu mua sắm** khi trạng thái còn "Chờ duyệt"

---

MAIN PROCESS 4: ĐIỀU CHUYỂN TÀI SẢN

**Actor:** Nhân viên quản lý tài sản → Trưởng phòng TC-KT → Trưởng bộ môn (bàn giao) → Trưởng bộ môn (nhận)

Quy trình đầy đủ:

**BƯỚC 1: Tạo phiếu điều chuyển (Nhân viên quản lý tài sản)**

1. **Đăng nhập hệ thống** (UC28)  
2. **UC20: Tạo phiếu điều chuyển tài sản**  
   * Chọn tài sản cần điều chuyển  
   * Chọn phòng/bộ môn nguồn (hiện tại)  
   * Chọn phòng/bộ môn đích (nơi nhận)  
   * Nhập lý do điều chuyển  
   * Nhập ngày dự kiến điều chuyển  
   * Tạo phiếu  
3. **UC21: Xem và tìm kiếm phiếu điều chuyển**  
   * Theo dõi trạng thái phiếu  
4. **Decision Point:** Cần hủy phiếu không?  
   * **Có** → UC25: Hủy phiếu điều chuyển (nếu chưa được phê duyệt)  
   * **Không** → Chờ phê duyệt  
5. **Đăng xuất** (UC29)

**BƯỚC 2: Phê duyệt điều chuyển (Trưởng phòng TC-KT)**

1. **Đăng nhập hệ thống** (UC28)

2. **UC21: Xem và tìm kiếm phiếu điều chuyển**

   * Lọc phiếu "Chờ duyệt"  
3. **Xem chi tiết phiếu điều chuyển**

   * Kiểm tra tài sản, phòng nguồn, phòng đích, lý do  
4. **Decision Point:** Phê duyệt hay từ chối?

    **Phê duyệt:**

   * **UC22: Phê duyệt điều chuyển tài sản**  
     * Xác nhận phê duyệt  
     * Phiếu chuyển sang trạng thái "Đã duyệt \- Chờ bàn giao"  
     * Thông báo cho Trưởng bộ môn nguồn  
5. **Từ chối:**

   * **UC22: Từ chối điều chuyển tài sản**  
     * Nhập lý do từ chối  
     * Thông báo cho Nhân viên quản lý tài sản  
   * **Kết thúc quy trình**  
6. **Đăng xuất** (UC29)

**BƯỚC 3: Bàn giao tài sản (Trưởng bộ môn \- Phòng nguồn)**

1. **Đăng nhập hệ thống** (UC28)  
2. **UC21: Xem và tìm kiếm phiếu điều chuyển**  
   * Xem phiếu cần bàn giao  
3. **UC23: Xác nhận bàn giao tài sản**  
   * Kiểm tra tài sản thực tế  
   * Xác nhận đã bàn giao  
   * Nhập ghi chú (tình trạng tài sản lúc bàn giao)  
   * Phiếu chuyển sang trạng thái "Đã bàn giao \- Chờ nhận"  
   * Thông báo cho Trưởng bộ môn nhận  
4. **Đăng xuất** (UC29)

**BƯỚC 4: Nhận tài sản (Trưởng bộ môn \- Phòng đích)**

1. **Đăng nhập hệ thống** (UC28)  
2. **UC21: Xem và tìm kiếm phiếu điều chuyển**  
   * Xem phiếu cần nhận  
3. **UC24: Xác nhận nhận tài sản**  
   * Kiểm tra tài sản thực tế  
   * **Decision Point:** Tài sản có vấn đề không?  
     * **Có vấn đề** → Nhập ghi chú vấn đề → Vẫn xác nhận nhận (để xử lý sau)  
     * **Không vấn đề** → Xác nhận nhận bình thường  
   * Xác nhận đã nhận  
   * Phiếu chuyển sang trạng thái "Hoàn thành"  
   * Hệ thống tự động cập nhật vị trí tài sản  
4. **Đăng xuất** (UC29)

**Lưu ý:**

* Có thể thực hiện **UC25: Hủy phiếu điều chuyển** ở các trạng thái:  
  * "Chờ duyệt": Nhân viên quản lý tài sản hoặc Trưởng phòng TC-KT  
  * "Đã duyệt \- Chờ bàn giao": Trưởng phòng TC-KT (với lý do đặc biệt)

---

MAIN PROCESS 5: BÁO CÁO VÀ PHÂN TÍCH

**Actor:** Hiệu trưởng/Phó hiệu trưởng, Trưởng phòng TC-KT, Nhân viên quản lý tài sản, Trưởng bộ môn

Quy trình chung cho tất cả Actor:

1. **Đăng nhập hệ thống** (UC28)

2. **Truy cập module Báo cáo**

3. **UC26: Xem báo cáo tài sản**

   * **Decision Point:** Chọn loại báo cáo (tùy theo quyền hạn của actor)  
4. **Hiệu trưởng/Phó hiệu trưởng:**

   * Chọn "Báo cáo tổng quan tài sản (Dashboard)"  
   * Chọn "Báo cáo yêu cầu và mua sắm"  
   * Thiết lập bộ lọc (thời gian, trạng thái...)  
5. **Trưởng phòng TC-KT:**

   * Chọn "Báo cáo tổng quan tài sản (Dashboard)"  
   * Chọn "Báo cáo tài sản chi tiết"  
   * Chọn "Báo cáo yêu cầu và mua sắm"  
   * Chọn "Báo cáo điều chuyển"  
   * Thiết lập bộ lọc (danh mục, phòng học, trạng thái, nguồn kinh phí, thời gian...)  
6. **Nhân viên quản lý tài sản:**

   * Chọn "Báo cáo tài sản chi tiết"  
   * Chọn "Báo cáo yêu cầu và mua sắm"  
   * Chọn "Báo cáo điều chuyển"  
   * Thiết lập bộ lọc (danh mục, phòng học, trạng thái, thời gian...)  
7. **Trưởng bộ môn:**

   * Chọn "Báo cáo tài sản bộ môn" (chỉ thấy bộ môn mình)  
   * Chọn "Báo cáo yêu cầu" (lịch sử yêu cầu của bộ môn)  
   * Thiết lập bộ lọc (phòng học, trạng thái, thời gian...)  
8. **Hệ thống hiển thị báo cáo**

   * Xem dữ liệu dưới dạng bảng, biểu đồ  
   * Phân tích thông tin  
9. **Decision Point:** Cần xuất báo cáo không?

   * **Có** → UC27: Xuất báo cáo ra file  
     * Chọn định dạng (Excel hoặc PDF)  
     * Xác nhận xuất  
     * Tải file về  
   * **Không** → Tiếp tục xem hoặc chuyển sang báo cáo khác  
10. **Đăng xuất** (UC29)