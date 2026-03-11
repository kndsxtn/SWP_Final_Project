-- ==========================================================
-- DỮ LIỆU MẪU - HỆ THỐNG QUẢN LÝ TÀI SẢN (CFMS)
-- Cập nhật: 10/03/2026 - Khớp với db_draft.sql mới
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

-- 2. Departments (5 phòng ban)
SET IDENTITY_INSERT departments ON;
INSERT INTO departments (dept_id, dept_name, description) VALUES
(1, N'Khoa Công nghệ Thông tin',     N'Đào tạo CNTT, Phần mềm, An toàn thông tin'),
(2, N'Khoa Kinh tế',                 N'Đào tạo Kế toán, Quản trị kinh doanh'),
(3, N'Khoa Điện - Điện tử',          N'Đào tạo Điện tử, Viễn thông, Tự động hóa'),
(4, N'Khoa Cơ khí',                  N'Đào tạo Cơ khí chế tạo, Ô tô'),
(5, N'Phòng Hành chính - Tài chính', N'Quản lý hành chính, tài chính, mua sắm');
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

-- 5. Rooms (25 phòng = 5 khoa × 5 phòng)
SET IDENTITY_INSERT rooms ON;
INSERT INTO rooms (room_id, room_name, dept_id, capacity) VALUES
-- Khoa CNTT (dept 1)
(1,  N'Lab CNTT 1',           1, 40),
(2,  N'Lab CNTT 2',           1, 35),
(3,  N'Lab CNTT 3',           1, 30),
(4,  N'Phòng Seminar CNTT',   1, 20),
(5,  N'Kho thiết bị CNTT',    1, NULL),
-- Khoa Kinh tế (dept 2)
(6,  N'Phòng học 201',        2, 50),
(7,  N'Phòng học 202',        2, 50),
(8,  N'Lab Kinh tế',          2, 30),
(9,  N'Phòng Seminar KT',     2, 20),
(10, N'Kho thiết bị KT',      2, NULL),
-- Khoa Điện - Điện tử (dept 3)
(11, N'Lab Điện tử',          3, 25),
(12, N'Lab Viễn thông',       3, 25),
(13, N'Phòng TH Điện',        3, 30),
(14, N'Phòng Seminar ĐĐT',   3, 20),
(15, N'Kho thiết bị ĐĐT',    3, NULL),
-- Khoa Cơ khí (dept 4)
(16, N'Xưởng CNC',            4, 20),
(17, N'Xưởng Hàn',            4, 20),
(18, N'Phòng Đo lường',       4, 15),
(19, N'Phòng Seminar CK',     4, 20),
(20, N'Kho thiết bị CK',      4, NULL),
-- Phòng HC - TC (dept 5)
(21, N'Phòng Hành chính',     5, 10),
(22, N'Phòng Tài chính',      5, 8),
(23, N'Phòng Giám đốc',       5, 5),
(24, N'Phòng Họp A',          5, 20),
(25, N'Kho tổng',             5, NULL);
SET IDENTITY_INSERT rooms OFF;
GO

