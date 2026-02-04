package model;

import java.util.Date;

/**
 * Represents an Asset Image.
 * Matches table 'asset_images'.
 */
public class AssetImage {
    private int imageId;
    private int assetId;
    private String imageUrl;
    private Date uploadedAt;
    private String description;

    public AssetImage() {
    }

    public AssetImage(int imageId, int assetId, String imageUrl, Date uploadedAt, String description) {
        this.imageId = imageId;
        this.assetId = assetId;
        this.imageUrl = imageUrl;
        this.uploadedAt = uploadedAt;
        this.description = description;
    }

    public int getImageId() {
        return imageId;
    }

    public void setImageId(int imageId) {
        this.imageId = imageId;
    }

    public int getAssetId() {
        return assetId;
    }

    public void setAssetId(int assetId) {
        this.assetId = assetId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Date getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(Date uploadedAt) {
        this.uploadedAt = uploadedAt;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
