package model;

import java.util.Date;

/**
 * Represents a User in the system.
 * Matches table 'users' in database.
 */
public class User {
    private int userId;
    private String username;
    private String password; // Maps to password_hash
    private String fullName;
    private String email;
    private String phone;
    private int roleId; // Foreign Key value
    private int deptId; // Foreign Key value
    private String status;
    private Date createdAt;

    // Optional: Object references for Relationships (N-1)
    // We can populate these when we do JOIN queries
    private Role role;
    // private Department department;

    public User() {
    }

    public User(int userId, String username, String password, String fullName, String email, String phone, int roleId,
            int deptId, String status, Date createdAt) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.roleId = roleId;
        this.deptId = deptId;
        this.status = status;
        this.createdAt = createdAt;
    }

    // Getters and Setters

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public int getDeptId() {
        return deptId;
    }

    public void setDeptId(int deptId) {
        this.deptId = deptId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    @Override
    public String toString() {
        return "User{" + "userId=" + userId + ", username=" + username + ", fullName=" + fullName + ", roleId=" + roleId
                + '}';
    }
}
