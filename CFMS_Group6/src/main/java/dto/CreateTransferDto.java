/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

/**
 *
 * @author Admin
 */
public class CreateTransferDto {
    private int instanceId;
    private int assetId;
    private String instanceCode;
    private int roomId;
    private String status;
    private String assetName;

    public CreateTransferDto() {
    }

    public CreateTransferDto(int instanceId, int assetId, String instanceCode, int roomId, String status, String assetName) {
        this.instanceId = instanceId;
        this.assetId = assetId;
        this.instanceCode = instanceCode;
        this.roomId = roomId;
        this.status = status;
        this.assetName = assetName;
    }

    public int getInstanceId() {
        return instanceId;
    }

    public void setInstanceId(int instanceId) {
        this.instanceId = instanceId;
    }

    public int getAssetId() {
        return assetId;
    }

    public void setAssetId(int assetId) {
        this.assetId = assetId;
    }

    public String getInstanceCode() {
        return instanceCode;
    }

    public void setInstanceCode(String instanceCode) {
        this.instanceCode = instanceCode;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getAssetName() {
        return assetName;
    }

    public void setAssetName(String assetName) {
        this.assetName = assetName;
    }
    
    
}