-- 6. Users (15 người dùng, mỗi role >= 2) - password = '123456'
SET IDENTITY_INSERT users ON;
INSERT INTO users (user_id, username, password_hash, full_name, email, phone, role_id, dept_id, status) VALUES
-- Role 1: Admin (2 người)
(1,  'admin1',      '123456', N'Nguyễn Quản Trị',      'admin1@cfms.edu.vn',     '0901000001', 1, 5, N'Active'),
(2,  'admin2',      '123456', N'Lê Thị Admin',         'admin2@cfms.edu.vn',     '0901000002', 1, 5, N'Active'),
-- Role 2: Finance Head (2 người)
(3,  'tptaichinh1', '123456', N'Trần Văn Tài',         'tai.tv@cfms.edu.vn',     '0901000003', 2, 5, N'Active'),
(4,  'tptaichinh2', '123456', N'Phạm Thị Phương',      'phuong.pt@cfms.edu.vn',  '0901000004', 2, 5, N'Active'),
-- Role 3: Asset Staff (2 người)
(5,  'nvquanly1',   '123456', N'Lê Thị Quản',          'quan.lt@cfms.edu.vn',    '0901000005', 3, 5, N'Active'),
(6,  'nvquanly2',   '123456', N'Phạm Minh Lý',         'ly.pm@cfms.edu.vn',      '0901000006', 3, 5, N'Active'),
-- Role 4: Head of Dept (7 người - đủ các khoa)
(7,  'gv_cntt1',    '123456', N'Hoàng Văn Nam',        'nam.hv@cfms.edu.vn',     '0901000007', 4, 1, N'Active'),
(8,  'gv_cntt2',    '123456', N'Vũ Thị Lan',           'lan.vt@cfms.edu.vn',     '0901000008', 4, 1, N'Active'),
(9,  'gv_kinhte1',  '123456', N'Đỗ Thanh Hà',          'ha.dt@cfms.edu.vn',      '0901000009', 4, 2, N'Active'),
(10, 'gv_kinhte2',  '123456', N'Nguyễn Thị Mai',       'mai.nt@cfms.edu.vn',     '0901000010', 4, 2, N'Active'),
(11, 'gv_dien',     '123456', N'Ngô Quốc Bảo',         'bao.nq@cfms.edu.vn',     '0901000011', 4, 3, N'Active'),
(12, 'gv_cokhi',    '123456', N'Bùi Đức Mạnh',         'manh.bd@cfms.edu.vn',    '0901000012', 4, 4, N'Active'),
(13, 'gv_inactive', '123456', N'Trương Thị Ngọc',      'ngoc.tt@cfms.edu.vn',    '0901000013', 4, 1, N'Inactive'),
-- Role 5: Principal (2 người)
(14, 'hieutruong1', '123456', N'Đoàn Hiệu Trưởng',    'hieutruong@cfms.edu.vn', '0901000014', 5, 5, N'Active'),
(15, 'hieutruong2', '123456', N'Lý Phó Hiệu Trưởng',  'phohieu@cfms.edu.vn',    '0901000015', 5, 5, N'Active');
SET IDENTITY_INSERT users OFF;
GO

-- ==========================================================
-- TẦNG 3: TÀI SẢN
-- ==========================================================

