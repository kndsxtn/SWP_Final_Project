package dto;

public class ProcurementReportDto {
    private int stt;
    private String approverName;
    private java.util.List<CategoryQuantityDto> details;

    public ProcurementReportDto() {
    }

    public ProcurementReportDto(int stt, String approverName, java.util.List<CategoryQuantityDto> details) {
        this.stt = stt;
        this.approverName = approverName;
        this.details = details;
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

    public java.util.List<CategoryQuantityDto> getDetails() {
        return details;
    }

    public void setDetails(java.util.List<CategoryQuantityDto> details) {
        this.details = details;
    }
}
