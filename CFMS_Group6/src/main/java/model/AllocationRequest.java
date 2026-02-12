package model;

import java.util.Date;
import java.util.List;

/**
 * Represents an Allocation Request.
 * Matches table 'allocation_requests'.
 */
public class AllocationRequest {
    private int requestId;
    private int createdBy;
    private Date createdDate;
    private String status;
    private String reasonReject;

    
    private int totalRequestedAssets;   // how many assets are requested in this allocation
    private int totalAvailableInStock;  // how many assets can be served from current stock
    /**
     * Stock status level for this request.
     * Possible values:
     *  - "FULL"    : stock can fully satisfy the request
     *  - "PARTIAL" : stock can only partially satisfy the request
     *  - "NONE"    : stock cannot satisfy any part of the request
     */
    private String stockStatus;

    // Relationships
    private User creator;
    private List<AllocationDetail> details;

    public AllocationRequest() {
    }

    public AllocationRequest(int requestId, int createdBy, Date createdDate, String status, String reasonReject) {
        this.requestId = requestId;
        this.createdBy = createdBy;
        this.createdDate = createdDate;
        this.status = status;
        this.reasonReject = reasonReject;
    }

    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getReasonReject() {
        return reasonReject;
    }

    public void setReasonReject(String reasonReject) {
        this.reasonReject = reasonReject;
    }

    public int getTotalRequestedAssets() {
        return totalRequestedAssets;
    }

    public void setTotalRequestedAssets(int totalRequestedAssets) {
        this.totalRequestedAssets = totalRequestedAssets;
    }

    public int getTotalAvailableInStock() {
        return totalAvailableInStock;
    }

    public void setTotalAvailableInStock(int totalAvailableInStock) {
        this.totalAvailableInStock = totalAvailableInStock;
    }

    public String getStockStatus() {
        return stockStatus;
    }

    public void setStockStatus(String stockStatus) {
        this.stockStatus = stockStatus;
    }

    public User getCreator() {
        return creator;
    }

    public void setCreator(User creator) {
        this.creator = creator;
    }

    public List<AllocationDetail> getDetails() {
        return details;
    }

    public void setDetails(List<AllocationDetail> details) {
        this.details = details;
    }
}
