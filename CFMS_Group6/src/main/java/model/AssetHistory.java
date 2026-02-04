package model;

import java.util.Date;

/**
 * Represents Asset History.
 * Matches table 'asset_history'.
 */
public class AssetHistory {
    private int historyId;
    private int assetId;
    private String action;
    private int performedBy;
    private String description;
    private Date actionDate;

    // Relationships
    private User performer;

    public AssetHistory() {
    }

    public AssetHistory(int historyId, int assetId, String action, int performedBy, String description,
            Date actionDate) {
        this.historyId = historyId;
        this.assetId = assetId;
        this.action = action;
        this.performedBy = performedBy;
        this.description = description;
        this.actionDate = actionDate;
    }

    public int getHistoryId() {
        return historyId;
    }

    public void setHistoryId(int historyId) {
        this.historyId = historyId;
    }

    public int getAssetId() {
        return assetId;
    }

    public void setAssetId(int assetId) {
        this.assetId = assetId;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public int getPerformedBy() {
        return performedBy;
    }

    public void setPerformedBy(int performedBy) {
        this.performedBy = performedBy;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getActionDate() {
        return actionDate;
    }

    public void setActionDate(Date actionDate) {
        this.actionDate = actionDate;
    }

    public User getPerformer() {
        return performer;
    }

    public void setPerformer(User performer) {
        this.performer = performer;
    }
}
