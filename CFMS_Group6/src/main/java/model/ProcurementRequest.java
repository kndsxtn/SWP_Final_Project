package model;

import java.util.Date;
import java.util.List;

public class ProcurementRequest {
    private int procurementId;
    private int createdBy;
    private Date createdDate;
    private Integer approvedBy;
    private Date approvedDate;
    private Integer rejectedBy;
    private Date rejectedDate;
    private String reasonReject;
    private String status;
    private String reason;
    private Integer allocationRequestId;

    private User creator;
    private List<ProcurementDetail> details;

    public ProcurementRequest() {
    }

    public int getProcurementId() {
        return procurementId;
    }

    public void setProcurementId(int procurementId) {
        this.procurementId = procurementId;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public Integer getApprovedBy() {
        return approvedBy;
    }

    public void setApprovedBy(Integer approvedBy) {
        this.approvedBy = approvedBy;
    }

    public Date getApprovedDate() {
        return approvedDate;
    }

    public void setApprovedDate(Date approvedDate) {
        this.approvedDate = approvedDate;
    }

    public Integer getRejectedBy() {
        return rejectedBy;
    }

    public void setRejectedBy(Integer rejectedBy) {
        this.rejectedBy = rejectedBy;
    }

    public Date getRejectedDate() {
        return rejectedDate;
    }

    public void setRejectedDate(Date rejectedDate) {
        this.rejectedDate = rejectedDate;
    }

    public String getReasonReject() {
        return reasonReject;
    }

    public void setReasonReject(String reasonReject) {
        this.reasonReject = reasonReject;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public Integer getAllocationRequestId() {
        return allocationRequestId;
    }

    public void setAllocationRequestId(Integer allocationRequestId) {
        this.allocationRequestId = allocationRequestId;
    }

    public User getCreator() {
        return creator;
    }

    public void setCreator(User creator) {
        this.creator = creator;
    }

    public List<ProcurementDetail> getDetails() {
        return details;
    }

    public void setDetails(List<ProcurementDetail> details) {
        this.details = details;
    }
}