-- 7. Assets (17 lô - KHÔNG có room_id, status)
SET IDENTITY_INSERT assets ON;
INSERT INTO assets (asset_id, asset_code, asset_name, category_id, supplier_id, price, purchase_date, warranty_expiry_date, quantity, description) VALUES
-- Laptop (2 lô)
(1,  'LAP-2024-001', N'Dell Latitude 5540',          1, 3, 22000000, '2024-03-15', '2027-03-15', 3, N'Laptop cho giảng viên'),
(2,  'LAP-2025-001', N'Dell Inspiron 15 3520',       1, 3, 15000000, '2025-01-10', '2028-01-10', 3, N'Laptop mới nhập kho'),
-- Máy tính bàn (3 lô)
(3,  'PC-2023-001',  N'Dell OptiPlex 7010',          2, 3, 16000000, '2023-09-01', '2026-09-01', 5, N'Bộ PC cho phòng lab'),
(4,  'PC-2024-001',  N'HP ProDesk 400 G9',           2, 5, 14500000, '2024-06-01', '2027-06-01', 5, N'Bộ PC cho phòng lab'),
(5,  'PC-2025-001',  N'Dell Vostro 3020',            2, 3, 11000000, '2025-01-20', '2028-01-20', 5, N'PC mới nhập kho'),
-- Màn hình (2 lô)
(6,  'MON-2023-001', N'Dell P2422H 24 inch',         3, 3,  5500000, '2023-09-01', '2026-09-01', 5, N'Màn hình cho lab'),
(7,  'MON-2024-001', N'LG 27UL500 27 inch 4K',       3, 2,  8000000, '2024-04-01', '2027-04-01', 3, N'Màn hình cao cấp'),
-- Máy in (2 lô)
(8,  'PRT-2023-001', N'HP LaserJet Pro M404dn',      4, 5,  7500000, '2023-01-15', '2026-01-15', 2, N'Máy in laser'),
(9,  'PRT-2024-001', N'Canon LBP6030',               4, 4,  3500000, '2024-03-01', '2027-03-01', 1, N'Máy in phun mực'),
-- Máy chiếu (2 lô)
(10, 'PRJ-2023-001', N'Epson EB-X51',                5, 4, 12000000, '2023-09-01', '2026-09-01', 2, N'Máy chiếu đa năng'),
(11, 'PRJ-2025-001', N'BenQ MH560',                  5, 2,  9500000, '2025-02-01', '2028-02-01', 2, N'Máy chiếu mới nhập kho'),
-- Bàn ghế (1 lô)
(12, 'FUR-2022-001', N'Bàn học sinh đơn',            6, 4,  1200000, '2022-08-01', NULL,          5, N'Bàn cho phòng học'),
-- Điều hòa (1 lô)
(13, 'AC-2023-001',  N'Daikin Inverter 18000BTU',    7, 4, 15000000, '2023-05-01', '2026-05-01', 3, N'Điều hòa công suất lớn'),
-- Thiết bị mạng (1 lô)
(14, 'NET-2024-001', N'TP-Link Archer AX73',         8, 2,  3200000, '2024-06-01', '2027-06-01', 3, N'Router wifi'),
-- Quạt (1 lô)
(15, 'FAN-2023-001', N'Quạt trần Panasonic F-56MZG', 9, 4,  2800000, '2023-03-01', '2025-03-01', 3, N'Quạt trần công nghiệp'),
-- Thiết bị khác (2 lô)
(16, 'OTH-2024-001', N'Bảng tương tác thông minh',  10, 1, 35000000, '2024-09-01', '2027-09-01', 1, N'Bảng thông minh'),
(17, 'OTH-2023-001', N'Tủ rack 42U',                10, 1,  8000000, '2023-01-01', '2028-01-01', 1, N'Tủ rack chứa thiết bị mạng');
SET IDENTITY_INSERT assets OFF;
GO

-- 8. Asset Images
INSERT INTO asset_images (asset_id, image_url, description) VALUES
(1,  'images/assets/LAP-2024-001_front.jpg',  N'Dell Latitude 5540'),
(2,  'images/assets/LAP-2025-001_front.jpg',  N'Dell Inspiron 15 3520'),
(3,  'images/assets/PC-2023-001.jpg',         N'Dell OptiPlex 7010'),
(4,  'images/assets/PC-2024-001.jpg',         N'HP ProDesk 400 G9'),
(6,  'images/assets/MON-2023-001.jpg',        N'Dell P2422H'),
(7,  'images/assets/MON-2024-001.jpg',        N'LG 27UL500 4K'),
(8,  'images/assets/PRT-2023-001.jpg',        N'HP LaserJet Pro'),
(10, 'images/assets/PRJ-2023-001.jpg',        N'Epson EB-X51'),
(14, 'images/assets/NET-2024-001.jpg',        N'TP-Link Archer AX73'),
(16, 'images/assets/OTH-2024-001.jpg',        N'Bảng tương tác thông minh');
GO

