-- ==========================================================
-- 0. TẠO DATABASE & THIẾT LẬP CƠ BẢN
-- ==========================================================
USE master;
GO
create database swp_draft
use swp_draft


-- ==========================================================
-- 1. NHÓM QUẢN TRỊ & NGƯỜI DÙNG (AUTH & USERS)
-- ==========================================================

-- Bảng Roles: Vai trò
CREATE TABLE roles (
    role_id INT IDENTITY(1,1) PRIMARY KEY,
    role_name NVARCHAR(50) NOT NULL UNIQUE,
    description NVARCHAR(255)
);
GO

-- Bảng Departments: Phòng ban / Khoa
CREATE TABLE departments (
    dept_id INT IDENTITY(1,1) PRIMARY KEY,
    dept_name NVARCHAR(100) NOT NULL UNIQUE,
    description NVARCHAR(MAX)
);
GO

-- Bảng Users: Người dùng hệ thống
CREATE TABLE users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE, -- Username thường không dấu
    password_hash VARCHAR(255) NOT NULL,
    full_name NVARCHAR(100) NOT NULL, -- Tiếng Việt
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    role_id INT NOT NULL,
    dept_id INT, 
    status NVARCHAR(20) DEFAULT N'Active',
    created_at DATETIME DEFAULT GETDATE(),
    
    -- Ràng buộc khóa ngoại
    FOREIGN KEY (role_id) REFERENCES roles(role_id),
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE SET NULL,
    
    -- Giả lập ENUM bằng CHECK CONSTRAINT
    CONSTRAINT CHK_UserStatus CHECK (status IN (N'Active', N'Inactive'))
);
GO

-- ==========================================================
-- 2. NHÓM DỮ LIỆU DANH MỤC (MASTER DATA)
-- ==========================================================

-- Bảng Categories: Loại tài sản
CREATE TABLE categories (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    category_name NVARCHAR(100) NOT NULL,
    prefix_code VARCHAR(10) NOT NULL UNIQUE, 
    description NVARCHAR(MAX)
);
GO

-- Bảng Rooms: Phòng học
CREATE TABLE rooms (
    room_id INT IDENTITY(1,1) PRIMARY KEY,
    room_name NVARCHAR(50) NOT NULL UNIQUE,
    dept_id INT,
    capacity INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE SET NULL
);
GO

-- Bảng Suppliers: Nhà cung cấp
CREATE TABLE suppliers (
    supplier_id INT IDENTITY(1,1) PRIMARY KEY,
    supplier_name NVARCHAR(150) NOT NULL,
    contact_person NVARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    address NVARCHAR(MAX)
);
GO

-- ==========================================================
-- 3. NHÓM QUẢN LÝ TÀI SẢN (ASSET INVENTORY)
-- ==========================================================

-- Bảng Assets: Tài sản chính
CREATE TABLE assets (
    asset_id INT IDENTITY(1,1) PRIMARY KEY,
    asset_code VARCHAR(50) NOT NULL UNIQUE,
    asset_name NVARCHAR(150) NOT NULL,
    category_id INT NOT NULL,
    supplier_id INT,
    room_id INT, 
    price DECIMAL(15, 2) DEFAULT 0,
    purchase_date DATE,
    warranty_expiry_date DATE,
    status NVARCHAR(50) DEFAULT N'New',
    description NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id) ON DELETE SET NULL,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id) ON DELETE SET NULL,

    -- Giả lập ENUM cho Status
    CONSTRAINT CHK_AssetStatus CHECK (status IN (N'New', N'In_Use', N'Maintenance', N'Broken', N'Liquidated', N'Lost'))
);
GO

-- Bảng Asset_Images
CREATE TABLE asset_images (
    image_id INT IDENTITY(1,1) PRIMARY KEY,
    asset_id INT NOT NULL,
    image_url NVARCHAR(255) NOT NULL,
    uploaded_at DATETIME DEFAULT GETDATE(),
    description NVARCHAR(255),
    FOREIGN KEY (asset_id) REFERENCES assets(asset_id) ON DELETE CASCADE
);
GO

-- Bảng Asset_History
CREATE TABLE asset_history (
    history_id INT IDENTITY(1,1) PRIMARY KEY,
    asset_id INT NOT NULL,
    action NVARCHAR(50) NOT NULL, 
    performed_by INT, 
    description NVARCHAR(MAX), 
    action_date DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (asset_id) REFERENCES assets(asset_id) ON DELETE CASCADE,
    FOREIGN KEY (performed_by) REFERENCES users(user_id) ON DELETE SET NULL
);
GO

-- ==========================================================
-- 4. NHÓM NGHIỆP VỤ & GIAO DỊCH (PROCESSES)
-- ==========================================================

