-- ==========================================================
-- DỮ LIỆU MẪU - HỆ THỐNG QUẢN LÝ TÀI SẢN (CFMS)
-- Chạy SAU khi đã tạo bảng từ db_draft.sql
-- ==========================================================

USE swp_draft;
GO

-- ==========================================================
-- TẦNG 1: BẢNG GỐC (không phụ thuộc)
-- ==========================================================

-- 1. Roles (5 vai trò)
SET IDENTITY_INSERT roles ON;
INSERT INTO roles (role_id, role_name, description) VALUES
(1, N'Admin',          N'Quản trị hệ thống'),
(2, N'Finance Head',   N'Trưởng phòng Tài chính - Phê duyệt cấp phát, mua sắm'),
(3, N'Asset Staff',    N'Nhân viên Quản lý tài sản - Thao tác nghiệp vụ'),
(4, N'Head of Dept',   N'Trưởng bộ môn / Giảng viên - Yêu cầu cấp phát, báo hỏng'),
(5, N'Principal',      N'Hiệu trưởng - Duyệt tối cao');

SET IDENTITY_INSERT roles OFF;
GO

-- 2. Departments (6 phòng ban / khoa)
SET IDENTITY_INSERT departments ON;
INSERT INTO departments (dept_id, dept_name, description) VALUES
(1, N'Khoa Công nghệ Thông tin',   N'Đào tạo CNTT, Phần mềm, An toàn thông tin'),
(2, N'Khoa Kinh tế',               N'Đào tạo Kế toán, Quản trị kinh doanh'),
(3, N'Khoa Điện - Điện tử',        N'Đào tạo Điện tử, Viễn thông, Tự động hóa'),
(4, N'Khoa Cơ khí',                N'Đào tạo Cơ khí chế tạo, Ô tô'),
(5, N'Phòng Hành chính',           N'Quản lý hành chính, nhân sự'),
(6, N'Phòng Tài chính - Kế toán',  N'Quản lý tài chính, mua sắm, thanh lý');
SET IDENTITY_INSERT departments OFF;
GO

-- 3. Categories (10 loại tài sản)
SET IDENTITY_INSERT categories ON;
INSERT INTO categories (category_id, category_name, prefix_code, description) VALUES
(1,  N'Laptop',            'LAP',  N'Máy tính xách tay'),
(2,  N'Máy tính bàn',      'PC',   N'Máy tính để bàn (Desktop)'),
(3,  N'Màn hình',          'MON',  N'Màn hình LCD/LED'),
(4,  N'Máy in',            'PRT',  N'Máy in laser, phun mực'),
(5,  N'Máy chiếu',         'PRJ',  N'Máy chiếu đa năng'),
(6,  N'Bàn ghế',           'FUR',  N'Bàn ghế văn phòng, phòng học'),
(7,  N'Điều hòa',          'AC',   N'Điều hòa không khí'),
(8,  N'Thiết bị mạng',     'NET',  N'Router, Switch, Access Point'),
(9,  N'Quạt',              'FAN',  N'Quạt trần, quạt đứng'),
(10, N'Thiết bị khác',     'OTH',  N'Thiết bị không thuộc danh mục trên');
SET IDENTITY_INSERT categories OFF;
GO

-- 4. Suppliers (5 nhà cung cấp)
SET IDENTITY_INSERT suppliers ON;
INSERT INTO suppliers (supplier_id, supplier_name, contact_person, email, phone, address) VALUES
(1, N'Công ty TNHH FPT',              N'Nguyễn Văn An',   'sales@fpt.vn',       '024-7300-2222', N'Tòa nhà FPT, Cầu Giấy, Hà Nội'),
(2, N'Phong Vũ Computer',             N'Trần Thị Bình',   'info@phongvu.vn',    '028-3622-1111', N'65 Trần Hưng Đạo, Q.1, TP.HCM'),
(3, N'Dell Technologies Việt Nam',     N'Lê Minh Cường',   'support@dell.com.vn','024-3946-0000', N'Keangnam Tower, Hà Nội'),
(4, N'Công ty Thiết bị Văn phòng ABC', N'Phạm Thị Dung',   'abc@office.vn',      '024-3555-8888', N'123 Lê Duẩn, Hoàn Kiếm, Hà Nội'),
(5, N'HP Việt Nam',                    N'Hoàng Văn Em',    'support@hp.com.vn',  '028-3930-5555', N'Bitexco Tower, Q.1, TP.HCM');
SET IDENTITY_INSERT suppliers OFF;
GO

