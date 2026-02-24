package model;

/**
 * Represents details of a procurement request.
 * Matches table 'procurement_details'.
 */
public class ProcurementDetail {
    private int detailId;
    private int procurementId;
    private int assetId;
    private int quantity;
    private String note;

    private Asset asset;

    public ProcurementDetail() {
    }

    public int getDetailId() {
        return detailId;
    }

    public void setDetailId(int detailId) {
        this.detailId = detailId;
    }

    public int getProcurementId() {
        return procurementId;
    }

    public void setProcurementId(int procurementId) {
        this.procurementId = procurementId;
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
