package model;

public class Category {
    private int id;
    private String name;
    private String description;
    private int parentId;
    private int status;

    public Category(){
    }

    public Category(int id, String name, String description, int parentId, int status) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.parentId = parentId;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }

    public int getParentId() {
        return parentId;
    }

    public void setParentId(int parentId) {
        this.parentId = parentId;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }
}