-- ==========================================================
-- TẦNG 2: PHỤ THUỘC TẦNG 1
-- ==========================================================

-- 5. Rooms (15 phòng)
SET IDENTITY_INSERT rooms ON;
INSERT INTO rooms (room_id, room_name, dept_id, capacity) VALUES
(1,  N'Phòng 101 - Lab CNTT 1',     1, 40),
(2,  N'Phòng 102 - Lab CNTT 2',     1, 35),
(3,  N'Phòng 103 - Lab CNTT 3',     1, 30),
(4,  N'Phòng 201 - Học lý thuyết',  2, 50),
(5,  N'Phòng 202 - Lab Kinh tế',    2, 30),
(6,  N'Phòng 301 - Lab Điện tử',    3, 25),
(7,  N'Phòng 302 - Lab Viễn thông', 3, 25),
(8,  N'Phòng 401 - Xưởng Cơ khí',  4, 20),
(9,  N'Phòng Hành chính',           5, 10),
(10, N'Phòng Tài chính',            6, 8),
(11, N'Phòng Giám đốc',             5, 5),
(12, N'Phòng Họp A',                5, 20),
(13, N'Phòng Họp B',                5, 15),
(14, N'Kho thiết bị tầng 1',        5, NULL),
(15, N'Kho thiết bị tầng 2',        5, NULL);
SET IDENTITY_INSERT rooms OFF;
GO

-- 6. Users (11 người dùng) - password = '123456'
SET IDENTITY_INSERT users ON;
INSERT INTO users (user_id, username, password_hash, full_name, email, phone, role_id, dept_id, status) VALUES
(1,  'admin',      '123456', N'Nguyễn Quản Trị',     'admin@cfms.edu.vn',      '0901000001', 1, 5, N'Active'),
(2,  'tptaichinh', '123456', N'Trần Văn Tài',        'tai.tv@cfms.edu.vn',     '0901000002', 2, 6, N'Active'),
(3,  'nvquanly1',  '123456', N'Lê Thị Quản',         'quan.lt@cfms.edu.vn',    '0901000003', 3, 5, N'Active'),
(4,  'nvquanly2',  '123456', N'Phạm Minh Lý',        'ly.pm@cfms.edu.vn',      '0901000004', 3, 5, N'Active'),
(5,  'gv_cntt1',   '123456', N'Hoàng Văn Nam',       'nam.hv@cfms.edu.vn',     '0901000005', 4, 1, N'Active'),
(6,  'gv_cntt2',   '123456', N'Vũ Thị Lan',          'lan.vt@cfms.edu.vn',     '0901000006', 4, 1, N'Active'),
(7,  'gv_kinhte',  '123456', N'Đỗ Thanh Hà',         'ha.dt@cfms.edu.vn',      '0901000007', 4, 2, N'Active'),
(8,  'gv_dien',    '123456', N'Ngô Quốc Bảo',        'bao.nq@cfms.edu.vn',     '0901000008', 4, 3, N'Active'),
(9,  'gv_cokhi',   '123456', N'Bùi Đức Mạnh',        'manh.bd@cfms.edu.vn',    '0901000009', 4, 4, N'Active'),
(10, 'gv_inactive','123456', N'Trương Thị Ngọc',      'ngoc.tt@cfms.edu.vn',    '0901000010', 4, 1, N'Inactive'),
(11, 'hieutruong', '123456', N'Đoàn Hiệu Trưởng',     'hieutruong@cfms.edu.vn',  '0901000011',5, 5, N'Active' );
SET IDENTITY_INSERT users OFF;
GO