-- 9. Asset Details (52 cá thể = tổng quantity của 17 lô)
SET IDENTITY_INSERT asset_details ON;
INSERT INTO asset_details (instance_id, asset_id, instance_code, room_id, status) VALUES
-- LAP-2024-001 (asset 1, qty 3)
(1,  1, 'LAP-2024-001-001', 1,  N'In_Use'),        -- Lab CNTT 1
(2,  1, 'LAP-2024-001-002', 2,  N'In_Use'),        -- Lab CNTT 2
(3,  1, 'LAP-2024-001-003', 5,  N'Broken'),        -- Kho - hỏng bàn phím
-- LAP-2025-001 (asset 2, qty 3) - mới nhập kho
(4,  2, 'LAP-2025-001-001', 5,  N'In_Stock'),
(5,  2, 'LAP-2025-001-002', 5,  N'In_Stock'),
(6,  2, 'LAP-2025-001-003', 5,  N'In_Stock'),
-- PC-2023-001 (asset 3, qty 5)
(7,  3, 'PC-2023-001-001',  1,  N'In_Use'),        -- Lab CNTT 1
(8,  3, 'PC-2023-001-002',  1,  N'In_Use'),
(9,  3, 'PC-2023-001-003',  3,  N'In_Use'),        -- Đã điều chuyển sang Lab 3
(10, 3, 'PC-2023-001-004',  2,  N'In_Use'),        -- Lab CNTT 2
(11, 3, 'PC-2023-001-005',  2,  N'In_Use'),
-- PC-2024-001 (asset 4, qty 5)
(12, 4, 'PC-2024-001-001',  3,  N'In_Use'),        -- Lab CNTT 3
(13, 4, 'PC-2024-001-002',  3,  N'In_Use'),
(14, 4, 'PC-2024-001-003',  11, N'In_Use'),        -- Lab Điện tử
(15, 4, 'PC-2024-001-004',  11, N'In_Use'),
(16, 4, 'PC-2024-001-005',  11, N'Maintenance'),   -- Đang bảo trì
-- PC-2025-001 (asset 5, qty 5) - mới nhập kho
(17, 5, 'PC-2025-001-001',  5,  N'In_Stock'),
(18, 5, 'PC-2025-001-002',  5,  N'In_Stock'),
(19, 5, 'PC-2025-001-003',  5,  N'In_Stock'),
(20, 5, 'PC-2025-001-004',  5,  N'In_Stock'),
(21, 5, 'PC-2025-001-005',  5,  N'In_Stock'),
-- MON-2023-001 (asset 6, qty 5)
(22, 6, 'MON-2023-001-001', 1,  N'In_Use'),        -- Lab CNTT 1
(23, 6, 'MON-2023-001-002', 1,  N'In_Use'),
(24, 6, 'MON-2023-001-003', 1,  N'In_Use'),
(25, 6, 'MON-2023-001-004', 2,  N'In_Use'),        -- Lab CNTT 2
(26, 6, 'MON-2023-001-005', 2,  N'In_Use'),
-- MON-2024-001 (asset 7, qty 3)
(27, 7, 'MON-2024-001-001', 23, N'In_Use'),        -- Phòng Giám đốc
(28, 7, 'MON-2024-001-002', 21, N'In_Use'),        -- Phòng Hành chính
(29, 7, 'MON-2024-001-003', 5,  N'Broken'),        -- Kho - hỏng panel
-- PRT-2023-001 (asset 8, qty 2)
(30, 8, 'PRT-2023-001-001', 21, N'In_Use'),        -- Phòng Hành chính
(31, 8, 'PRT-2023-001-002', 5,  N'Liquidated'),    -- Đã thanh lý
-- PRT-2024-001 (asset 9, qty 1)
(32, 9, 'PRT-2024-001-001', 22, N'In_Use'),        -- Phòng Tài chính
-- PRJ-2023-001 (asset 10, qty 2)
(33, 10, 'PRJ-2023-001-001', 6,  N'In_Use'),       -- Phòng học 201
(34, 10, 'PRJ-2023-001-002', 24, N'In_Use'),       -- Phòng Họp A
-- PRJ-2025-001 (asset 11, qty 2) - mới nhập kho
(35, 11, 'PRJ-2025-001-001', 25, N'In_Stock'),           -- Kho tổng
(36, 11, 'PRJ-2025-001-002', 25, N'In_Stock'),
-- FUR-2022-001 (asset 12, qty 5)
(37, 12, 'FUR-2022-001-001', 6,  N'In_Use'),       -- Phòng học 201
(38, 12, 'FUR-2022-001-002', 6,  N'In_Use'),
(39, 12, 'FUR-2022-001-003', 7,  N'In_Use'),       -- Phòng học 202
(40, 12, 'FUR-2022-001-004', 7,  N'In_Use'),
(41, 12, 'FUR-2022-001-005', 7,  N'In_Use'),
-- AC-2023-001 (asset 13, qty 3)
(42, 13, 'AC-2023-001-001',  1,  N'In_Use'),       -- Lab CNTT 1
(43, 13, 'AC-2023-001-002',  2,  N'In_Use'),       -- Lab CNTT 2
(44, 13, 'AC-2023-001-003',  23, N'In_Use'),       -- Phòng Giám đốc
-- NET-2024-001 (asset 14, qty 3)
(45, 14, 'NET-2024-001-001', 1,  N'In_Use'),       -- Lab CNTT 1
(46, 14, 'NET-2024-001-002', 2,  N'In_Use'),       -- Lab CNTT 2
(47, 14, 'NET-2024-001-003', 3,  N'In_Use'),       -- Lab CNTT 3
-- FAN-2023-001 (asset 15, qty 3)
(48, 15, 'FAN-2023-001-001', 6,  N'In_Use'),       -- Phòng học 201
(49, 15, 'FAN-2023-001-002', 6,  N'In_Use'),
(50, 15, 'FAN-2023-001-003', 16, N'Maintenance'),  -- Xưởng CNC - đang bảo trì
-- OTH-2024-001 (asset 16, qty 1)
(51, 16, 'OTH-2024-001-001', 24, N'In_Use'),       -- Phòng Họp A
-- OTH-2023-001 (asset 17, qty 1)
(52, 17, 'OTH-2023-001-001', 5,  N'In_Use');       -- Kho CNTT (tủ rack)
SET IDENTITY_INSERT asset_details OFF;
GO

