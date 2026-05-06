package model;

import java.sql.Timestamp;

public class Notification {
    private int id;
    private String type;
    private String title;
    private String message;
    private String link;
    private int isRead;
    private Timestamp createdAt;
    public Notification(){};

    public Notification(int id, String type, String title, String message, String link, int isRead, Timestamp createdAt) {
        this.id = id;
        this.type = type;
        this.title = title;
        this.message = message;
        this.link = link;
        this.isRead = isRead;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }

    public int getIsRead() {
        return isRead;
    }

    public void setIsRead(int isRead) {
        this.isRead = isRead;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getIconClass(){
        if (type == null) return "bx-bell";
        switch (type) {
            case "order":
                return "bx-cart-add";
            case "user":
                return "bx-user-plus";
            case "stock":
                return "bxs-error-circle";
            case "review":
                return "bx-message-detail";
            default:
                return "bx-bell";
        }
    }
}
