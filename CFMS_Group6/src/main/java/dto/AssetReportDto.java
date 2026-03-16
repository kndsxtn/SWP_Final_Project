package dto;

import java.sql.Date;

public class AssetReportDto {
    private int stt;
    private String assetCode;
    private String assetName;
    private String categoryName;
    private Date purchaseDate;
    private String status;

    public AssetReportDto() {
    }

    public AssetReportDto(int stt, String assetCode, String assetName, String categoryName, Date purchaseDate, String status) {
        this.stt = stt;
        this.assetCode = assetCode;
        this.assetName = assetName;
        this.categoryName = categoryName;
        this.purchaseDate = purchaseDate;
        this.status = status;
    }

    public int getStt() {
        return stt;
    }

    public void setStt(int stt) {
        this.stt = stt;
    }

    public String getAssetCode() {
        return assetCode;
    }

    public void setAssetCode(String assetCode) {
        this.assetCode = assetCode;
    }

    public String getAssetName() {
        return assetName;
    }

    public void setAssetName(String assetName) {
        this.assetName = assetName;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public Date getPurchaseDate() {
        return purchaseDate;
    }

    public void setPurchaseDate(Date purchaseDate) {
        this.purchaseDate = purchaseDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