-- ==========================================================
-- TẦNG 3: TÀI SẢN
-- ==========================================================

-- 7. Assets (35 tài sản - đủ trạng thái, đủ loại)
SET IDENTITY_INSERT assets ON;
INSERT INTO assets (asset_id, asset_code, asset_name, category_id, supplier_id, room_id, price, purchase_date, warranty_expiry_date, quantity, status, description) VALUES
-- Laptop (6 chiếc)
(1,  'LAP-2024-001', N'Dell Latitude 5540',         1, 3, 1,  22000000, '2024-03-15', '2027-03-15', 1, N'In_Use',      N'Laptop cho giảng viên CNTT'),
(2,  'LAP-2024-002', N'Dell Latitude 5540',         1, 3, 1,  22000000, '2024-03-15', '2027-03-15', 1, N'In_Use',      N'Laptop cho giảng viên CNTT'),
(3,  'LAP-2024-003', N'HP ProBook 450 G10',         1, 5, 2,  18500000, '2024-06-01', '2027-06-01', 1, N'In_Use',      N'Laptop lab CNTT 2'),
(4,  'LAP-2025-001', N'Dell Inspiron 15 3520',      1, 3, NULL, 15000000, '2025-01-10', '2028-01-10', 1, N'New',       N'Laptop mới nhập kho'),
(5,  'LAP-2024-004', N'Lenovo ThinkPad E14',        1, 2, 5,  19000000, '2024-01-20', '2026-01-20', 1, N'Broken',      N'Hỏng bàn phím, chờ sửa'),
(6,  'LAP-2025-002', N'Acer Aspire 5',              1, 2, NULL, 13500000, '2025-02-01', '2028-02-01', 3, N'New',       N'3 laptop mới nhập kho'),

-- Máy tính bàn (6 bộ)
(7,  'PC-2023-001',  N'Dell OptiPlex 7010',         2, 3, 1,  16000000, '2023-09-01', '2026-09-01', 5, N'In_Use',      N'5 bộ PC lab CNTT 1'),
(8,  'PC-2023-002',  N'HP ProDesk 400 G9',          2, 5, 2,  14500000, '2023-09-01', '2026-09-01', 5, N'In_Use',      N'5 bộ PC lab CNTT 2'),
(9,  'PC-2024-001',  N'Dell OptiPlex 3000',         2, 3, 3,  12000000, '2024-02-15', '2027-02-15', 5, N'In_Use',      N'5 bộ PC lab CNTT 3'),
(10, 'PC-2023-003',  N'HP EliteDesk 800 G6',        2, 5, 6,  15000000, '2023-06-01', '2025-06-01', 3, N'Maintenance', N'3 bộ đang bảo trì'),
(11, 'PC-2024-002',  N'Lenovo ThinkCentre M70q',    2, 2, 5,  13000000, '2024-05-10', '2027-05-10', 4, N'In_Use',      N'4 bộ PC lab Kinh tế'),
(12, 'PC-2025-001',  N'Dell Vostro 3020',           2, 3, NULL, 11000000, '2025-01-20', '2028-01-20', 10, N'New',      N'10 bộ PC mới nhập kho'),

-- Màn hình (4 cái)
(13, 'MON-2023-001', N'Dell P2422H 24 inch',        3, 3, 1,  5500000,  '2023-09-01', '2026-09-01', 5, N'In_Use',      N'Màn hình cho lab CNTT 1'),
(14, 'MON-2024-001', N'LG 27UL500 27 inch 4K',      3, 2, 11, 8000000,  '2024-04-01', '2027-04-01', 1, N'In_Use',      N'Màn hình phòng Giám đốc'),
(15, 'MON-2024-002', N'Samsung LS24A33 24 inch',     3, 2, 2,  3800000,  '2024-06-01', '2027-06-01', 5, N'In_Use',      N'Màn hình lab CNTT 2'),
(16, 'MON-2023-002', N'Dell E2222H 22 inch',         3, 3, 9,  3200000,  '2023-03-01', '2025-03-01', 2, N'Broken',      N'2 màn hình bị hỏng panel'),

