package model;

import java.math.BigDecimal;
import java.util.Date;

/**
 * Represents a Maintenance Request.
 * Matches table 'maintenance_requests'.
 */
public class MaintenanceRequest {
    private int requestId;
    private int assetId;
    private String reportedByGuest;
    private int reportedByUserId;
    private Date reportedDate;
    private String issueDescription;
    private String imageProofUrl;
    private String status;
    private BigDecimal cost;
    private String technicianNote;

    // Relationships
    private Asset asset;
    private User reporter;

    public MaintenanceRequest() {
    }

    public MaintenanceRequest(int requestId, int assetId, String reportedByGuest, int reportedByUserId,
            Date reportedDate, String issueDescription, String imageProofUrl, String status, BigDecimal cost,
            String technicianNote) {
        this.requestId = requestId;
        this.assetId = assetId;
        this.reportedByGuest = reportedByGuest;
        this.reportedByUserId = reportedByUserId;
        this.reportedDate = reportedDate;
        this.issueDescription = issueDescription;
        this.imageProofUrl = imageProofUrl;
        this.status = status;
        this.cost = cost;
        this.technicianNote = technicianNote;
    }

    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public int getAssetId() {
        return assetId;
    }

    public void setAssetId(int assetId) {
        this.assetId = assetId;
    }

    public String getReportedByGuest() {
        return reportedByGuest;
    }

    public void setReportedByGuest(String reportedByGuest) {
        this.reportedByGuest = reportedByGuest;
    }

    public int getReportedByUserId() {
        return reportedByUserId;
    }

    public void setReportedByUserId(int reportedByUserId) {
        this.reportedByUserId = reportedByUserId;
    }

    public Date getReportedDate() {
        return reportedDate;
    }

    public void setReportedDate(Date reportedDate) {
        this.reportedDate = reportedDate;
    }

    public String getIssueDescription() {
        return issueDescription;
    }

    public void setIssueDescription(String issueDescription) {
        this.issueDescription = issueDescription;
    }

    public String getImageProofUrl() {
        return imageProofUrl;
    }

    public void setImageProofUrl(String imageProofUrl) {
        this.imageProofUrl = imageProofUrl;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public BigDecimal getCost() {
        return cost;
    }

    public void setCost(BigDecimal cost) {
        this.cost = cost;
    }

    public String getTechnicianNote() {
        return technicianNote;
    }

    public void setTechnicianNote(String technicianNote) {
        this.technicianNote = technicianNote;
    }

    public Asset getAsset() {
        return asset;
    }

    public void setAsset(Asset asset) {
        this.asset = asset;
    }

    public User getReporter() {
        return reporter;
    }

    public void setReporter(User reporter) {
        this.reporter = reporter;
    }
}
