# 📝 Changelog — [db_draft.sql](file:///Users/vuhieu/Desktop/SWP_Final_Project/db_draft.sql)

> Ngày thay đổi: **10/03/2026**
> Mục đích: Hỗ trợ **truy vết từng cá thể tài sản** thay vì chỉ theo lô

---

## 1. Thêm bảng `asset_details`

> Mỗi cá thể tài sản (VD: 1 cái laptop trong lô 1000 cái) có 1 bản ghi riêng.

```sql
-- MỚI
CREATE TABLE asset_details (
    instance_id INT IDENTITY(1,1) PRIMARY KEY,
    asset_id INT NOT NULL,
    instance_code VARCHAR(50) NOT NULL UNIQUE,  -- VD: LAP-2026-001-001
    room_id INT,
    status NVARCHAR(50) DEFAULT N'New',
    FOREIGN KEY (asset_id) REFERENCES assets(asset_id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id) ON DELETE SET NULL,
    CONSTRAINT CHK_InstanceStatus CHECK (status IN (N'New', N'In_Use', N'Maintenance', N'Broken', N'Liquidated', N'Lost'))
);
```

---

## 2. Sửa `asset_history` — truy vết theo cá thể

```diff
 CREATE TABLE asset_history (
     history_id INT IDENTITY(1,1) PRIMARY KEY,
-    asset_id INT NOT NULL,
+    instance_id INT NOT NULL,               -- FK → asset_details
     action NVARCHAR(50) NOT NULL,
     performed_by INT,
     description NVARCHAR(MAX),
     action_date DATETIME DEFAULT GETDATE(),
-    FOREIGN KEY (asset_id) REFERENCES assets(asset_id) ON DELETE CASCADE,
+    FOREIGN KEY (instance_id) REFERENCES asset_details(instance_id) ON DELETE CASCADE,
     FOREIGN KEY (performed_by) REFERENCES users(user_id) ON DELETE SET NULL
 );
```

---

## 3. Sửa `transfer_details` — điều chuyển theo cá thể

```diff
 CREATE TABLE transfer_details (
     detail_id INT IDENTITY(1,1) PRIMARY KEY,
     transfer_id INT NOT NULL,
-    asset_id INT NOT NULL,
+    instance_id INT NOT NULL,               -- FK → asset_details
     status_at_transfer NVARCHAR(50),
     transfer_date DATETIME DEFAULT GETDATE(),
     FOREIGN KEY (transfer_id) REFERENCES transfer_orders(transfer_id) ON DELETE CASCADE,
-    FOREIGN KEY (asset_id) REFERENCES assets(asset_id)
+    FOREIGN KEY (instance_id) REFERENCES asset_details(instance_id)
 );
```

---

## 4. Sửa `maintenance_requests` — bảo trì theo cá thể

```diff
 CREATE TABLE maintenance_requests (
     request_id INT IDENTITY(1,1) PRIMARY KEY,
-    asset_id INT,
+    instance_id INT,                         -- FK → asset_details
     reported_by_guest NVARCHAR(100),
     ...
-    FOREIGN KEY (asset_id) REFERENCES assets(asset_id) ON DELETE SET NULL,
+    FOREIGN KEY (instance_id) REFERENCES asset_details(instance_id) ON DELETE SET NULL,
 );
```

---

## 5. Bỏ `room_id` và `status` khỏi bảng `assets`

> Hai trường này giờ được quản lý ở `asset_details` (từng cá thể).

```diff
 CREATE TABLE assets (
     asset_id INT IDENTITY(1,1) PRIMARY KEY,
     asset_code VARCHAR(50) NOT NULL UNIQUE,
     asset_name NVARCHAR(150) NOT NULL,
     category_id INT NOT NULL,
     supplier_id INT,
-    room_id INT,
     price DECIMAL(15, 2) DEFAULT 0,
     purchase_date DATE,
     warranty_expiry_date DATE,
     quantity INT NOT NULL DEFAULT 1,
-    status NVARCHAR(50) DEFAULT N'New',
     description NVARCHAR(MAX),
     created_at DATETIME DEFAULT GETDATE(),
     FOREIGN KEY (category_id) REFERENCES categories(category_id),
     FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id) ON DELETE SET NULL,
-    FOREIGN KEY (room_id) REFERENCES rooms(room_id) ON DELETE SET NULL,
-    CONSTRAINT CHK_AssetStatus CHECK (...),
     CONSTRAINT CHK_AssetQuantity CHECK (quantity >= 0)
 );
```

---

## 6. Cập nhật Index

```diff
-- BỎ
-CREATE INDEX IX_Assets_CategoryRoom ON assets(category_id, room_id);
-CREATE INDEX IX_Assets_Status ON assets(status);

-- THÊM MỚI
+CREATE INDEX IX_Assets_Category ON assets(category_id)
+    INCLUDE (asset_code, asset_name, quantity);
+
+CREATE INDEX IX_AssetDetails_AssetStatus ON asset_details(asset_id, status)
+    INCLUDE (instance_code, room_id);
+
+CREATE INDEX IX_AssetDetails_Room ON asset_details(room_id)
+    INCLUDE (instance_code, status);
```

---

## Tóm tắt

| Thay đổi | Loại |
|---|---|
| Thêm bảng `asset_details` | ➕ Mới |
| `asset_history.asset_id` → `instance_id` | ✏️ Sửa FK |
| `transfer_details.asset_id` → `instance_id` | ✏️ Sửa FK |
| `maintenance_requests.asset_id` → `instance_id` | ✏️ Sửa FK |
| Bỏ `assets.room_id` | ➖ Xóa trường |
| Bỏ `assets.status` | ➖ Xóa trường |
| Cập nhật 3 index | ✏️ Sửa |
