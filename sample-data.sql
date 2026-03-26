-- ==========================================================
-- DỮ LIỆU MẪU - HỆ THỐNG QUẢN LÝ TÀI SẢN (CFMS)
-- Cập nhật: 27/03/2026 (Tên người thật, Nhiều dữ liệu, Ngày sát hiện tại)
-- Chạy SAU khi đã tạo bảng từ db_draft.sql
-- ==========================================================

USE swp_draft;
GO

-- XÓA DỮ LIỆU CŨ TRƯỚC KHI CHẠY (Nếu cần thiết để tránh lỗi Identity)
/*
EXEC sp_MSForEachTable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'
EXEC sp_MSForEachTable 'DELETE FROM ?'
EXEC sp_MSForEachTable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL'
*/

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

-- 4. Suppliers (8 nhà cung cấp)
SET IDENTITY_INSERT suppliers ON;
INSERT INTO suppliers (supplier_id, supplier_name, contact_person, email, phone, address) VALUES
(1, N'Công ty CP Bán lẻ Kỹ thuật số FPT', N'Nguyễn Hoàng Cường',   'cuongnh@fpt.com.vn', '0981234567', N'261 - 263 Khánh Hội, Q.4, TP.HCM'),
(2, N'Phong Vũ Computer',                 N'Trần Minh Khang',      'khangtm@phongvu.vn', '0902345678', N'65 Trần Hưng Đạo, Q.1, TP.HCM'),
(3, N'Dell Technologies Việt Nam',         N'Lê Hải Yến',           'hai.yen@dell.com',   '0913456789', N'Keangnam Tower, Nam Từ Liêm, Hà Nội'),
(4, N'Nội Thất Hòa Phát',                 N'Phạm Thu Thảo',        'thaopt@hoaphat.vn',  '0934567890', N'39 Nguyễn Đình Chiểu, Q.3, TP.HCM'),
(5, N'HP Việt Nam',                        N'Hoàng Vĩnh Phát',      'vinh.phat@hp.com',   '0945678901', N'Bitexco Tower, Q.1, TP.HCM'),
(6, N'Điện Máy Xanh (B2B)',               N'Vũ Thị Hồng Nhung',    'nhungvh@thegioididong.com', '0978123456', N'Khu CNC, Q.9, TP.HCM'),
(7, N'Công Ty Viễn Thông An Bình',         N'Đặng Quốc Bảo',        'baodq@anbinhtelecom.vn', '0967890123', N'15 Phạm Hùng, Cầu Giấy, Hà Nội'),
(8, N'GearVN Doanh Nghiệp',               N'Trịnh Đình Quang',     'quangtd@gearvn.com', '0923456789', N'78-80 Hoàng Hoa Thám, Tân Bình, TP.HCM');
SET IDENTITY_INSERT suppliers OFF;
GO

-- ==========================================================
-- TẦNG 2: PHỤ THUỘC TẦNG 1
-- ==========================================================

-- 5. Rooms (25 phòng)
SET IDENTITY_INSERT rooms ON;
INSERT INTO rooms (room_id, room_name, dept_id, capacity) VALUES
(1,  N'Lab CNTT 1 (Phòng Mac)', 1, 40), (2,  N'Lab CNTT 2 (Software)',   1, 35),
(3,  N'Lab CNTT 3 (Network)',   1, 30), (4,  N'Phòng Seminar CNTT',      1, 20),
(5,  N'Kho thiết bị CNTT',      1, NULL),
(6,  N'Phòng học 201 (Kte)',    2, 50), (7,  N'Phòng học 202 (Kte)',     2, 50),
(8,  N'Lab Kế toán Ảo',         2, 30), (9,  N'Phòng Seminar Kinh tế',   2, 20),
(10, N'Kho thiết bị KT',        2, NULL),
(11, N'Lab Điện tử cơ bản',     3, 25), (12, N'Lab Viễn thông',          3, 25),
(13, N'Phòng TH Tự động hóa',   3, 30), (14, N'Phòng Seminar ĐĐT',      3, 20),
(15, N'Kho thiết bị ĐĐT',       3, NULL),
(16, N'Xưởng CNC & Robot',      4, 20), (17, N'Xưởng Cơ khí động lực',   4, 20),
(18, N'Phòng Đo lường',         4, 15), (19, N'Phòng Seminar Cơ khí',    4, 20),
(20, N'Kho thiết bị Cơ khí',    4, NULL),
(21, N'Phòng Hành chính Tổng hợp',5, 10),(22, N'Phòng Kế toán - Tài vụ',  5, 8),
(23, N'Phòng Ban Giám đốc',     5, 5),  (24, N'Phòng Họp VIP A',         5, 20),
(25, N'Kho Tổng (Trường)',      5, NULL);
SET IDENTITY_INSERT rooms OFF;
GO