-- ==========================================================
-- TẦNG 4: NGHIỆP VỤ (Demo flow)
-- ==========================================================

-- 10. Allocation Requests (6 yêu cầu cấp phát - đủ trạng thái)
SET IDENTITY_INSERT allocation_requests ON;
INSERT INTO allocation_requests (request_id, created_by, target_room_id, created_date, approved_by, approved_date, completed_date, status, reason, reason_reject) VALUES
(1, 7,  1,  '2025-02-10', NULL, NULL,         NULL,         N'Pending',
   N'Xin cấp phát 2 laptop cho giảng dạy môn Lập trình Web', NULL),
(2, 9,  6,  '2025-02-05', 5,   '2025-02-06', NULL,         N'Approved_By_Staff',
   N'Xin cấp phát máy chiếu cho phòng học 201', NULL),
(3, 11, 11, '2025-01-20', 3,   '2025-01-22', NULL,         N'Approved_By_VP',
   N'Xin cấp phát 3 PC cho lab Điện tử', NULL),
(4, 7,  2,  '2025-01-05', 3,   '2025-01-06', '2025-01-10', N'Completed',
   N'Cấp phát màn hình cho lab CNTT 2', NULL),
(5, 12, 16, '2025-02-01', NULL, NULL,         NULL,         N'Rejected',
   N'Xin cấp phát 10 laptop cho xưởng Cơ khí', N'Số lượng yêu cầu vượt quá ngân sách quý'),
(6, 9,  7,  '2025-02-20', NULL, NULL,         NULL,         N'Pending',
   N'Xin cấp phát 2 máy in cho phòng 202', NULL);
SET IDENTITY_INSERT allocation_requests OFF;
GO

