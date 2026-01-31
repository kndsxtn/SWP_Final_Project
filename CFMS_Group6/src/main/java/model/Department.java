package model;

import java.util.List;

/**
 * Represents a Department/Inventory group.
 * Matches table 'departments'.
 */
public class Department {
    private int deptId;
    private String deptName;
    private String description;

    // Relationship 1-N: One Department involves multiple users/rooms
    // private List<User> users;
    // private List<Room> rooms;

    public Department() {
    }

    public Department(int deptId, String deptName, String description) {
        this.deptId = deptId;
        this.deptName = deptName;
        this.description = description;
    }

    public int getDeptId() {
        return deptId;
    }

    public void setDeptId(int deptId) {
        this.deptId = deptId;
    }

    public String getDeptName() {
        return deptName;
    }

    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "Department{" + "deptId=" + deptId + ", deptName=" + deptName + '}';
    }
}