-- 6. Users (30 người dùng với tên thật Việt Nam)
SET IDENTITY_INSERT users ON;
INSERT INTO users (user_id, username, password_hash, full_name, email, phone, role_id, dept_id, status, created_at) VALUES
-- Admin
(1,  'hoangnm',     '123456', N'Nguyễn Minh Hoàng',    'hoangnm@cfms.edu.vn',    '0901000101', 1, 5, N'Active', '2025-01-01'),
(2,  'giangttt',    '123456', N'Trần Thị Thanh Giang', 'giangttt@cfms.edu.vn',   '0901000102', 1, 5, N'Active', '2025-01-01'),
-- Finance Head
(3,  'bachlh',      '123456', N'Lê Hoàng Bách',        'bachlh@cfms.edu.vn',     '0901000103', 2, 5, N'Active', '2025-01-01'),
(4,  'yenvn',       '123456', N'Vũ Ngọc Yến',          'yenvn@cfms.edu.vn',      '0901000104', 2, 5, N'Active', '2025-01-01'),
(5,  'tuanpa',      '123456', N'Phạm Anh Tuấn',        'tuanpa@cfms.edu.vn',     '0901000105', 2, 5, N'Active', '2025-01-01'),
-- Asset Staff
(6,  'manhpd',      '123456', N'Phan Đức Mạnh',        'manhpd@cfms.edu.vn',     '0901000106', 3, 5, N'Active', '2025-01-01'),
(7,  'huongdt',     '123456', N'Đỗ Thu Hương',         'huongdt@cfms.edu.vn',    '0901000107', 3, 5, N'Active', '2025-01-01'),
(8,  'linhhk',      '123456', N'Hoàng Khánh Linh',     'linhhk@cfms.edu.vn',     '0901000108', 3, 5, N'Active', '2025-01-01'),
(9,  'dungbt',      '123456', N'Bùi Tiến Dũng',        'dungbt@cfms.edu.vn',     '0901000109', 3, 5, N'Active', '2025-01-01'),
-- Head of Dept / Teachers (CNTT - 1)
(10, 'dangnh',      '123456', N'Nguyễn Hải Đăng',      'dangnh@cfms.edu.vn',     '0901000110', 4, 1, N'Active', '2025-01-01'),
(11, 'phuongph',    '123456', N'Phạm Hoàng Phương',    'phuongph@cfms.edu.vn',   '0901000111', 4, 1, N'Active', '2025-01-01'),
(12, 'thaolt',      '123456', N'Lê Thu Thảo',          'thaolt@cfms.edu.vn',     '0901000112', 4, 1, N'Active', '2025-01-01'),
(13, 'thaidv',      '123456', N'Đinh Văn Thái',        'thaidv@cfms.edu.vn',     '0901000113', 4, 1, N'Active', '2025-01-01'),
-- Head of Dept / Teachers (Kinh Tế - 2)
(14, 'oanhtk',      '123456', N'Trần Kim Oanh',        'oanhtk@cfms.edu.vn',     '0901000114', 4, 2, N'Active', '2025-01-01'),
(15, 'thuynt',      '123456', N'Ngô Thu Thủy',         'thuynt@cfms.edu.vn',     '0901000115', 4, 2, N'Active', '2025-01-01'),
(16, 'lienbtb',     '123456', N'Bùi Thị Bích Liên',    'lienbtb@cfms.edu.vn',    '0901000116', 4, 2, N'Active', '2025-01-01'),
(17, 'hungnq',      '123456', N'Nguyễn Quang Hùng',    'hungnq@cfms.edu.vn',     '0901000117', 4, 2, N'Active', '2025-01-01'),
-- Head of Dept / Teachers (Điện tử - 3)
(18, 'hunghv',      '123456', N'Hoàng Vĩnh Hưng',      'hunghv@cfms.edu.vn',     '0901000118', 4, 3, N'Active', '2025-01-01'),
(19, 'datdb',       '123456', N'Đỗ Bá Đạt',            'datdb@cfms.edu.vn',      '0901000119', 4, 3, N'Active', '2025-01-01'),
(20, 'linhtm',      '123456', N'Trương Mỹ Linh',       'linhtm@cfms.edu.vn',     '0901000120', 4, 3, N'Active', '2025-01-01'),
-- Head of Dept / Teachers (Cơ khí - 4)
(21, 'hungnt',      '123456', N'Nguyễn Trọng Hùng',    'hungnt@cfms.edu.vn',     '0901000121', 4, 4, N'Active', '2025-01-01'),
(22, 'thangtq',     '123456', N'Trần Quyết Thắng',     'thangtq@cfms.edu.vn',    '0901000122', 4, 4, N'Active', '2025-01-01'),
(23, 'cuonglm',     '123456', N'Lê Mạnh Cường',        'cuonglm@cfms.edu.vn',    '0901000123', 4, 4, N'Active', '2025-01-01'),
-- Head of Dept / Teachers (Hành chính - 5)
(24, 'ngaht',       '123456', N'Hoàng Thu Ngà',        'ngaht@cfms.edu.vn',      '0901000124', 4, 5, N'Active', '2025-01-01'),
(25, 'sonnm',       '123456', N'Ngô Minh Sơn',         'sonnm@cfms.edu.vn',      '0901000125', 4, 5, N'Active', '2025-01-01'),
-- Principal
(26, 'toandv',      '123456', N'Đinh Văn Toàn',        'toandv@cfms.edu.vn',     '0901000126', 5, 5, N'Active', '2025-01-01'),
(27, 'hangtt',      '123456', N'Trần Thu Hằng',        'hangtt@cfms.edu.vn',     '0901000127', 5, 5, N'Active', '2025-01-01');
SET IDENTITY_INSERT users OFF;
GO

