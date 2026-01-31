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

-- Insert Roles
INSERT INTO roles (role_name, description) VALUES 
(N'Principal', N'Hiệu trưởng - Duyệt tối cao'),
(N'Vice Principal', N'Phó hiệu trưởng - Duyệt sơ bộ'),
(N'Finance Head', N'Trưởng phòng tài chính - Quản lý chung'),
(N'Staff', N'Nhân viên thiết bị - Vận hành'),
(N'Head of Dept', N'Trưởng bộ môn - Yêu cầu cấp phát');
GO

-- Insert Departments
INSERT INTO departments (dept_name) VALUES (N'Phòng Đào Tạo'), (N'Phòng IT'), (N'Khoa Cơ Bản');
GO

-- Insert Users (Lưu ý: role_id và dept_id phụ thuộc vào thứ tự insert ở trên, thường bắt đầu từ 1)
INSERT INTO users (username, password_hash, full_name, email, role_id, dept_id) VALUES 
('admin', 'admin123_hash_here', N'System Administrator', 'admin@school.edu.vn', 3, 2);
GO

-- Insert Categories
INSERT INTO categories (category_name, prefix_code) VALUES 
(N'Laptop', 'LAP'), 
(N'Máy chiếu', 'PRO'), 
(N'Bàn học sinh', 'TAB');
GO