-- A. Cấp phát (Allocation)
CREATE TABLE allocation_requests (
    request_id INT IDENTITY(1,1) PRIMARY KEY,
    created_by INT NOT NULL, 
    created_date DATETIME DEFAULT GETDATE(),
    status NVARCHAR(50) DEFAULT N'Pending',
    reason_reject NVARCHAR(MAX),
    
    FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT CHK_AllocStatus CHECK (status IN (N'Pending', N'Approved_By_VP', N'Approved_By_Principal', N'Rejected', N'Completed'))
);
GO

CREATE TABLE allocation_details (
    detail_id INT IDENTITY(1,1) PRIMARY KEY,
    request_id INT NOT NULL,
    category_id INT NOT NULL,
    quantity INT NOT NULL,
    note NVARCHAR(255),
    
    FOREIGN KEY (request_id) REFERENCES allocation_requests(request_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);
GO

-- B. Điều chuyển (Transfer)
CREATE TABLE transfer_orders (
    transfer_id INT IDENTITY(1,1) PRIMARY KEY,
    created_by INT NOT NULL, 
    source_room_id INT NOT NULL,
    dest_room_id INT NOT NULL,
    created_date DATETIME DEFAULT GETDATE(),
    approved_by INT, 
    status NVARCHAR(50) DEFAULT N'Pending',
    note NVARCHAR(MAX),
    
    FOREIGN KEY (created_by) REFERENCES users(user_id),
    FOREIGN KEY (source_room_id) REFERENCES rooms(room_id),
    FOREIGN KEY (dest_room_id) REFERENCES rooms(room_id),
    FOREIGN KEY (approved_by) REFERENCES users(user_id), -- SQL Server mặc định NO ACTION (tương tự RESTRICT)
    
    CONSTRAINT CHK_TransferStatus CHECK (status IN (N'Pending', N'Approved', N'Rejected', N'Completed'))
);
GO

CREATE TABLE transfer_details (
    detail_id INT IDENTITY(1,1) PRIMARY KEY,
    transfer_id INT NOT NULL,
    asset_id INT NOT NULL,
    status_at_transfer NVARCHAR(50),
    transfer_date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (transfer_id) REFERENCES transfer_orders(transfer_id) ON DELETE CASCADE,
    FOREIGN KEY (asset_id) REFERENCES assets(asset_id)
);
GO

-- C. Bảo trì (Maintenance)
CREATE TABLE maintenance_requests (
    request_id INT IDENTITY(1,1) PRIMARY KEY,
    asset_id INT, 
    reported_by_guest NVARCHAR(100), 
    reported_by_user_id INT, 
    reported_date DATETIME DEFAULT GETDATE(),
    issue_description NVARCHAR(MAX) NOT NULL,
    image_proof_url NVARCHAR(255), 
    status NVARCHAR(50) DEFAULT N'Reported',
    cost DECIMAL(15, 2) DEFAULT 0, 
    technician_note NVARCHAR(MAX),
    
    FOREIGN KEY (asset_id) REFERENCES assets(asset_id) ON DELETE SET NULL,
    FOREIGN KEY (reported_by_user_id) REFERENCES users(user_id) ON DELETE SET NULL,

    CONSTRAINT CHK_MaintStatus CHECK (status IN (N'Reported', N'Verified', N'In_Progress', N'Fixed', N'Cannot_Fix'))
);
GO

-- ==========================================================
-- 5. DỮ LIỆU MẪU (SEED DATA)
-- ==========================================================

-- ===================== ROLES =====================
INSERT INTO roles (role_name, description) VALUES
(N'Principal', N'Hiệu trưởng - Duyệt tối cao'),
(N'Vice Principal', N'Phó hiệu trưởng - Duyệt sơ bộ'),
(N'Finance Head', N'Trưởng phòng tài chính - Quản lý chung'),
(N'Asset Staff', N'Nhân viên thiết bị - Vận hành'),
(N'Head of Dept', N'Trưởng bộ môn - Yêu cầu cấp phát');
GO

-- ===================== DEPARTMENTS =====================
INSERT INTO departments (dept_name, description) VALUES
(N'Phòng Đào Tạo', N'Quản lý chương trình đào tạo và lịch học'),
(N'Phòng IT', N'Quản lý hạ tầng công nghệ thông tin'),
(N'Khoa Cơ Bản', N'Giảng dạy các môn cơ sở'),
(N'Khoa Kinh Tế', N'Giảng dạy các môn kinh tế và quản trị'),
(N'Khoa Kỹ Thuật', N'Giảng dạy các môn kỹ thuật và công nghệ'),
(N'Phòng Hành Chính', N'Quản lý hành chính tổng hợp'),
(N'Khoa Ngoại Ngữ', N'Giảng dạy các môn ngoại ngữ');
GO

-- ===================== USERS =====================
INSERT INTO users (username, password_hash, full_name, email, phone, role_id, dept_id, status) VALUES
-- Principal (role_id=1)
('principal01', 'hash_principal01', N'Nguyễn Văn An', 'an.nguyen@school.edu.vn', '0901000001', 1, NULL, N'Active'),
-- Vice Principals (role_id=2)
('vp01', 'hash_vp01', N'Trần Thị Bích', 'bich.tran@school.edu.vn', '0901000002', 2, NULL, N'Active'),
('vp02', 'hash_vp02', N'Lê Quang Cường', 'cuong.le@school.edu.vn', '0901000003', 2, NULL, N'Active'),
-- Finance Head (role_id=3)
('finance01', 'hash_finance01', N'Phạm Minh Đức', 'duc.pham@school.edu.vn', '0901000004', 3, 6, N'Active'),
('finance02', 'hash_finance02', N'Hoàng Thị Hương', 'huong.hoang@school.edu.vn', '0901000005', 3, 6, N'Active'),
-- Staff (role_id=4)
('staff01', 'hash_staff01', N'Võ Thanh Hải', 'hai.vo@school.edu.vn', '0901000006', 4, 2, N'Active'),
('staff02', 'hash_staff02', N'Đặng Ngọc Linh', 'linh.dang@school.edu.vn', '0901000007', 4, 2, N'Active'),
('staff03', 'hash_staff03', N'Bùi Văn Mạnh', 'manh.bui@school.edu.vn', '0901000008', 4, 6, N'Active'),
('staff04', 'hash_staff04', N'Ngô Thị Ngân', 'ngan.ngo@school.edu.vn', '0901000009', 4, 1, N'Active'),
('staff05', 'hash_staff05', N'Lý Hoàng Phúc', 'phuc.ly@school.edu.vn', '0901000010', 4, 2, N'Inactive'),
-- Head of Dept (role_id=5)
('hod01', 'hash_hod01', N'Trương Văn Quân', 'quan.truong@school.edu.vn', '0901000011', 5, 1, N'Active'),
('hod02', 'hash_hod02', N'Đinh Thị Thanh', 'thanh.dinh@school.edu.vn', '0901000012', 5, 2, N'Active'),
('hod03', 'hash_hod03', N'Mai Xuân Uy', 'uy.mai@school.edu.vn', '0901000013', 5, 3, N'Active'),
('hod04', 'hash_hod04', N'Phan Đình Vinh', 'vinh.phan@school.edu.vn', '0901000014', 5, 4, N'Active'),
('hod05', 'hash_hod05', N'Lưu Thị Yến', 'yen.luu@school.edu.vn', '0901000015', 5, 5, N'Active'),
('hod06', 'hash_hod06', N'Cao Minh Tuấn', 'tuan.cao@school.edu.vn', '0901000016', 5, 7, N'Active');
GO

-- ===================== CATEGORIES =====================
INSERT INTO categories (category_name, prefix_code, description) VALUES
(N'Laptop', 'LAP', N'Máy tính xách tay các loại'),
(N'Máy chiếu', 'PRO', N'Máy chiếu phòng học và hội trường'),
(N'Bàn học sinh', 'TAB', N'Bàn học sinh các kích cỡ'),
(N'Ghế học sinh', 'CHR', N'Ghế học sinh các loại'),
(N'Máy in', 'PRT', N'Máy in laser và phun mực'),
(N'Điều hòa', 'AIR', N'Máy điều hòa nhiệt độ'),
(N'Màn hình', 'MON', N'Màn hình máy tính'),
(N'Máy tính bàn', 'DES', N'Máy tính để bàn (Desktop)'),
(N'Bảng trắng', 'WBD', N'Bảng trắng treo tường'),
(N'Micro & Loa', 'AUD', N'Thiết bị âm thanh phòng học');
GO

-- ===================== ROOMS =====================
INSERT INTO rooms (room_name, dept_id, capacity) VALUES
(N'Phòng 101', 1, 40),
(N'Phòng 102', 1, 40),
(N'Phòng 103', 3, 35),
(N'Phòng 104', 3, 35),
(N'Phòng 201', 4, 50),
(N'Phòng 202', 4, 50),
(N'Phòng 203', 5, 45),
(N'Phòng 204', 5, 45),
(N'Phòng Lab IT 01', 2, 30),
(N'Phòng Lab IT 02', 2, 30),
(N'Phòng Lab IT 03', 2, 25),
(N'Phòng Hội Trường A', NULL, 200),
(N'Phòng Hội Trường B', NULL, 150),
(N'Phòng Họp 01', 6, 20),
(N'Phòng Họp 02', 6, 15),
(N'Phòng 301', 7, 40),
(N'Phòng 302', 7, 40),
(N'Kho Thiết Bị', 6, NULL);
GO

-- ===================== SUPPLIERS =====================
INSERT INTO suppliers (supplier_name, contact_person, email, phone, address) VALUES
(N'Công ty TNHH Thiết Bị Giáo Dục Minh Phát', N'Nguyễn Hữu Long', 'long@minhphat.com.vn', '02838001001', N'123 Nguyễn Trãi, Q.1, TP.HCM'),
(N'Công ty CP Tin Học Phương Nam', N'Trần Thị Mai', 'mai@phuongnam.vn', '02838002002', N'456 Lê Lợi, Q.3, TP.HCM'),
(N'Dell Technologies Vietnam', N'James Nguyen', 'james.nguyen@dell.com', '02838003003', N'Tầng 10, Bitexco Tower, Q.1, TP.HCM'),
(N'Công ty TNHH Epson Việt Nam', N'Phạm Văn Tùng', 'tung.pham@epson.com.vn', '02838004004', N'789 Điện Biên Phủ, Q.Bình Thạnh, TP.HCM'),
(N'Công ty Nội Thất Trường Học Hoàng Gia', N'Lê Thị Hoa', 'hoa@hoanggia-furniture.vn', '02838005005', N'321 Cách Mạng Tháng 8, Q.10, TP.HCM'),
(N'Công ty TNHH Điện Lạnh Đại Việt', N'Võ Minh Khoa', 'khoa@daiviet-aircon.vn', '02838006006', N'654 Trường Chinh, Q.Tân Bình, TP.HCM'),
(N'Công ty CP Công Nghệ BenQ Việt Nam', N'Ngô Quang Huy', 'huy.ngo@benq.com.vn', '02838007007', N'Tầng 5, Saigon Centre, Q.1, TP.HCM'),
(N'Công ty TNHH Âm Thanh Ánh Sáng Việt', N'Đoàn Thanh Sơn', 'son@asviet.com.vn', '02838008008', N'98 Hai Bà Trưng, Q.1, TP.HCM');
GO

-- ===================== ASSETS =====================
INSERT INTO assets (asset_code, asset_name, category_id, supplier_id, room_id, price, purchase_date, warranty_expiry_date, status, description) VALUES
-- Laptops (category_id=1, supplier_id=3 Dell)
('LAP-001', N'Dell Latitude 5540', 1, 3, 9, 22000000, '2024-01-15', '2026-01-15', N'In_Use', N'Laptop cho phòng Lab IT 01'),
('LAP-002', N'Dell Latitude 5540', 1, 3, 9, 22000000, '2024-01-15', '2026-01-15', N'In_Use', N'Laptop cho phòng Lab IT 01'),
('LAP-003', N'Dell Latitude 5540', 1, 3, 10, 22000000, '2024-01-15', '2026-01-15', N'In_Use', N'Laptop cho phòng Lab IT 02'),
('LAP-004', N'Dell Latitude 3440', 1, 3, 10, 18000000, '2023-06-20', '2025-06-20', N'Maintenance', N'Đang sửa lỗi bàn phím'),
('LAP-005', N'Dell Latitude 3440', 1, 3, NULL, 18000000, '2023-06-20', '2025-06-20', N'Broken', N'Hỏng màn hình, chờ thanh lý'),
('LAP-006', N'Dell Inspiron 15', 1, 3, 11, 15000000, '2022-09-01', '2024-09-01', N'In_Use', N'Laptop cũ phòng Lab IT 03'),
('LAP-007', N'Dell Inspiron 15', 1, 3, 14, 15000000, '2022-09-01', '2024-09-01', N'In_Use', N'Laptop phòng họp 01'),
('LAP-008', N'Dell Latitude 5550', 1, 3, NULL, 25000000, '2025-02-01', '2027-02-01', N'New', N'Laptop mới nhập kho'),
('LAP-009', N'Dell Latitude 5550', 1, 3, NULL, 25000000, '2025-02-01', '2027-02-01', N'New', N'Laptop mới nhập kho'),
('LAP-010', N'Dell Latitude 5550', 1, 3, NULL, 25000000, '2025-02-01', '2027-02-01', N'New', N'Laptop mới nhập kho'),

-- Máy chiếu (category_id=2, supplier_id=7 BenQ)
('PRO-001', N'BenQ MH560', 2, 7, 1, 12000000, '2023-08-10', '2026-08-10', N'In_Use', N'Máy chiếu phòng 101'),
('PRO-002', N'BenQ MH560', 2, 7, 2, 12000000, '2023-08-10', '2026-08-10', N'In_Use', N'Máy chiếu phòng 102'),
('PRO-003', N'BenQ MH560', 2, 7, 3, 12000000, '2023-08-10', '2026-08-10', N'In_Use', N'Máy chiếu phòng 103'),
('PRO-004', N'BenQ MW560', 2, 7, 5, 15000000, '2024-03-01', '2027-03-01', N'In_Use', N'Máy chiếu phòng 201'),
('PRO-005', N'BenQ MW560', 2, 7, 12, 15000000, '2024-03-01', '2027-03-01', N'In_Use', N'Máy chiếu hội trường A'),
('PRO-006', N'BenQ MH560', 2, 7, NULL, 12000000, '2023-08-10', '2026-08-10', N'Maintenance', N'Bóng đèn yếu, cần thay'),
('PRO-007', N'Epson EB-X51', 2, 4, 13, 11000000, '2022-05-15', '2024-05-15', N'In_Use', N'Máy chiếu hội trường B'),

-- Bàn học sinh (category_id=3, supplier_id=5 Hoàng Gia)
('TAB-001', N'Bàn học sinh đôi BHS-02', 3, 5, 1, 1500000, '2023-01-10', NULL, N'In_Use', N'Bàn đôi phòng 101'),
('TAB-002', N'Bàn học sinh đôi BHS-02', 3, 5, 1, 1500000, '2023-01-10', NULL, N'In_Use', N'Bàn đôi phòng 101'),
('TAB-003', N'Bàn học sinh đôi BHS-02', 3, 5, 2, 1500000, '2023-01-10', NULL, N'In_Use', NULL),
('TAB-004', N'Bàn học sinh đôi BHS-02', 3, 5, 3, 1500000, '2023-01-10', NULL, N'In_Use', NULL),
('TAB-005', N'Bàn học sinh đơn BHS-01', 3, 5, 5, 900000, '2022-06-01', NULL, N'In_Use', NULL),
('TAB-006', N'Bàn học sinh đơn BHS-01', 3, 5, 5, 900000, '2022-06-01', NULL, N'Broken', N'Gãy chân bàn'),

-- Ghế học sinh (category_id=4, supplier_id=5)
('CHR-001', N'Ghế học sinh GHS-01', 4, 5, 1, 600000, '2023-01-10', NULL, N'In_Use', NULL),
('CHR-002', N'Ghế học sinh GHS-01', 4, 5, 1, 600000, '2023-01-10', NULL, N'In_Use', NULL),
('CHR-003', N'Ghế học sinh GHS-01', 4, 5, 2, 600000, '2023-01-10', NULL, N'In_Use', NULL),
('CHR-004', N'Ghế học sinh GHS-01', 4, 5, 3, 600000, '2023-01-10', NULL, N'In_Use', NULL),
('CHR-005', N'Ghế xoay văn phòng', 4, 5, 14, 2500000, '2024-02-01', NULL, N'In_Use', N'Ghế phòng họp'),

-- Máy in (category_id=5, supplier_id=4 Epson)
('PRT-001', N'Epson L3250', 5, 4, 14, 5500000, '2024-05-10', '2025-05-10', N'In_Use', N'Máy in phòng họp 01'),
('PRT-002', N'Epson L3250', 5, 4, 18, 5500000, '2024-05-10', '2025-05-10', N'In_Use', N'Máy in kho thiết bị'),
('PRT-003', N'Epson EcoTank L6290', 5, 4, 9, 9800000, '2024-08-01', '2026-08-01', N'In_Use', N'Máy in Lab IT 01'),
('PRT-004', N'Epson L3250', 5, 4, NULL, 5500000, '2023-03-01', '2024-03-01', N'Broken', N'Hỏng đầu in, hết bảo hành'),

-- Điều hòa (category_id=6, supplier_id=6 Đại Việt)
('AIR-001', N'Daikin FTKB35XVMV 1.5HP', 6, 6, 1, 12000000, '2023-03-15', '2026-03-15', N'In_Use', NULL),
('AIR-002', N'Daikin FTKB35XVMV 1.5HP', 6, 6, 2, 12000000, '2023-03-15', '2026-03-15', N'In_Use', NULL),
('AIR-003', N'Daikin FTKB35XVMV 1.5HP', 6, 6, 3, 12000000, '2023-03-15', '2026-03-15', N'In_Use', NULL),
('AIR-004', N'Daikin FTKC50UVMV 2HP', 6, 6, 5, 16000000, '2024-01-10', '2027-01-10', N'In_Use', NULL),
('AIR-005', N'Daikin FTKC50UVMV 2HP', 6, 6, 12, 16000000, '2024-01-10', '2027-01-10', N'In_Use', N'Điều hòa hội trường A'),
('AIR-006', N'Daikin FTKB35XVMV 1.5HP', 6, 6, 9, 12000000, '2023-03-15', '2026-03-15', N'Maintenance', N'Đang bảo trì định kỳ'),

-- Màn hình (category_id=7, supplier_id=3 Dell)
('MON-001', N'Dell E2422H 24 inch', 7, 3, 9, 4500000, '2024-01-15', '2027-01-15', N'In_Use', NULL),
('MON-002', N'Dell E2422H 24 inch', 7, 3, 9, 4500000, '2024-01-15', '2027-01-15', N'In_Use', NULL),
('MON-003', N'Dell E2422H 24 inch', 7, 3, 10, 4500000, '2024-01-15', '2027-01-15', N'In_Use', NULL),
('MON-004', N'Dell E2422H 24 inch', 7, 3, 10, 4500000, '2024-01-15', '2027-01-15', N'In_Use', NULL),
('MON-005', N'Dell S2722QC 27 inch 4K', 7, 3, 14, 8500000, '2024-06-01', '2027-06-01', N'In_Use', N'Màn hình phòng họp'),

-- Máy tính bàn (category_id=8, supplier_id=2 Phương Nam)
('DES-001', N'PC Intel i5-13400 / 16GB / SSD 512GB', 8, 2, 9, 14000000, '2024-01-15', '2026-01-15', N'In_Use', N'Máy tính Lab IT 01'),
('DES-002', N'PC Intel i5-13400 / 16GB / SSD 512GB', 8, 2, 9, 14000000, '2024-01-15', '2026-01-15', N'In_Use', N'Máy tính Lab IT 01'),
('DES-003', N'PC Intel i5-13400 / 16GB / SSD 512GB', 8, 2, 10, 14000000, '2024-01-15', '2026-01-15', N'In_Use', N'Máy tính Lab IT 02'),
('DES-004', N'PC Intel i5-13400 / 16GB / SSD 512GB', 8, 2, 10, 14000000, '2024-01-15', '2026-01-15', N'In_Use', N'Máy tính Lab IT 02'),
('DES-005', N'PC Intel i3-12100 / 8GB / SSD 256GB', 8, 2, 11, 9000000, '2022-08-01', '2024-08-01', N'In_Use', N'Máy tính Lab IT 03'),
('DES-006', N'PC Intel i3-12100 / 8GB / SSD 256GB', 8, 2, 11, 9000000, '2022-08-01', '2024-08-01', N'Broken', N'Hỏng nguồn'),

-- Bảng trắng (category_id=9, supplier_id=1 Minh Phát)
('WBD-001', N'Bảng trắng từ 1.2m x 2.4m', 9, 1, 1, 1800000, '2023-01-10', NULL, N'In_Use', NULL),
('WBD-002', N'Bảng trắng từ 1.2m x 2.4m', 9, 1, 2, 1800000, '2023-01-10', NULL, N'In_Use', NULL),
('WBD-003', N'Bảng trắng từ 1.2m x 2.4m', 9, 1, 3, 1800000, '2023-01-10', NULL, N'In_Use', NULL),
('WBD-004', N'Bảng trắng từ 1.2m x 2.4m', 9, 1, 5, 1800000, '2023-01-10', NULL, N'In_Use', NULL),
('WBD-005', N'Bảng trắng từ 0.6m x 0.9m', 9, 1, 14, 500000, '2024-02-01', NULL, N'In_Use', N'Bảng nhỏ phòng họp'),

-- Micro & Loa (category_id=10, supplier_id=8 ÂS Việt)
('AUD-001', N'Bộ Micro không dây Shure BLX288/PG58', 10, 8, 12, 8500000, '2024-04-01', '2026-04-01', N'In_Use', N'Hội trường A'),
('AUD-002', N'Loa JBL EON715 15 inch', 10, 8, 12, 15000000, '2024-04-01', '2026-04-01', N'In_Use', N'Hội trường A'),
('AUD-003', N'Bộ Micro không dây Shure BLX288/PG58', 10, 8, 13, 8500000, '2024-04-01', '2026-04-01', N'In_Use', N'Hội trường B'),
('AUD-004', N'Loa JBL EON710 10 inch', 10, 8, 13, 10000000, '2024-04-01', '2026-04-01', N'In_Use', N'Hội trường B'),
('AUD-005', N'Micro có dây Shure SM58', 10, 8, NULL, 3000000, '2022-01-01', '2024-01-01', N'Lost', N'Thất lạc sau sự kiện');
GO

-- ===================== ASSET IMAGES =====================
INSERT INTO asset_images (asset_id, image_url, description) VALUES
(1, '/images/assets/LAP-001_front.jpg', N'Mặt trước laptop'),
(1, '/images/assets/LAP-001_keyboard.jpg', N'Bàn phím laptop'),
(4, '/images/assets/LAP-004_damage.jpg', N'Hình chụp lỗi bàn phím'),
(5, '/images/assets/LAP-005_broken_screen.jpg', N'Màn hình hỏng'),
(11, '/images/assets/PRO-001_installed.jpg', N'Máy chiếu đã lắp đặt'),
(16, '/images/assets/PRO-006_lamp.jpg', N'Bóng đèn yếu'),
(23, '/images/assets/TAB-006_broken.jpg', N'Gãy chân bàn'),
(33, '/images/assets/PRT-004_broken.jpg', N'Đầu in hỏng'),
(51, '/images/assets/DES-006_broken_psu.jpg', N'Nguồn hỏng'),
(58, '/images/assets/AUD-001_setup.jpg', N'Lắp đặt micro hội trường');
GO

-- ===================== ASSET HISTORY =====================
INSERT INTO asset_history (asset_id, action, performed_by, description, action_date) VALUES
-- LAP-001: Nhập kho -> Cấp phát
(1, N'Nhập kho', 6, N'Nhập lô laptop Dell Latitude 5540 x10', '2024-01-15 09:00:00'),
(1, N'Cấp phát', 6, N'Cấp phát cho phòng Lab IT 01', '2024-01-20 10:00:00'),
-- LAP-004: Nhập kho -> Cấp phát -> Bảo trì
(4, N'Nhập kho', 6, N'Nhập lô laptop Dell Latitude 3440 x5', '2023-06-20 09:00:00'),
(4, N'Cấp phát', 6, N'Cấp phát cho phòng Lab IT 02', '2023-07-01 08:30:00'),
(4, N'Bảo trì', 7, N'Báo lỗi bàn phím, chuyển bảo trì', '2025-01-10 14:00:00'),
-- LAP-005: Nhập kho -> Cấp phát -> Hỏng
(5, N'Nhập kho', 6, N'Nhập lô laptop Dell Latitude 3440 x5', '2023-06-20 09:00:00'),
(5, N'Cấp phát', 6, N'Cấp phát cho phòng Lab IT 02', '2023-07-01 08:30:00'),
(5, N'Hỏng', 7, N'Màn hình bị vỡ do rơi, chuyển Broken', '2024-11-05 16:00:00'),
-- PRO-001: Nhập kho -> Cấp phát
(11, N'Nhập kho', 6, N'Nhập lô máy chiếu BenQ MH560 x6', '2023-08-10 09:00:00'),
(11, N'Cấp phát', 6, N'Lắp đặt tại phòng 101', '2023-08-15 10:00:00'),
-- PRO-006: Nhập kho -> Cấp phát -> Bảo trì
(16, N'Nhập kho', 6, N'Nhập lô máy chiếu BenQ MH560 x6', '2023-08-10 09:00:00'),
(16, N'Cấp phát', 6, N'Lắp đặt tại phòng 104', '2023-08-16 10:00:00'),
(16, N'Bảo trì', 7, N'Bóng đèn yếu, cần thay bóng mới', '2025-01-20 11:00:00'),
-- AIR-006: Bảo trì định kỳ
(39, N'Nhập kho', 6, N'Nhập lô điều hòa Daikin', '2023-03-15 09:00:00'),
(39, N'Cấp phát', 6, N'Lắp đặt tại Lab IT 01', '2023-03-20 14:00:00'),
(39, N'Bảo trì', 7, N'Bảo trì định kỳ: vệ sinh, nạp gas', '2025-01-25 09:00:00'),
-- AUD-005: Thất lạc
(58, N'Nhập kho', 6, N'Nhập micro Shure SM58', '2022-01-01 09:00:00'),
(58, N'Thất lạc', 8, N'Không tìm thấy sau sự kiện khai giảng', '2024-09-10 17:00:00');
GO

-- ===================== ALLOCATION REQUESTS =====================
INSERT INTO allocation_requests (created_by, created_date, status, reason_reject) VALUES
-- Trưởng BM Đào Tạo yêu cầu cấp phát laptop (đã hoàn thành)
(11, '2024-01-18 08:00:00', N'Completed', NULL),
-- Trưởng BM IT yêu cầu thêm máy in (đã duyệt VP, chờ Principal)
(12, '2025-01-05 09:30:00', N'Approved_By_VP', NULL),
-- Trưởng BM Kinh Tế yêu cầu máy chiếu (đang chờ duyệt)
(14, '2025-01-15 10:00:00', N'Pending', NULL),
-- Trưởng BM Kỹ Thuật yêu cầu bàn ghế (bị từ chối)
(15, '2024-11-20 14:00:00', N'Rejected', N'Ngân sách năm 2024 đã hết, vui lòng gửi lại đầu năm 2025'),
-- Trưởng BM Ngoại Ngữ yêu cầu điều hòa (đã duyệt hoàn tất)
(16, '2024-06-01 08:00:00', N'Completed', NULL),
-- Trưởng BM Cơ Bản yêu cầu bảng trắng (Approved by Principal)
(13, '2025-01-28 09:00:00', N'Approved_By_Principal', NULL);
GO

-- ===================== ALLOCATION DETAILS =====================
INSERT INTO allocation_details (request_id, category_id, quantity, note) VALUES
-- Request 1: Laptop x5
(1, 1, 5, N'Cần laptop cho phòng Lab IT mới'),
-- Request 2: Máy in x2
(2, 5, 2, N'Bổ sung máy in cho phòng Lab IT 02 và phòng 201'),
-- Request 3: Máy chiếu x3
(3, 2, 3, N'Lắp thêm máy chiếu cho 3 phòng Khoa Kinh Tế'),
-- Request 4: Bàn x20, Ghế x20
(4, 3, 20, N'Bàn cho phòng mới Khoa Kỹ Thuật'),
(4, 4, 20, N'Ghế cho phòng mới Khoa Kỹ Thuật'),
-- Request 5: Điều hòa x2
(5, 6, 2, N'Điều hòa cho phòng 301, 302 Ngoại Ngữ'),
-- Request 6: Bảng trắng x4
(6, 9, 4, N'Thay bảng cũ tại phòng Khoa Cơ Bản');
GO

-- ===================== TRANSFER ORDERS =====================
INSERT INTO transfer_orders (created_by, source_room_id, dest_room_id, created_date, approved_by, status, note) VALUES
-- Chuyển laptop từ Lab IT 02 sang Lab IT 03 (hoàn thành)
(6, 10, 11, '2024-09-01 08:00:00', 2, N'Completed', N'Điều chuyển laptop sang lab mới'),
-- Chuyển bàn từ phòng 201 sang phòng 203 (đã duyệt)
(7, 5, 7, '2025-01-10 09:00:00', 2, N'Approved', N'Chuyển bàn dư sang phòng thiếu'),
-- Chuyển máy chiếu từ kho sang phòng 204 (chờ duyệt)
(6, 18, 8, '2025-02-01 10:00:00', NULL, N'Pending', N'Lắp máy chiếu phòng 204'),
-- Chuyển điều hòa từ phòng 103 sang phòng 301 (bị từ chối)
(7, 3, 16, '2024-12-15 11:00:00', 3, N'Rejected', N'Phòng 103 vẫn cần điều hòa, không thể chuyển');
GO

-- ===================== TRANSFER DETAILS =====================
INSERT INTO transfer_details (transfer_id, asset_id, status_at_transfer, transfer_date) VALUES
-- Transfer 1: Chuyển LAP-003 từ Lab IT 02 -> Lab IT 03
(1, 3, N'In_Use', '2024-09-02 10:00:00'),
-- Transfer 2: Chuyển TAB-005 từ phòng 201 -> phòng 203
(2, 22, N'In_Use', '2025-01-12 14:00:00'),
-- Transfer 3: (Pending - chưa có transfer_date thực tế, dùng ngày tạo)
(3, 16, N'Maintenance', '2025-02-01 10:00:00');
GO

-- ===================== MAINTENANCE REQUESTS =====================
INSERT INTO maintenance_requests (asset_id, reported_by_guest, reported_by_user_id, reported_date, issue_description, image_proof_url, status, cost, technician_note) VALUES
-- LAP-004: Báo lỗi bàn phím (đang sửa)
(4, NULL, 12, '2025-01-10 14:00:00', N'Bàn phím laptop bị liệt một số phím, không gõ được ký tự số hàng trên', '/images/maintenance/LAP-004_keyboard.jpg', N'In_Progress', 500000, N'Đã đặt bàn phím thay thế, chờ linh kiện về'),
-- LAP-005: Hỏng màn hình (không sửa được)
(5, NULL, 12, '2024-11-05 16:00:00', N'Màn hình laptop bị vỡ do rơi từ bàn xuống đất', '/images/maintenance/LAP-005_broken_screen.jpg', N'Cannot_Fix', 0, N'Màn hình vỡ nặng, chi phí thay thế cao hơn giá trị còn lại. Đề xuất thanh lý'),
-- PRO-006: Bóng đèn yếu (đã xác minh)
(16, NULL, 11, '2025-01-20 11:00:00', N'Máy chiếu chiếu mờ, bóng đèn yếu dần sau 2 năm sử dụng', '/images/maintenance/PRO-006_lamp.jpg', N'Verified', 2500000, NULL),
-- TAB-006: Gãy chân bàn (đã sửa xong)
(23, NULL, 14, '2024-10-01 09:00:00', N'Bàn học sinh bị gãy chân, nghiêng và không ổn định', '/images/maintenance/TAB-006_broken_leg.jpg', N'Fixed', 200000, N'Đã hàn và gia cố lại chân bàn'),
-- AIR-006: Bảo trì định kỳ (đang xử lý)
(39, NULL, 6, '2025-01-25 09:00:00', N'Điều hòa cần bảo trì định kỳ: vệ sinh lưới lọc, kiểm tra gas', NULL, N'In_Progress', 800000, N'Đang vệ sinh và nạp gas bổ sung'),
-- DES-006: Hỏng nguồn (báo cáo mới)
(51, NULL, 7, '2025-02-05 10:00:00', N'Máy tính không khởi động được, nghi hỏng nguồn (PSU)', '/images/maintenance/DES-006_psu.jpg', N'Reported', 0, NULL),
-- Báo cáo từ khách (guest)
(NULL, N'Nguyễn Minh Tú - Sinh viên K68', NULL, '2025-02-03 15:30:00', N'Điều hòa phòng 201 không mát, chạy có tiếng ồn lớn', NULL, N'Reported', 0, NULL),
-- PRT-004: Hỏng đầu in (không sửa được)
(33, NULL, 6, '2024-08-15 11:00:00', N'Máy in ra giấy bị nhòe và có vạch kẻ, đầu in hỏng', '/images/maintenance/PRT-004_head.jpg', N'Cannot_Fix', 0, N'Đầu in hỏng không thể sửa, hết bảo hành. Đề xuất thanh lý');
GO