-- ==========================================================
-- TẦNG 3: TÀI SẢN (Dữ liệu gần đây: Cuối 2025 - Đầu 2026)
-- ==========================================================

-- 7. Assets (Lô tài sản)
SET IDENTITY_INSERT assets ON;
INSERT INTO assets (asset_id, asset_code, asset_name, category_id, supplier_id, price, purchase_date, warranty_expiry_date, quantity, description) VALUES
(1,  'LAP-2025-001', N'MacBook Pro M3 14-inch',       1, 1, 39000000, '2025-11-15', '2027-11-15', 5, N'Dùng cho giảng viên CNTT'),
(2,  'LAP-2026-001', N'Dell Latitude 7440',           1, 3, 28000000, '2026-01-10', '2029-01-10', 8, N'Laptop cấp khối hành chính'),
(3,  'LAP-2026-002', N'ThinkPad T14 Gen 4',           1, 2, 26000000, '2026-02-25', '2029-02-25', 10, N'Laptop cho giảng viên'),
(4,  'PC-2025-001',  N'IMac 24-inch M3',              2, 1, 35000000, '2025-12-05', '2027-12-05', 20, N'Lab Mac CNTT'),
(5,  'PC-2026-001',  N'HP ProDesk 400 G9 MT',         2, 5, 13500000, '2026-01-20', '2029-01-20', 30, N'Trang bị Lab Kinh Tế'),
(6,  'PC-2026-002',  N'Dell OptiPlex 7010 Tower',     2, 3, 16000000, '2026-03-01', '2029-03-01', 25, N'Trang bị Lab Điện tử'),
(7,  'MON-2026-001', N'Dell Ultrasharp U2424H',       3, 8,  6500000, '2026-02-15', '2029-02-15', 30, N'Màn hình đồ họa'),
(8,  'MON-2026-002', N'LG 24MP500-B 24 inch',         3, 6,  3200000, '2026-03-10', '2028-03-10', 20, N'Màn hình văn phòng'),
(9,  'PRT-2025-001', N'Canon imageCLASS LBP236dw',    4, 2,  5500000, '2025-10-20', '2027-10-20', 5,  N'Máy in hai mặt tự động'),
(10, 'PRT-2026-001', N'HP Neverstop Laser 1000w',     4, 5,  3800000, '2026-01-05', '2028-01-05', 4,  N'Máy in WiFi'),
(11, 'PRJ-2026-001', N'Sony VPL-EX570',               5, 7, 18000000, '2026-01-15', '2028-01-15', 6,  N'Máy chiếu hội trường'),
(12, 'PRJ-2026-002', N'Epson EB-X51',                 5, 6, 11500000, '2026-03-05', '2028-03-05', 10, N'Máy chiếu phòng học'),
(13, 'FUR-2026-001', N'Ghế xoay văn phòng Hòa Phát',  6, 4,   950000, '2026-02-20', '2027-02-20', 50, N'Ghế nhân viên và giảng viên'),
(14, 'FUR-2026-002', N'Bàn họp cao cấp 3 mét',        6, 4,  8500000, '2026-01-10', '2028-01-10', 2,  N'Bàn phòng họp VIP'),
(15, 'AC-2025-001',  N'Panasonic Inverter 2HP',       7, 6, 18500000, '2025-11-20', '2027-11-20', 10, N'Điều hòa phòng học'),
(16, 'AC-2026-001',  N'Daikin Inverter 2.5HP Âm trần',7, 6, 32000000, '2026-02-15', '2028-02-15', 5,  N'Điều hòa hội trường'),
(17, 'NET-2026-001', N'Cisco Catalyst 1000 24-port',  8, 7,  9000000, '2026-01-25', '2029-01-25', 5,  N'Switch mạng tòa nhà'),
(18, 'NET-2026-002', N'Aruba Instant On AP22',        8, 7,  3500000, '2026-02-28', '2028-02-28', 15, N'Access Point WiFi 6'),
(19, 'OTH-2026-001', N'Tủ Rack 27U D800',             10, 7, 5500000, '2026-01-10', '2030-01-10', 2,  N'Tủ server'),
(20, 'OTH-2026-002', N'Bảng ghim kính từ tính 2m',    10, 4, 2500000, '2026-03-12', '2028-03-12', 10, N'Bảng viết phòng học');
SET IDENTITY_INSERT assets OFF;
GO