-- Máy in (3 cái)
(17, 'PRT-2023-001', N'HP LaserJet Pro M404dn',     4, 5, 9,  7500000,  '2023-01-15', '2026-01-15', 1, N'In_Use',      N'Máy in phòng Hành chính'),
(18, 'PRT-2024-001', N'Canon LBP6030',              4, 4, 10, 3500000,  '2024-03-01', '2027-03-01', 1, N'In_Use',      N'Máy in phòng Tài chính'),
(19, 'PRT-2023-002', N'Brother HL-L2321D',          4, 4, 14, 4200000,  '2023-06-01', '2025-06-01', 1, N'Liquidated',  N'Đã thanh lý - hỏng nặng'),

-- Máy chiếu (3 cái)
(20, 'PRJ-2023-001', N'Epson EB-X51',               5, 4, 4,  12000000, '2023-09-01', '2026-09-01', 1, N'In_Use',      N'Máy chiếu phòng 201'),
(21, 'PRJ-2024-001', N'BenQ MH560',                 5, 2, 12, 9500000,  '2024-01-10', '2027-01-10', 1, N'In_Use',      N'Máy chiếu phòng Họp A'),
(22, 'PRJ-2025-001', N'Epson EB-E01',               5, 4, NULL, 8000000, '2025-02-01', '2028-02-01', 2, N'New',        N'2 máy chiếu mới nhập kho'),

-- Bàn ghế (3 lot)
(23, 'FUR-2022-001', N'Bàn học sinh đơn',           6, 4, 4,  1200000,  '2022-08-01', NULL,          50, N'In_Use',    N'50 bàn phòng 201'),
(24, 'FUR-2022-002', N'Ghế xoay văn phòng',         6, 4, 9,  2500000,  '2022-08-01', NULL,          10, N'In_Use',    N'10 ghế phòng Hành chính'),
(25, 'FUR-2024-001', N'Bàn máy tính lab',           6, 4, 1,  1800000,  '2024-03-01', NULL,          40, N'In_Use',    N'40 bàn lab CNTT 1'),

-- Điều hòa (3 cái)
(26, 'AC-2023-001',  N'Daikin Inverter 18000BTU',   7, 4, 1,  15000000, '2023-05-01', '2026-05-01', 2, N'In_Use',      N'2 điều hòa lab CNTT 1'),
(27, 'AC-2023-002',  N'Daikin Inverter 12000BTU',   7, 4, 11, 11000000, '2023-05-01', '2026-05-01', 1, N'In_Use',      N'Điều hòa phòng Giám đốc'),
(28, 'AC-2024-001',  N'Panasonic CU/CS-N12WKH',    7, 4, 4,  9500000,  '2024-04-01', '2027-04-01', 2, N'In_Use',      N'2 điều hòa phòng 201'),

-- Thiết bị mạng (3 cái)
(29, 'NET-2023-001', N'Cisco Catalyst 2960-X',      8, 1, 14, 25000000, '2023-01-01', '2028-01-01', 1, N'In_Use',      N'Switch core tầng 1'),
(30, 'NET-2024-001', N'TP-Link Archer AX73',        8, 2, 1,  3200000,  '2024-06-01', '2027-06-01', 3, N'In_Use',      N'3 router wifi lab CNTT'),
(31, 'NET-2024-002', N'Ubiquiti UniFi AP AC Pro',   8, 1, 4,  4500000,  '2024-06-01', '2027-06-01', 2, N'In_Use',      N'2 access point'),

-- Quạt (2 lot)
(32, 'FAN-2023-001', N'Quạt trần Panasonic F-56MZG',9, 4, 4,  2800000, '2023-03-01', '2025-03-01', 4, N'In_Use',      N'4 quạt trần phòng 201'),
(33, 'FAN-2024-001', N'Quạt đứng Midea FS40-18BR', 9, 4, 8,  1500000,  '2024-05-01', '2026-05-01', 3, N'In_Use',      N'3 quạt xưởng Cơ khí'),

