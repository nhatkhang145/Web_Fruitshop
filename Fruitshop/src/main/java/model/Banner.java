package model;

public class Banner {
    private int id;
    private String title;
    private String description;
    private String imageUrl;
    private String link;
    private String linkType;
    private String linkTarget;
    private int displayOrder;
    private int status;

    public Banner() {
    }

    public Banner(int id, String title, String description, String imageUrl, String link, String linkType, String linkTarget, int displayOrder, int status) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.imageUrl = imageUrl;
        this.link = link;
        this.linkType = linkType;
        this.linkTarget = linkTarget;
        this.displayOrder = displayOrder;
        this.status = status;
    }

    public String getFullUrl(String contextPath) {
        if (linkType == null || linkType.equals("none")) {
            return "#";
        }

        switch (linkType) {
            case "internal":
                return contextPath + linkTarget;
            case "external":
                return linkTarget;
            case "product":
                return contextPath + "/product-detail?pid=" + linkTarget;
            case "category":
                return contextPath + "/shop?cid=" + linkTarget;
            default:
                return link != null ? link : "#";
        }
    }

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getLink() {
        return link;
    }
    public void setLink(String link) {
        this.link = link;
    }

    public String getLinkType() {
        return linkType;
    }
    public void setLinkType(String linkType) {
        this.linkType = linkType;
    }

    public String getLinkTarget() {
        return linkTarget;
    }
    public void setLinkTarget(String linkTarget) {
        this.linkTarget = linkTarget;
    }

    public int getDisplayOrder() {
        return displayOrder;
    }
    public void setDisplayOrder(int displayOrder) {
        this.displayOrder = displayOrder;
    }

    public int getStatus() {
        return status;
    }
    public void setStatus(int status) {
        this.status = status;
    }
}