package dal;

import model.Banner;
import java.util.List;

public class AdminBannerDAO {


    public List<Banner> getAllBanners() {
        String sql = "SELECT id, title, description, image_url AS imageUrl, link, link_type AS linkType, link_target AS linkTarget, display_order AS displayOrder, status FROM banners ORDER BY display_order ASC";
        return DBContext.get().withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(Banner.class)
                        .list()
        );
    }


    public Banner getBannerById(int id) {
        String sql = "SELECT id, title, description, image_url AS imageUrl, link, link_type AS linkType, link_target AS linkTarget, display_order AS displayOrder, status FROM banners WHERE id = ?";
        return DBContext.get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, id)
                        .mapToBean(Banner.class)
                        .findFirst()
                        .orElse(null)
        );
    }


    public List<Banner> getActiveBanners() {
        String sql = "SELECT id, title, description, image_url AS imageUrl, link, link_type AS linkType, link_target AS linkTarget, display_order AS displayOrder, status FROM banners WHERE status = 1 ORDER BY display_order ASC";
        return DBContext.get().withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(Banner.class)
                        .list()
        );
    }


    public int insert(Banner b) {
        String sql = "INSERT INTO banners (title, description, image_url, link, link_type, link_target, display_order, status) VALUES (:title, :description, :imageUrl, :link, :linkType, :linkTarget, :displayOrder, :status)";
        return DBContext.get().withHandle(handle ->
                handle.createUpdate(sql)
                        .bindBean(b)
                        .execute()
        );
    }


    public int update(Banner b) {
        String sql = "UPDATE banners SET title=:title, description=:description, image_url=:imageUrl, link=:link, link_type=:linkType, link_target=:linkTarget, display_order=:displayOrder, status=:status WHERE id=:id";
        return DBContext.get().withHandle(handle ->
                handle.createUpdate(sql)
                        .bindBean(b)
                        .execute()
        );
    }


    public int delete(int id) {
        String sql = "DELETE FROM banners WHERE id = ?";
        return DBContext.get().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind(0, id)
                        .execute()
        );
    }
}