-- Thiết bị khác
(34, 'OTH-2024-001', N'Bảng tương tác thông minh',  10, 1, 12, 35000000, '2024-09-01', '2027-09-01', 1, N'In_Use',    N'Bảng thông minh phòng Họp A'),
(35, 'OTH-2023-001', N'Tủ rack 42U',                10, 1, 14, 8000000,  '2023-01-01', '2028-01-01', 1, N'In_Use',     N'Tủ rack chứa thiết bị mạng');
SET IDENTITY_INSERT assets OFF;
GO

-- 8. Asset Images (mỗi tài sản tiêu biểu 1-2 ảnh)
INSERT INTO asset_images (asset_id, image_url, description) VALUES
(1,  'images/assets/LAP-001_front.jpg',          N'Mặt trước Dell Latitude 5540'),
(3,  'images/assets/LAP-003_front.jpg',          N'HP ProBook 450 G10'),
(5,  'images/assets/LAP-004_front.jpg',          N'Lenovo ThinkPad E14'),
(5,  'images/assets/LAP-004_damage.jpg',         N'Ảnh hỏng bàn phím'),
(7,  'images/assets/pc001.jpg',                  N'Dell OptiPlex 7010'),
(8,  'images/assets/pc002.jpg',                  N'HP ProDesk 400 G9'),
(10, 'images/assets/maintenance_pc003.jpg',       N'PC đang bảo trì'),
(13, 'images/assets/monitor001.jpg',              N'Dell P2422H'),
(14, 'images/assets/monitor002.jpg',              N'LG 27UL500 4K'),
(16, 'images/assets/monitor003.jpg',              N'Dell E2222H bị hỏng'),
(17, 'images/assets/printer001.jpg',              N'HP LaserJet Pro'),
(18, 'images/assets/printer002.jpg',              N'Canon LBP6030'),
(20, 'images/assets/projector001.jpg',            N'Epson EB-X51'),
(21, 'images/assets/projector002.jpg',            N'BenQ MH560'),
(29, 'images/assets/router001.jpg',               N'Cisco Catalyst 2960-X'),
(30, 'images/assets/router001.jpg',               N'TP-Link Archer AX73');
GO

-- ==========================================================
-- TẦNG 4: NGHIỆP VỤ (Demo flow)
-- ==========================================================

-- 9. Allocation Requests (6 yêu cầu cấp phát - đủ trạng thái)
SET IDENTITY_INSERT allocation_requests ON;
INSERT INTO allocation_requests (request_id, created_by, created_date, approved_by, approved_date, completed_date, status, reason, reason_reject) VALUES
-- Pending: GV CNTT yêu cầu laptop mới
(1, 5, '2025-02-10', NULL,  NULL,         NULL,         N'Pending',
   N'Xin cấp phát 2 laptop cho giảng dạy môn Lập trình Web', NULL),
-- Approved_By_Staff: NV quản lý đã duyệt
(2, 7, '2025-02-05', 3,     '2025-02-06', NULL,         N'Approved_By_Staff',
   N'Xin cấp phát máy chiếu cho phòng 202', NULL),
-- Approved_By_VP: TP Tài chính đã duyệt
(3, 8, '2025-01-20', 2,     '2025-01-22', NULL,         N'Approved_By_VP',
   N'Xin cấp phát 3 PC cho lab Điện tử', NULL),
-- Completed: Đã cấp phát xong
(4, 5, '2025-01-05', 2,     '2025-01-06', '2025-01-10', N'Completed',
   N'Cấp phát màn hình cho lab CNTT 2', NULL),
-- Rejected: Bị từ chối
(5, 9, '2025-02-01', NULL,  NULL,         NULL,         N'Rejected',
   N'Xin cấp phát 10 laptop cho xưởng Cơ khí', N'Số lượng yêu cầu vượt quá ngân sách quý'),
-- Pending: GV Kinh tế yêu cầu
(6, 7, '2025-02-20', NULL,  NULL,         NULL,         N'Pending',
   N'Xin cấp phát 2 máy in cho phòng 202', NULL);
SET IDENTITY_INSERT allocation_requests OFF;
GO

