package model;

/**
 * Represents a Room where assets are located.
 * Matches table 'rooms'.
 */
public class Room {
    private int roomId;
    private String roomName;
    private int deptId;
    private int capacity;

    // Relationship
    private Department department;

    public Room() {
    }

    public Room(int roomId, String roomName, int deptId, int capacity) {
        this.roomId = roomId;
        this.roomName = roomName;
        this.deptId = deptId;
        this.capacity = capacity;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public int getDeptId() {
        return deptId;
    }

    public void setDeptId(int deptId) {
        this.deptId = deptId;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public Department getDepartment() {
        return department;
    }

    public void setDepartment(Department department) {
        this.department = department;
    }
}