-- Allocation Details (vẫn dùng asset_id - cấp phát theo lô)
INSERT INTO allocation_details (request_id, asset_id, quantity, note) VALUES
(1, 2,  2, N'Laptop Dell Inspiron mới nhập kho'),
(2, 11, 1, N'Máy chiếu BenQ mới'),
(3, 5,  3, N'PC Dell Vostro từ kho'),
(4, 6,  5, N'Màn hình Dell cho lab'),
(5, 2,  10, N'Laptop Dell Inspiron'),
(6, 9,  1, N'Máy in Canon'),
(6, 8,  1, N'Máy in HP');
GO

-- 11. Transfer Orders (4 phiếu điều chuyển - đủ trạng thái)
SET IDENTITY_INSERT transfer_orders ON;
INSERT INTO transfer_orders (transfer_id, created_by, source_room_id, dest_room_id, created_date, approved_by, approved_date, completed_date, rejected_by, rejected_date, reason_reject, status, note) VALUES
(1, 5, 1, 3,  '2025-01-15', 3, '2025-01-16', '2025-01-18', NULL, NULL, NULL,
   N'Completed', N'Điều chuyển PC sang lab CNTT 3'),
(2, 5, 6, 24, '2025-02-10', 3, '2025-02-11', NULL,         NULL, NULL, NULL,
   N'Approved',  N'Chuyển máy chiếu sang phòng Họp A'),
(3, 6, 21, 22, '2025-02-20', NULL, NULL,      NULL,         NULL, NULL, NULL,
   N'Pending',   N'Chuyển máy in từ Hành chính sang Tài chính'),
(4, 6, 1, 16, '2025-02-18', NULL, NULL,       NULL,         3,    '2025-02-19', N'Router cần thiết cho lab CNTT',
   N'Rejected',  N'Chuyển router wifi sang xưởng CNC');
SET IDENTITY_INSERT transfer_orders OFF;
GO

-- Transfer Details (dùng instance_id - điều chuyển theo cá thể)
INSERT INTO transfer_details (transfer_id, instance_id, status_at_transfer, transfer_date) VALUES
(1, 9,  N'In_Use', '2025-01-18'),   -- PC-2023-001-003: Lab 1 → Lab 3
(2, 34, N'In_Use', '2025-02-10'),   -- PRJ-2023-001-002: PH 201 → Họp A
(3, 30, N'In_Use', '2025-02-20'),   -- PRT-2023-001-001: HC → TC
(4, 45, N'In_Use', '2025-02-18');   -- NET-2024-001-001: Lab 1 → Xưởng CNC
GO

-- 12. Maintenance Requests (5 yêu cầu - dùng instance_id)
INSERT INTO maintenance_requests (instance_id, reported_by_guest, reported_by_user_id, issue_description, image_proof_url, status, cost, technician_note) VALUES
-- Reported
(3,  NULL, 7,  N'Bàn phím laptop không hoạt động, nhiều phím bị liệt',
    'images/maintenance/LAP-2024-001-003.jpg', N'Reported', 0, NULL),
-- Verified
(16, NULL, 11, N'PC bị lỗi nguồn, tự tắt sau 30 phút sử dụng',
    'images/maintenance/PC-2024-001-005.jpg', N'Verified', 0, N'Đã kiểm tra, cần thay PSU'),
-- In_Progress
(29, NULL, 5,  N'Màn hình bị hỏng panel, hiện sọc dọc',
    'images/maintenance/MON-2024-001-003.jpg', N'In_Progress', 3200000, N'Đang chờ linh kiện thay thế'),
-- Fixed
(50, NULL, 12, N'Quạt trần phát ra tiếng kêu lạ, quay chậm',
    'images/maintenance/FAN-2023-001-003.jpg', N'Fixed', 500000, N'Đã thay bạc đạn và bôi trơn'),
-- Cannot_Fix
(31, NULL, 5,  N'Máy in hỏng trục kéo giấy, rò rỉ mực',
    'images/maintenance/PRT-2023-001-002.jpg', N'Cannot_Fix', 0, N'Hỏng nặng, đề xuất thanh lý');
