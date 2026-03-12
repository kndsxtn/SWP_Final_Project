package model;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * Represents an Asset.
 * Matches table 'assets'.
 */
public class Asset {
    private int assetId;
    private String assetCode;
    private String assetName;
    private int categoryId;
    private int supplierId;
    private BigDecimal price; // Use BigDecimal for currency
    private Date purchaseDate;
    private Date warrantyExpiryDate;
    private int quantity = 1;
    private String description;
    private Date createdAt;

    // Relationships
    private Category category;
    private Supplier supplier;
    private List<AssetDetail> assetDetails;
    private List<AssetImage> images;

    // Inventory / instance aggregates (derived from asset_details)
    private int instanceTotal;
    private int countNewTotal;
    private int countAvailableInStock;
    private int countInUse;
    private int countMaintenance;
    private int countBroken;
    private int countLost;
    private int countLiquidated;

    public Asset() {
    }

    public Asset(int assetId, String assetCode, String assetName, int categoryId, int supplierId, BigDecimal price,
            Date purchaseDate, Date warrantyExpiryDate, int quantity, String description, Date createdAt,
            Category category, Supplier supplier, List<AssetDetail> assetDetails, List<AssetImage> images) {
        this.assetId = assetId;
        this.assetCode = assetCode;
        this.assetName = assetName;
        this.categoryId = categoryId;
        this.supplierId = supplierId;
        this.price = price;
        this.purchaseDate = purchaseDate;
        this.warrantyExpiryDate = warrantyExpiryDate;
        this.quantity = quantity;
        this.description = description;
        this.createdAt = createdAt;
        this.category = category;
        this.supplier = supplier;
        this.assetDetails = assetDetails;
        this.images = images;
    }

    public int getAssetId() {
        return assetId;
    }

    public void setAssetId(int assetId) {
        this.assetId = assetId;
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

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public int getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(int supplierId) {
        this.supplierId = supplierId;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public Date getPurchaseDate() {
        return purchaseDate;
    }

    public void setPurchaseDate(Date purchaseDate) {
        this.purchaseDate = purchaseDate;
    }

    public Date getWarrantyExpiryDate() {
        return warrantyExpiryDate;
    }

    public void setWarrantyExpiryDate(Date warrantyExpiryDate) {
        this.warrantyExpiryDate = warrantyExpiryDate;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public Supplier getSupplier() {
        return supplier;
    }

    public void setSupplier(Supplier supplier) {
        this.supplier = supplier;
    }

    public List<AssetDetail> getAssetDetails() {
        return assetDetails;
    }

    public void setAssetDetails(List<AssetDetail> assetDetails) {
        this.assetDetails = assetDetails;
    }

    public List<AssetImage> getImages() {
        return images;
    }

    public void setImages(List<AssetImage> images) {
        this.images = images;
    }

    public int getInstanceTotal() {
        return instanceTotal;
    }

    public void setInstanceTotal(int instanceTotal) {
        this.instanceTotal = instanceTotal;
    }

    public int getCountNewTotal() {
        return countNewTotal;
    }

    public void setCountNewTotal(int countNewTotal) {
        this.countNewTotal = countNewTotal;
    }

    public int getCountAvailableInStock() {
        return countAvailableInStock;
    }

    public void setCountAvailableInStock(int countAvailableInStock) {
        this.countAvailableInStock = countAvailableInStock;
    }

    public int getCountInUse() {
        return countInUse;
    }

    public void setCountInUse(int countInUse) {
        this.countInUse = countInUse;
    }

    public int getCountMaintenance() {
        return countMaintenance;
    }

    public void setCountMaintenance(int countMaintenance) {
        this.countMaintenance = countMaintenance;
    }

    public int getCountBroken() {
        return countBroken;
    }

    public void setCountBroken(int countBroken) {
        this.countBroken = countBroken;
    }

    public int getCountLost() {
        return countLost;
    }

    public void setCountLost(int countLost) {
        this.countLost = countLost;
    }

    public int getCountLiquidated() {
        return countLiquidated;
    }

    public void setCountLiquidated(int countLiquidated) {
        this.countLiquidated = countLiquidated;
    }
}
