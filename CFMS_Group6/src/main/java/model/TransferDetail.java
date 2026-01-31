package model;

import java.util.Date;

/**
 * Represents details of a Transfer Order.
 * Matches table 'transfer_details'.
 */
public class TransferDetail {
    private int detailId;
    private int transferId;
    private int assetId;
    private String statusAtTransfer;
    private Date transferDate;

    // Relationships
    private Asset asset;

    public TransferDetail() {
    }

    public TransferDetail(int detailId, int transferId, int assetId, String statusAtTransfer, Date transferDate) {
        this.detailId = detailId;
        this.transferId = transferId;
        this.assetId = assetId;
        this.statusAtTransfer = statusAtTransfer;
        this.transferDate = transferDate;
    }

    public int getDetailId() {
        return detailId;
    }

    public void setDetailId(int detailId) {
        this.detailId = detailId;
    }

    public int getTransferId() {
        return transferId;
    }

    public void setTransferId(int transferId) {
        this.transferId = transferId;
    }

    public int getAssetId() {
        return assetId;
    }

    public void setAssetId(int assetId) {
        this.assetId = assetId;
    }

    public String getStatusAtTransfer() {
        return statusAtTransfer;
    }

    public void setStatusAtTransfer(String statusAtTransfer) {
        this.statusAtTransfer = statusAtTransfer;
    }

    public Date getTransferDate() {
        return transferDate;
    }

    public void setTransferDate(Date transferDate) {
        this.transferDate = transferDate;
    }

    public Asset getAsset() {
        return asset;
    }

    public void setAsset(Asset asset) {
        this.asset = asset;
    }
}
