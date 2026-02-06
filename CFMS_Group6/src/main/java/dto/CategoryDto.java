/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

/**
 *
 * @author quang
 */
public class CategoryDto {
    
    private int categoryId;
    private String categoryName;
    private String prefixCode;
    private String description;

    public CategoryDto() {
    }

    public CategoryDto(int categoryId, String categoryName, String prefixCode, String description) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.prefixCode = prefixCode;
        this.description = description;
    }
    

    public CategoryDto(String categoryName, String prefixCode, String description) {
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

}
