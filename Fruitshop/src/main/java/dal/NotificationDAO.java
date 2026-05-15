package dal;

import model.Notification;

import java.util.List;

public class NotificationDAO{
    public List<Notification> getAllNotifications() {
        return DBContext.get().withHandle(handle -> {
            return handle.createQuery("SELECT * FROM notifications ORDER BY created_at DESC")
                    .map((rs, ctx) -> new Notification(
                            rs.getInt("id"),
                            rs.getString("type"),
                            rs.getString("title"),
                            rs.getString("message"),
                            rs.getString("link"),
                            rs.getInt("is_read"),
                            rs.getTimestamp("created_at")
                    ))
                    .list();
        });
    }

    public int countUnread() {
        return DBContext.get().withHandle(handle -> {
            return handle.createQuery("SELECT COUNT(*) FROM notifications WHERE is_read = 0")
                    .mapTo(Integer.class)
                    .one();
        });
    }

    public void markAllAsRead() {
        DBContext.get().useHandle(handle -> {
            handle.createUpdate("UPDATE notifications SET is_read = 1 WHERE is_read = 0")
                    .execute();
        });
    }

    public void insert(String type, String title, String message, String link) {
        String sql = "INSERT INTO notifications (type, title, message, link, is_read, created_at) VALUES (?, ?, ?, ?, 0, CURRENT_TIMESTAMP)";
        DBContext.get().useHandle(handle -> {
            handle.createUpdate(sql)
                    .bind(0, type)
                    .bind(1, title)
                    .bind(2, message)
                    .bind(3, link)
                    .execute();
        });
    }

    public List<Notification> getNotificationsWithPagination(int offset, int limit) {
        return DBContext.get().withHandle(handle -> {
            return handle.createQuery("SELECT * FROM notifications ORDER BY created_at DESC LIMIT :limit OFFSET :offset")
                    .bind("limit", limit)
                    .bind("offset", offset)
                    .map((rs, ctx) -> new Notification(
                            rs.getInt("id"),
                            rs.getString("type"),
                            rs.getString("title"),
                            rs.getString("message"),
                            rs.getString("link"),
                            rs.getInt("is_read"),
                            rs.getTimestamp("created_at")
                    ))
                    .list();
        });
    }

    public int getTotalNotifications() {
        return DBContext.get().withHandle(handle -> {
            return handle.createQuery("SELECT COUNT(*) FROM notifications")
                    .mapTo(Integer.class)
                    .one();
        });
    }

    public void delete(int id) {
        DBContext.get().useHandle(handle -> {
            handle.createUpdate("DELETE FROM notifications WHERE id = :id")
                    .bind("id", id)
                    .execute();
        });
    }


}
