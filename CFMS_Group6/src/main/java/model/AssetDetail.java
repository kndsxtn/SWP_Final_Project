/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class AssetDetail {
    private int instanceId;
    private int assetId;
    private String instanceCode;
    private Integer roomId;
    private String status;

    // Relationship
    private Room room;
    private Asset asset;

    public AssetDetail() {
    }

    public AssetDetail(int instanceId, int assetId, String instanceCode, Integer roomId, String status, Room room,
            Asset asset) {
        this.instanceId = instanceId;
        this.assetId = assetId;
        this.instanceCode = instanceCode;
        this.roomId = roomId;
        this.status = status;
        this.room = room;
        this.asset = asset;
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

    public Integer getRoomId() {
        return roomId;
    }

    public void setRoomId(Integer roomId) {
        this.roomId = roomId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Room getRoom() {
        return room;
    }

    public void setRoom(Room room) {
        this.room = room;
    }

    public Asset getAsset() {
        return asset;
    }

    public void setAsset(Asset asset) {
        this.asset = asset;
    }

}