-- 9. Asset Details (Tạo khoảng 80 cá thể đại diện)
SET IDENTITY_INSERT asset_details ON;
INSERT INTO asset_details (instance_id, asset_id, instance_code, room_id, status, is_locked) VALUES
-- MacBooks (5 cái)
(1,  1, 'LAP-2025-001-001', 2,  N'In_Use', 0), (2,  1, 'LAP-2025-001-002', 2,  N'In_Use', 0),
(3,  1, 'LAP-2025-001-003', 2,  N'Maintenance', 0), (4,  1, 'LAP-2025-001-004', 3,  N'In_Use', 0),
(5,  1, 'LAP-2025-001-005', 25, N'In_Stock', 0),
-- Dell Laptops (8 cái)
(6,  2, 'LAP-2026-001-001', 21, N'In_Use', 0), (7,  2, 'LAP-2026-001-002', 22, N'In_Use', 0),
(8,  2, 'LAP-2026-001-003', 23, N'In_Use', 0), (9,  2, 'LAP-2026-001-004', 21, N'In_Use', 0),
(10, 2, 'LAP-2026-001-005', 25, N'In_Stock', 1), (11, 2, 'LAP-2026-001-006', 25, N'In_Stock', 0),
(12, 2, 'LAP-2026-001-007', 25, N'In_Stock', 0), (13, 2, 'LAP-2026-001-008', 25, N'In_Stock', 0),
-- iMacs Lab CNTT 1 (20 cái - tạo 10 đại diện)
(14, 4, 'PC-2025-001-001',  1,  N'In_Use', 0), (15, 4, 'PC-2025-001-002',  1,  N'In_Use', 0),
(16, 4, 'PC-2025-001-003',  1,  N'In_Use', 0), (17, 4, 'PC-2025-001-004',  1,  N'In_Use', 0),
(18, 4, 'PC-2025-001-005',  1,  N'In_Use', 0), (19, 4, 'PC-2025-001-006',  1,  N'In_Use', 0),
(20, 4, 'PC-2025-001-007',  1,  N'In_Use', 0), (21, 4, 'PC-2025-001-008',  1,  N'In_Use', 0),
(22, 4, 'PC-2025-001-009',  1,  N'Maintenance', 0), (23, 4, 'PC-2025-001-010',  1,  N'Broken', 1),
-- HP ProDesk Lab Kinh Te (10 đại diện)
(24, 5, 'PC-2026-001-001',  8,  N'In_Use', 0), (25, 5, 'PC-2026-001-002',  8,  N'In_Use', 0),
(26, 5, 'PC-2026-001-003',  8,  N'In_Use', 0), (27, 5, 'PC-2026-001-004',  8,  N'In_Use', 0),
(28, 5, 'PC-2026-001-005',  8,  N'In_Use', 0), (29, 5, 'PC-2026-001-006',  8,  N'In_Use', 0),
(30, 5, 'PC-2026-001-007',  10, N'In_Stock', 0), (31, 5, 'PC-2026-001-008',  10, N'In_Stock', 0),
(32, 5, 'PC-2026-001-009',  25, N'In_Stock', 0), (33, 5, 'PC-2026-001-010',  25, N'In_Stock', 0),
-- Dell Monitors (10 đại diện)
(34, 7, 'MON-2026-001-001', 11, N'In_Use', 0), (35, 7, 'MON-2026-001-002', 11, N'In_Use', 0),
(36, 7, 'MON-2026-001-003', 11, N'In_Use', 0), (37, 7, 'MON-2026-001-004', 11, N'In_Use', 0),
(38, 7, 'MON-2026-001-005', 12, N'In_Use', 0), (39, 7, 'MON-2026-001-006', 12, N'In_Use', 0),
(40, 7, 'MON-2026-001-007', 25, N'In_Stock', 1), (41, 7, 'MON-2026-001-008', 25, N'In_Stock', 1),
(42, 7, 'MON-2026-001-009', 25, N'In_Stock', 0), (43, 7, 'MON-2026-001-010', 25, N'In_Stock', 0),
-- Máy in (9 cái)
(44, 9, 'PRT-2025-001-001', 22, N'In_Use', 0), (45, 9, 'PRT-2025-001-002', 21, N'In_Use', 0),
(46, 9, 'PRT-2025-001-003', 1,  N'In_Use', 0), (47, 9, 'PRT-2025-001-004', 6,  N'In_Use', 0),
(48, 9, 'PRT-2025-001-005', 25, N'In_Stock', 0),
(49, 10, 'PRT-2026-001-001', 8,  N'In_Use', 0), (50, 10, 'PRT-2026-001-002', 16, N'In_Use', 0),
(51, 10, 'PRT-2026-001-003', 25, N'In_Stock', 0), (52, 10, 'PRT-2026-001-004', 25, N'In_Stock', 0),
-- Máy chiếu (10 cái)
(53, 11, 'PRJ-2026-001-001', 4,  N'In_Use', 0), (54, 11, 'PRJ-2026-001-002', 9,  N'In_Use', 0),
(55, 11, 'PRJ-2026-001-003', 14, N'In_Use', 0), (56, 11, 'PRJ-2026-001-004', 19, N'In_Use', 0),
(57, 11, 'PRJ-2026-001-005', 24, N'In_Use', 0), (58, 11, 'PRJ-2026-001-006', 25, N'In_Stock', 1),
(59, 12, 'PRJ-2026-002-001', 6,  N'In_Use', 0), (60, 12, 'PRJ-2026-002-002', 7,  N'In_Use', 0),
(61, 12, 'PRJ-2026-002-003', 13, N'In_Use', 0), (62, 12, 'PRJ-2026-002-004', 25, N'In_Stock', 0),
-- Thiết bị mạng Wifi (10 cái)
(63, 18, 'NET-2026-002-001', 1,  N'In_Use', 0), (64, 18, 'NET-2026-002-002', 2,  N'In_Use', 0),
(65, 18, 'NET-2026-002-003', 6,  N'In_Use', 0), (66, 18, 'NET-2026-002-004', 7,  N'In_Use', 0),
(67, 18, 'NET-2026-002-005', 11, N'In_Use', 0), (68, 18, 'NET-2026-002-006', 16, N'In_Use', 0),
(69, 18, 'NET-2026-002-007', 21, N'In_Use', 0), (70, 18, 'NET-2026-002-008', 24, N'In_Use', 0),
(71, 18, 'NET-2026-002-009', 25, N'In_Stock', 0), (72, 18, 'NET-2026-002-010', 25, N'In_Stock', 0),
-- Nội thất - Bàn họp
(73, 14, 'FUR-2026-002-001', 24, N'In_Use', 0), (74, 14, 'FUR-2026-002-002', 25, N'In_Stock', 0),
-- Điều hòa
(75, 16, 'AC-2026-001-001', 24, N'In_Use', 0), (76, 16, 'AC-2026-001-002', 24, N'In_Use', 0),
(77, 16, 'AC-2026-001-003', 4,  N'In_Use', 0), (78, 16, 'AC-2026-001-004', 9,  N'In_Use', 0),
(79, 16, 'AC-2026-001-005', 25, N'In_Stock', 0);
SET IDENTITY_INSERT asset_details OFF;
GO

