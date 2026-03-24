package dto;


public class AssetReportDto {
    private int stt;
    private String categoryName;
    private String assetName;
    private int inStockCount;
    private int inUseCount;
    private int maintenanceCount;
    private int brokenCount;
    private int liquidatedCount;
    private int lostCount;
    private int totalCount;

    public AssetReportDto() {
    }

    public int getStt() {
        return stt;
    }

    public void setStt(int stt) {
        this.stt = stt;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getAssetName() {
        return assetName;
    }

    public void setAssetName(String assetName) {
        this.assetName = assetName;
    }

    public int getInStockCount() {
        return inStockCount;
    }

    public void setInStockCount(int inStockCount) {
        this.inStockCount = inStockCount;
    }

    public int getInUseCount() {
        return inUseCount;
    }

    public void setInUseCount(int inUseCount) {
        this.inUseCount = inUseCount;
    }

    public int getMaintenanceCount() {
        return maintenanceCount;
    }

    public void setMaintenanceCount(int maintenanceCount) {
        this.maintenanceCount = maintenanceCount;
    }

    public int getBrokenCount() {
        return brokenCount;
    }

    public void setBrokenCount(int brokenCount) {
        this.brokenCount = brokenCount;
    }

    public int getLiquidatedCount() {
        return liquidatedCount;
    }

    public void setLiquidatedCount(int liquidatedCount) {
        this.liquidatedCount = liquidatedCount;
    }

    public int getLostCount() {
        return lostCount;
    }

    public void setLostCount(int lostCount) {
        this.lostCount = lostCount;
    }

    public int getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(int totalCount) {
        this.totalCount = totalCount;
    }
}