-- Allocation Details
INSERT INTO allocation_details (request_id, asset_id, quantity, note) VALUES
(1, 4,  2, N'Laptop Dell Inspiron mới nhập kho'),
(2, 22, 1, N'Máy chiếu Epson mới'),
(3, 12, 3, N'PC Dell Vostro từ kho'),
(4, 15, 5, N'Màn hình Samsung cho lab'),
(5, 6,  10, N'Laptop Acer Aspire'),
(6, 18, 1, N'Máy in Canon'),
(6, 17, 1, N'Máy in HP');
GO

-- 10. Transfer Orders (4 phiếu điều chuyển - đủ trạng thái)
SET IDENTITY_INSERT transfer_orders ON;
INSERT INTO transfer_orders (transfer_id, created_by, source_room_id, dest_room_id, created_date, approved_by, approved_date, completed_date, rejected_by, rejected_date, reason_reject, status, note) VALUES
-- Completed: Chuyển PC từ lab 1 sang lab 3
(1, 3, 1, 3,  '2025-01-15', 2, '2025-01-16', '2025-01-18', NULL, NULL, NULL,
   N'Completed', N'Điều chuyển 2 PC sang lab CNTT 3 theo yêu cầu'),
-- Approved: Chuyển máy chiếu sang phòng họp
(2, 3, 4, 13, '2025-02-10', 2, '2025-02-11', NULL,          NULL, NULL, NULL,
   N'Approved',  N'Chuyển máy chiếu sang phòng Họp B'),
-- Pending: Chờ duyệt
(3, 4, 9, 10, '2025-02-20', NULL, NULL,       NULL,          NULL, NULL, NULL,
   N'Pending',   N'Chuyển 1 máy in từ Hành chính sang Tài chính'),
-- Rejected: Bị từ chối
(4, 4, 1, 8,  '2025-02-18', NULL, NULL,       NULL,          2,    '2025-02-19', N'Router cần thiết cho lab CNTT, không thể chuyển',
   N'Rejected',  N'Chuyển router wifi sang xưởng Cơ khí');
SET IDENTITY_INSERT transfer_orders OFF;
GO

-- Transfer Details
INSERT INTO transfer_details (transfer_id, asset_id, status_at_transfer, transfer_date) VALUES
(1, 7,  N'In_Use',  '2025-01-18'),
(2, 20, N'In_Use',  '2025-02-10'),
(3, 17, N'In_Use',  '2025-02-20'),
(4, 30, N'In_Use',  '2025-02-18');
GO

-- 11. Maintenance Requests (5 yêu cầu bảo trì - đủ trạng thái)
INSERT INTO maintenance_requests (asset_id, reported_by_guest, reported_by_user_id, issue_description, image_proof_url, status, cost, technician_note) VALUES
-- Reported: GV vừa báo
(5,  NULL, 5, N'Bàn phím laptop không hoạt động, nhiều phím bị liệt',
    'images/assets/LAP-004_damage.jpg', N'Reported', 0, NULL),
-- Verified: Đã xác nhận
(10, NULL, 8, N'3 bộ PC bị lỗi nguồn, tự tắt sau 30 phút sử dụng',
    'images/assets/maintenance_pc003.jpg', N'Verified', 0, N'Đã kiểm tra, cần thay PSU'),
-- In_Progress: Đang sửa
(16, NULL, 3, N'2 màn hình bị hỏng panel, hiện sọc dọc',
    'images/assets/monitor003.jpg', N'In_Progress', 3200000, N'Đang chờ linh kiện thay thế'),
-- Fixed: Đã sửa xong
(32, NULL, 9, N'Quạt trần phát ra tiếng kêu lạ, quay chậm',
    'images/assets/maintenance_fan001.jpg', N'Fixed', 500000, N'Đã thay bạc đạn và bôi trơn'),
-- Cannot_Fix: Không sửa được
(19, NULL, 3, N'Máy in hỏng trục kéo giấy, rò rỉ mực',
    'images/assets/maintenance_printer001.jpg', N'Cannot_Fix', 0, N'Hỏng nặng, đề xuất thanh lý');
