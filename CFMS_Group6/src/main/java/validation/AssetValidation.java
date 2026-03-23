package validation;

import java.math.BigDecimal;

import model.Asset;

import exception.AssetException;

public class AssetValidation {

    // validation cho asset khi create và update
    public static void validateAsset(Asset asset) throws AssetException {
        if (asset.getAssetName() == null || asset.getAssetName().trim().isEmpty()) {
            throw new AssetException("Tên tài sản không được để trống.");
        }
        if (asset.getCategoryId() <= 0) {
            throw new AssetException("Vui lòng chọn danh mục hợp lệ.");
        }
        if (asset.getPrice() == null || asset.getPrice().compareTo(BigDecimal.ZERO) <= 0) {
            throw new AssetException("Giá trị tài sản phải lớn hơn 0 VNĐ.");
        }

        // Validate ngày tháng
        if (asset.getPurchaseDate() != null) {
            java.util.Date currentDate = new java.util.Date();
            if (asset.getPurchaseDate().after(currentDate)) {
                throw new AssetException("Ngày mua không thể lớn hơn ngày hiện hành.");
            }

            if (asset.getWarrantyExpiryDate() != null) {
                if (asset.getPurchaseDate().after(asset.getWarrantyExpiryDate())) {
                    throw new AssetException("Ngày mua không thể diễn ra sau ngày hết hạn bảo hành.");
                }
            }
        }
    }

}
