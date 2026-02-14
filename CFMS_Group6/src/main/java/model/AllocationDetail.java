package model;

/**
 * Represents details of an allocation request.
 * Matches table 'allocation_details'.
 * Each row links one asset to a request.
 */
public class AllocationDetail {
    private int detailId;
    private int requestId;
    private int assetId;
    private int quantity;
    private String note;

    // Relationships
    private Asset asset;

    public AllocationDetail() {
    }

    public AllocationDetail(int detailId, int requestId, int assetId, int quantity, String note) {
        this.detailId = detailId;
        this.requestId = requestId;
        this.assetId = assetId;
        this.quantity = quantity;
        this.note = note;
    }

    public int getDetailId() {
        return detailId;
    }

    public void setDetailId(int detailId) {
        this.detailId = detailId;
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

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Asset getAsset() {
        return asset;
    }

    public void setAsset(Asset asset) {
        this.asset = asset;
    }
}
