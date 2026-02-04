package model;

/**
 * Represents an Asset Category.
 * Matches table 'categories'.
 */
public class Category {
    private int categoryId;
    private String categoryName;
    private String prefixCode;
    private String description;

    public Category() {
    }

    public Category(int categoryId, String categoryName, String prefixCode, String description) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.prefixCode = prefixCode;
        this.description = description;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getPrefixCode() {
        return prefixCode;
    }

    public void setPrefixCode(String prefixCode) {
        this.prefixCode = prefixCode;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "Category{" + "categoryId=" + categoryId + ", categoryName=" + categoryName + ", prefixCode="
                + prefixCode + '}';
    }
}
