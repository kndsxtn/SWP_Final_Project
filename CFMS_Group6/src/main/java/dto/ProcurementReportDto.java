package dto;

public class ProcurementReportDto {
    private int stt;
    private String approverName;
    private String categoryName;
    private int quantity;

    public ProcurementReportDto() {
    }

    public ProcurementReportDto(int stt, String approverName, String categoryName, int quantity) {
        this.stt = stt;
        this.approverName = approverName;
        this.categoryName = categoryName;
        this.quantity = quantity;
    }

    public int getStt() {
        return stt;
    }

    public void setStt(int stt) {
        this.stt = stt;
    }

    public String getApproverName() {
        return approverName;
    }

    public void setApproverName(String approverName) {
        this.approverName = approverName;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}