-- ==========================================================
-- TẦNG 4: NGHIỆP VỤ (Diễn ra vào tháng 2 và 3 / 2026)
-- ==========================================================

-- 10. Allocation Requests (Cấp phát)
SET IDENTITY_INSERT allocation_requests ON;
INSERT INTO allocation_requests (request_id, created_by, target_room_id, created_date, approved_by, approved_date, completed_date, status, reason, reason_reject) VALUES
(1, 10, 2,  '2026-02-15 09:30:00', 3, '2026-02-16 10:00:00', '2026-02-18 14:00:00', N'Completed', N'Xin cấp phát Macbook cho giảng viên bộ môn phần mềm', NULL),
(2, 14, 8,  '2026-02-20 08:45:00', 4, '2026-02-21 09:15:00', '2026-02-23 15:30:00', N'Completed', N'Cấp phát PC mới cho Lab Kế toán', NULL),
(3, 18, 11, '2026-03-05 14:20:00', 3, '2026-03-06 11:00:00', NULL,                  N'Approved_By_VP', N'Xin thêm màn hình Dell cho Lab điện tử', NULL),
(4, 21, 16, '2026-03-10 10:00:00', NULL, NULL,               NULL,                  N'Pending', N'Xin cấp phát bảng ghim và máy chiếu cho xưởng cơ khí', NULL),
(5, 24, 21, '2026-03-15 16:30:00', 4, '2026-03-16 08:30:00', NULL,                  N'Rejected', N'Đề xuất cấp 5 laptop Dell', N'Tạm hoãn do đang rà soát ngân sách quý 1'),
(6, 15, 7,  '2026-03-20 09:00:00', NULL, NULL,               NULL,                  N'Pending', N'Xin điều hòa mới do phòng 202 hỏng nặng', NULL),
(7, 10, 4,  '2026-03-25 11:15:00', 3, '2026-03-26 14:00:00', NULL,                  N'Approved_By_VP', N'Xin máy chiếu hội trường cho Seminar CNTT', NULL),
(8, 22, 18, '2026-03-26 08:00:00', NULL, NULL,               NULL,                  N'Pending', N'Đề xuất 2 PC ProDesk', NULL);
SET IDENTITY_INSERT allocation_requests OFF;
GO

