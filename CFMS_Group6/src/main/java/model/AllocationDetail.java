package model;

/**
 * Represents details of an allocation request.
 * Matches table 'allocation_details'.
 */
public class AllocationDetail {
    private int detailId;
    private int requestId;
    private int categoryId;
    private int quantity;
    private String note;

    // Relationships
    private Category category;

    public AllocationDetail() {
    }

    public AllocationDetail(int detailId, int requestId, int categoryId, int quantity, String note) {
        this.detailId = detailId;
        this.requestId = requestId;
        this.categoryId = categoryId;
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

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
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

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }
}