GO

-- 13. Procurement Requests (4 yêu cầu mua sắm)
SET IDENTITY_INSERT procurement_requests ON;
INSERT INTO procurement_requests (procurement_id, created_by, created_date, approved_by, approved_date, rejected_by, rejected_date, reason_reject, status, reason, allocation_request_id) VALUES
(1, 5, '2025-02-15', NULL, NULL,         NULL, NULL, NULL,
   N'Pending',   N'Mua thêm laptop cho nhu cầu giảng dạy HK2', NULL),
(2, 5, '2025-01-10', 3,   '2025-01-12', NULL, NULL, NULL,
   N'Approved',  N'Mua bổ sung PC cho lab mới', NULL),
(3, 6, '2024-12-01', 3,   '2024-12-03', NULL, NULL, NULL,
   N'Completed', N'Mua máy chiếu cho phòng họp', NULL),
(4, 5, '2025-02-01', NULL, NULL,         3,   '2025-02-03',
   N'Ngân sách quý 1 đã hết, chuyển sang quý 2',
   N'Rejected',  N'Mua 20 bộ bàn ghế mới cho phòng 301', NULL);
SET IDENTITY_INSERT procurement_requests OFF;
GO

-- Procurement Details (dùng asset_id - mua sắm theo lô)
INSERT INTO procurement_details (procurement_id, asset_id, quantity, note) VALUES
(1, 2,  5,  N'Laptop Dell Inspiron - bổ sung thêm'),
(2, 5,  10, N'PC Dell Vostro 3020'),
(3, 11, 2,  N'Máy chiếu BenQ MH560'),
(4, 12, 20, N'Bàn học sinh đơn');
GO

-- 14. Asset History (dùng instance_id - lịch sử theo cá thể)
INSERT INTO asset_history (instance_id, action, performed_by, description, action_date) VALUES
-- Tạo mới / Nhập kho
(1,  N'Created',       5, N'Nhập kho laptop Dell Latitude 5540',           '2024-03-15'),
(7,  N'Created',       5, N'Nhập kho PC Dell OptiPlex 7010',              '2023-09-01'),
(17, N'Created',       6, N'Nhập kho PC Dell Vostro 3020',               '2025-01-20'),
-- Cấp phát
(1,  N'Allocated',     5, N'Cấp phát cho Lab CNTT 1',                    '2024-03-20'),
(25, N'Allocated',     5, N'Cấp phát màn hình cho Lab CNTT 2',           '2025-01-10'),
-- Điều chuyển
(9,  N'Transferred',   5, N'Điều chuyển từ Lab CNTT 1 sang Lab CNTT 3',  '2025-01-18'),
-- Bảo trì
(3,  N'Maintenance',   7, N'Báo hỏng bàn phím laptop',                  '2025-02-10'),
(16, N'Maintenance',  11, N'Báo lỗi nguồn PC HP ProDesk',               '2025-02-05'),
(29, N'Broken',        5, N'Xác nhận màn hình hỏng panel',              '2025-02-08'),
-- Thanh lý
(31, N'Liquidated',    5, N'Thanh lý máy in Brother - hỏng nặng',       '2025-02-15'),
-- Sửa xong
(50, N'Status_Change', 5, N'Sửa xong quạt trần, chuyển về Maintenance', '2025-02-12');
GO

PRINT N'✅ Đã tạo xong dữ liệu mẫu cho hệ thống CFMS!';
PRINT N'   - 5 roles, 5 departments, 10 categories, 5 suppliers';
PRINT N'   - 25 rooms (5 rooms/dept), 15 users (≥2/role, password: 123456)';
PRINT N'   - 17 lô tài sản, 52 cá thể (asset_details)';
PRINT N'   - 6 allocation requests, 4 transfer orders';
PRINT N'   - 5 maintenance requests, 4 procurement requests';
PRINT N'   - 11 asset history logs';
GO
