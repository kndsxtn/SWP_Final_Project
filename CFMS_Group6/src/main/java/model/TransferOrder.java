package model;

import java.util.Date;
import java.util.List;

/**
 * Represents a Transfer Order.
 * Matches table 'transfer_orders'.
 */
public class TransferOrder {
    private int transferId;
    private int createdBy;
    private int sourceRoomId;
    private int destRoomId;
    private Date createdDate;
    private int approvedBy;
    private String status;
    private String note;

    // Relationships
    private User creator;
    private Room sourceRoom;
    private Room destRoom;
    private User approver;
    private List<TransferDetail> details;

    public TransferOrder() {
    }

    public TransferOrder(int transferId, int createdBy, int sourceRoomId, int destRoomId, Date createdDate,
            int approvedBy, String status, String note) {
        this.transferId = transferId;
        this.createdBy = createdBy;
        this.sourceRoomId = sourceRoomId;
        this.destRoomId = destRoomId;
        this.createdDate = createdDate;
        this.approvedBy = approvedBy;
        this.status = status;
        this.note = note;
    }

    public int getTransferId() {
        return transferId;
    }

    public void setTransferId(int transferId) {
        this.transferId = transferId;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public int getSourceRoomId() {
        return sourceRoomId;
    }

    public void setSourceRoomId(int sourceRoomId) {
        this.sourceRoomId = sourceRoomId;
    }

    public int getDestRoomId() {
        return destRoomId;
    }

    public void setDestRoomId(int destRoomId) {
        this.destRoomId = destRoomId;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public int getApprovedBy() {
        return approvedBy;
    }

    public void setApprovedBy(int approvedBy) {
        this.approvedBy = approvedBy;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public User getCreator() {
        return creator;
    }

    public void setCreator(User creator) {
        this.creator = creator;
    }

    public Room getSourceRoom() {
        return sourceRoom;
    }

    public void setSourceRoom(Room sourceRoom) {
        this.sourceRoom = sourceRoom;
    }

    public Room getDestRoom() {
        return destRoom;
    }

    public void setDestRoom(Room destRoom) {
        this.destRoom = destRoom;
    }

    public User getApprover() {
        return approver;
    }

    public void setApprover(User approver) {
        this.approver = approver;
    }

    public List<TransferDetail> getDetails() {
        return details;
    }

    public void setDetails(List<TransferDetail> details) {
        this.details = details;
    }
}