-- Allocation Details
INSERT INTO allocation_details (request_id, asset_id, quantity, allocated_quantity, note) VALUES
(1, 1, 2, 2, N'Macbook Pro M3'),
(2, 5, 10, 10, N'HP ProDesk 400 G9'),
(3, 7, 5, 0, N'Màn hình Dell Ultrasharp'),
(4, 20, 2, 0, N'Bảng từ tính'),
(4, 12, 1, 0, N'Máy chiếu Epson'),
(5, 2, 5, 0, N'Dell Latitude 7440'),
(6, 15, 1, 0, N'Panasonic 2HP'),
(7, 11, 1, 0, N'Máy chiếu Sony'),
(8, 5, 2, 0, N'PC đo lường');
GO

-- 11. Transfer Orders (Điều chuyển)
SET IDENTITY_INSERT transfer_orders ON;
INSERT INTO transfer_orders (transfer_id, created_by, source_room_id, dest_room_id, created_date, approved_by, approved_date, completed_date, rejected_by, rejected_date, reason_reject, status, note) VALUES
(1, 6, 25, 2,  '2026-02-17 10:00:00', 3, '2026-02-17 14:00:00', '2026-02-18 14:00:00', NULL, NULL, NULL, N'Completed', N'Điều chuyển Macbook đáp ứng đơn cấp phát #1'),
(2, 7, 25, 8,  '2026-02-22 09:00:00', 4, '2026-02-22 15:00:00', '2026-02-23 15:30:00', NULL, NULL, NULL, N'Completed', N'Điều chuyển PC đáp ứng đơn cấp phát #2'),
(3, 6, 25, 11, '2026-03-15 14:00:00', 3, '2026-03-16 09:00:00', NULL, NULL, NULL, NULL, N'Ongoing', N'Đang vận chuyển màn hình Dell cho Lab Điện tử'),
(4, 8, 24, 4,  '2026-03-20 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, N'Pending', N'Đề xuất chuyển bớt 1 máy chiếu từ Họp A sang Seminar CNTT'),
(5, 9, 21, 22, '2026-03-22 15:20:00', 4, '2026-03-23 08:30:00', NULL, NULL, NULL, NULL, N'Approved', N'Điều chuyển nội bộ máy in giữa khối Hành chính'),
(6, 7, 12, 11, '2026-03-24 09:00:00', NULL, NULL, NULL, 4, '2026-03-25 10:00:00', N'Lab Viễn thông đang kẹt thiết bị, không thể chia sẻ', N'Rejected', N'Mượn tạm 2 màn hình từ Viễn thông sang Điện tử cơ bản'),
(7, 6, 25, 4,  '2026-03-26 15:00:00', 3, '2026-03-27 08:00:00', NULL, NULL, NULL, NULL, N'Ongoing', N'Xuất kho máy chiếu Sony theo lệnh cấp phát mới nhất');
SET IDENTITY_INSERT transfer_orders OFF;
GO

-- Transfer Details
INSERT INTO transfer_details (transfer_id, instance_id, status_at_transfer, transfer_date) VALUES
(1, 1,  N'In_Stock', '2026-02-18'), (1, 2,  N'In_Stock', '2026-02-18'),
(2, 24, N'In_Stock', '2026-02-23'), (2, 25, N'In_Stock', '2026-02-23'), 
(2, 26, N'In_Stock', '2026-02-23'), (2, 27, N'In_Stock', '2026-02-23'),
(3, 40, N'In_Stock', '2026-03-16'), (3, 41, N'In_Stock', '2026-03-16'),
(4, 57, N'In_Use',   NULL),
(5, 45, N'In_Use',   NULL),
(6, 38, N'In_Use',   NULL), (6, 39, N'In_Use', NULL),
(7, 58, N'In_Stock', '2026-03-27');
GO

-- 12. Maintenance Requests
INSERT INTO maintenance_requests (instance_id, reported_by_guest, reported_by_user_id, reported_date, issue_description, image_proof_url, status, cost, technician_note) VALUES
(3,  NULL, 10, '2026-03-01 08:30:00', N'Macbook sạc không vào pin', '', N'In_Progress', 2500000, N'Đã gửi FPT bảo hành do lỗi pin/nguồn'),
(22, NULL, 11, '2026-03-10 14:15:00', N'Imac màn hình bị ám hồng góc phải', '', N'Reported', 0, NULL),
(23, NULL, 12, '2026-03-12 09:20:00', N'Imac bật không lên, chập chờn điện', '', N'Cannot_Fix', 0, N'Mainboard cháy nặng, chi phí sửa bằng mua mới. Đề xuất thanh lý.'),
(44, NULL, 24, '2026-03-15 16:00:00', N'Máy in bị kẹt giấy liên tục', '', N'Fixed', 350000, N'Đã thay bao lụa rulo ép'),
(46, NULL, 10, '2026-03-20 10:45:00', N'Máy in báo hết mực', '', N'Verified', 0, N'Chuẩn bị thay mực mới'),
(63, NULL, 13, '2026-03-25 08:00:00', N'Wifi AP Lab 1 không phát sóng', '', N'Reported', 0, NULL),
(75, NULL, 25, '2026-03-26 13:30:00', N'Điều hòa phòng họp rỉ nước', '', N'In_Progress', 500000, N'Đang gọi thợ thông ống nước xả');
GO

-- 13. Procurement Requests
SET IDENTITY_INSERT procurement_requests ON;
INSERT INTO procurement_requests (procurement_id, created_by, created_date, approved_by, approved_date, rejected_by, rejected_date, reason_reject, status, reason, allocation_request_id) VALUES
(1, 6, '2025-11-01', 26, '2025-11-05', NULL, NULL, NULL, N'Completed', N'Dự án nâng cấp Lab Mac', NULL),
(2, 7, '2026-01-05', 26, '2026-01-10', NULL, NULL, NULL, N'Completed', N'Mua sắm máy móc quý 1/2026', NULL),
(3, 8, '2026-03-01', 3,  '2026-03-05', NULL, NULL, NULL, N'Approved',  N'Mua thêm bảng ghim và rèm cửa cho các phòng học mới', NULL),
(4, 9, '2026-03-15', NULL, NULL,         NULL, NULL, NULL, N'Pending',   N'Mua bổ sung linh kiện thay thế (Ổ cứng, RAM)', NULL),
(5, 6, '2026-03-20', NULL, NULL,         4, '2026-03-22', N'Chờ đợt thầu tháng 6', N'Rejected', N'Thay loạt ghế phòng hội trường', NULL),
(6, 6, '2026-03-26', NULL, NULL,         NULL, NULL, NULL, N'Pending',   N'Đề xuất mua khẩn cấp 1 máy chiếu mới thay thế', 6);
SET IDENTITY_INSERT procurement_requests OFF;
GO

-- Procurement Details
INSERT INTO procurement_details (procurement_id, asset_id, quantity, note, received_quantity) VALUES
(1, 4, 20, N'IMac 24-inch', 20),
(2, 2, 8,  N'Dell Latitude', 8),
(2, 3, 10, N'ThinkPad T14', 10),
(3, 20, 10, N'Bảng từ tính 2m', 0),
(5, 13, 100, N'Ghế xoay', 0),
(6, 11, 1,  N'Mua bổ sung 1 máy Sony', 0);
GO

-- 14. Asset History
INSERT INTO asset_history (instance_id, action, performed_by, description, action_date) VALUES
(1,  N'Created',       6, N'Nhập hệ thống từ đơn mua nhập kho #1',       '2025-11-20 10:00:00'),
(24, N'Created',       7, N'Nhập hệ thống lô HP ProDesk năm mới',         '2026-01-25 15:00:00'),
(40, N'Created',       6, N'Nhập kho lô màn hình Dell Ultrasharp',        '2026-02-18 09:30:00'),
(1,  N'Transferred',  10, N'Hoàn thành điều chuyển sang Lab CNTT 2',      '2026-02-18 14:05:00'),
(2,  N'Transferred',  10, N'Hoàn thành điều chuyển sang Lab CNTT 2',      '2026-02-18 14:05:00'),
(24, N'Transferred',  15, N'Hoàn thành thủ tục nhận thiết bị tại Lab KT', '2026-02-23 15:35:00'),
(3,  N'Maintenance',  10, N'Giảng viên báo cáo sự cố sạc pin',            '2026-03-01 08:35:00'),
(3,  N'Updated',       8, N'Kỹ thuật mang đi bảo hành ủy quyền',          '2026-03-05 10:00:00'),
(10, N'Selected',      6, N'Đánh dấu khóa để chuẩn bị làm phiếu ĐC',      '2026-03-20 15:00:00'),
(40, N'Transferred',   6, N'Kho bắt đầu xuất máy đi Lab Điện tử',         '2026-03-16 09:15:00'),
(44, N'Maintenance',  24, N'Báo lỗi kẹt giấy liên tục',                   '2026-03-15 16:05:00'),
(44, N'Fixed',         9, N'Thay xong bao lụa, hoạt động bình thường',    '2026-03-17 11:00:00'),
(23, N'Broken',        8, N'Xác nhận mainboard hỏng nặng, chờ thanh lý',  '2026-03-14 14:00:00'),
(75, N'Maintenance',  25, N'Báo lỗi máy lạnh hội trường chảy nước',       '2026-03-26 13:35:00');
GO

PRINT N'✅ Đã tạo THÀNH CÔNG dữ liệu mẫu Ver 2 (27/03/2026) cho hệ thống CFMS!';
PRINT N'   - Rất nhiều người dùng thực tế Việt Nam.';
PRINT N'   - Flow cập nhật ngày tháng của tháng 2 và tháng 3 năm 2026.';
PRINT N'   - Gần 100 record chi tiết cá thể, hàng tá đơn cấp phát, chuyển tài sản diễn ra đa dạng.';
GO