GO

-- 12. Procurement Requests (4 yêu cầu mua sắm - đủ trạng thái)
SET IDENTITY_INSERT procurement_requests ON;
INSERT INTO procurement_requests (procurement_id, created_by, created_date, approved_by, approved_date, rejected_by, rejected_date, reason_reject, status, reason, allocation_request_id) VALUES
-- Pending: Chờ duyệt
(1, 3, '2025-02-15', NULL, NULL, NULL, NULL, NULL,
   N'Pending',   N'Mua thêm laptop cho nhu cầu giảng dạy HK2', NULL),
-- Approved: Đã duyệt
(2, 3, '2025-01-10', 2,   '2025-01-12', NULL, NULL, NULL,
   N'Approved',  N'Mua bổ sung PC cho lab mới', NULL),
-- Completed: Đã mua xong
(3, 4, '2024-12-01', 2,   '2024-12-03', NULL, NULL, NULL,
   N'Completed', N'Mua máy chiếu cho phòng họp',  NULL),
-- Rejected: Bị từ chối
(4, 3, '2025-02-01', NULL, NULL, 2, '2025-02-03',
   N'Ngân sách quý 1 đã hết, chuyển sang quý 2',
   N'Rejected',  N'Mua 20 bộ bàn ghế mới cho phòng 301', NULL);
SET IDENTITY_INSERT procurement_requests OFF;
GO

-- Procurement Details
INSERT INTO procurement_details (procurement_id, asset_id, quantity, note) VALUES
(1, 6,  5,  N'Laptop Acer Aspire 5 - bổ sung thêm'),
(2, 12, 10, N'PC Dell Vostro 3020'),
(3, 22, 2,  N'Máy chiếu Epson EB-E01'),
(4, 23, 20, N'Bàn học sinh đơn');
GO

-- 13. Asset History (log các thao tác)
INSERT INTO asset_history (asset_id, action, performed_by, description, action_date) VALUES
-- Tạo mới
(1,  N'Created',     3, N'Nhập kho laptop Dell Latitude 5540',             '2024-03-15'),
(7,  N'Created',     3, N'Nhập kho 5 bộ PC Dell OptiPlex 7010',           '2023-09-01'),
(12, N'Created',     4, N'Nhập kho 10 bộ PC Dell Vostro 3020',            '2025-01-20'),
-- Cấp phát
(1,  N'Allocated',   3, N'Cấp phát cho lab CNTT 1, phòng 101',            '2024-03-20'),
(15, N'Allocated',   3, N'Cấp phát 5 màn hình cho lab CNTT 2',            '2025-01-10'),
-- Điều chuyển
(7,  N'Transferred', 3, N'Điều chuyển từ lab CNTT 1 sang lab CNTT 3',     '2025-01-18'),
-- Bảo trì
(5,  N'Maintenance', 5, N'Báo hỏng bàn phím laptop ThinkPad E14',        '2025-02-10'),
(10, N'Maintenance', 8, N'Báo lỗi nguồn 3 bộ PC HP EliteDesk',           '2025-02-05'),
(16, N'Broken',      3, N'Xác nhận 2 màn hình hỏng panel, chuyển Broken', '2025-02-08'),
-- Thanh lý
(19, N'Liquidated',  3, N'Thanh lý máy in Brother HL-L2321D - hỏng nặng', '2025-02-15'),
-- Cập nhật trạng thái
(32, N'Status_Change', 3, N'Sửa xong quạt trần, chuyển về In_Use',       '2025-02-12');
GO

PRINT N'✅ Đã tạo xong dữ liệu mẫu cho hệ thống CFMS!';
PRINT N'   - 4 roles, 6 departments, 10 categories, 5 suppliers';
PRINT N'   - 15 rooms, 10 users (password: 123456)';
PRINT N'   - 35 assets (đủ 6 trạng thái)';
PRINT N'   - 6 allocation requests, 4 transfer orders';
PRINT N'   - 5 maintenance requests, 4 procurement requests';
PRINT N'   - 11 asset history logs';
GO
