package model;

import java.util.Date;

/**
 * Represents details of a Transfer Order.
 * Matches table 'transfer_details'.
 */
public class TransferDetail {
    private int detailId;
    private int transferId;
    private int instanceId;
    private String statusAtTransfer;
    private Date transferDate;
    private String assetName;
    
    // Relationships
    private AssetDetail assetDetail;

    public TransferDetail() {
    }

    public TransferDetail(int detailId, int transferId, int instanceId, String statusAtTransfer, Date transferDate, String assetName) {
        this.detailId = detailId;
        this.transferId = transferId;
        this.instanceId = instanceId;
        this.statusAtTransfer = statusAtTransfer;
        this.transferDate = transferDate;
        this.assetName = assetName;
    }

    public String getAssetName() {
        return assetName;
    }

    public void setAssetName(String assetName) {
        this.assetName = assetName;
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

    public int getInstanceId() {
        return instanceId;
    }

    public void setInstanceId(int instanceId) {
        this.instanceId = instanceId;
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

    public AssetDetail getAssetDetail() {
        return assetDetail;
    }

    public void setAssetDetail(AssetDetail assetDetail) {
        this.assetDetail = assetDetail;
    }
}
