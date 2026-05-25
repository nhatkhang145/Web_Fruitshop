package model;

public class Address {
    private int id;
    private int userId;
    private String receiverName;
    private String phoneNumber;
    private String address;
    private String city;
    private boolean isDefault;

    public Address(){

    }

    public Address(int id, int userId, String receiverName, String phoneNumber, String address, String city, boolean isDefault) {
        this.id = id;
        this.userId = userId;
        this.receiverName = receiverName;
        this.phoneNumber = phoneNumber;
        this.address = address;
        this.city = city;
        this.isDefault = isDefault;
    }

    public boolean isDefault() {
        return isDefault;
    }

    public boolean isDefaultAddress() {
        return isDefault;
    }

    public void setDefault(boolean isDefault) {
        this.isDefault = isDefault;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getReceiverName() {
        return receiverName;
    }

    public void setReceiverName(String receiverName) {
        this.receiverName = receiverName;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
}