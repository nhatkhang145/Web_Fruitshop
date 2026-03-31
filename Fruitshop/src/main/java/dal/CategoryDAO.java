package dal;

import model.Category;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {

    public List<Category> getAllCategories() {
        String query = "SELECT id, name, description, parent_id AS parentId, status FROM Categories";

        return DBContext.get().withHandle(handle -> handle.createQuery(query)
                .mapToBean(Category.class)
                .list());
    }

    private static void closeResources(Connection conn, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null)
                rs.close();
            if (ps != null)
                ps.close();
            if (conn != null)
                conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void insert(Category c) {
        String sql = "INSERT INTO Categories (name, description, parent_id, status) VALUES (?, ?, ?, ?)";
        DBContext.get().withHandle(handle -> handle.createUpdate(sql)
                .bind(0, c.getName())
                .bind(1, c.getDescription())
                .bind(2, c.getParentId())
                .bind(3, c.getStatus())
                .execute());
    }

    public void update(Category c) {
        String sql = "UPDATE Categories SET name=?, description=?, parent_id=?, status=? WHERE id=?";
        DBContext.get().withHandle(handle -> handle.createUpdate(sql)
                .bind(0, c.getName())
                .bind(1, c.getDescription())
                .bind(2, c.getParentId())
                .bind(3, c.getStatus())
                .bind(4, c.getId())
                .execute());
    }

    public void delete(int id) {
        String sql = "DELETE FROM Categories WHERE id=?";
        DBContext.get().withHandle(handle -> handle.createUpdate(sql)
                .bind(0, id)
                .execute());
    }

    public List<Category> getCategoriesByParentId(int parentId) {
        String query = "SELECT id, name, description, parent_id AS parentId, status FROM Categories WHERE parent_id = ?";

        return DBContext.get().withHandle(handle -> handle.createQuery(query)
                .bind(0, parentId)
                .mapToBean(Category.class)
                .list());
    }

    public List<Category> getParentCategories() {
        String query = "SELECT id, name, description, parent_id AS parentId, status FROM Categories WHERE parent_id = 0";

        return DBContext.get().withHandle(handle -> handle.createQuery(query)
                .mapToBean(Category.class)
                .list());
    }

    public List<Integer> getCategoryIdsIncludingChildren(int categoryId) {
        String checkQuery = "SELECT parent_id FROM Categories WHERE id = ?";
        Integer parentId = DBContext.get().withHandle(handle -> handle.createQuery(checkQuery)
                .bind(0, categoryId)
                .mapTo(Integer.class)
                .findFirst()
                .orElse(null));

        if (parentId != null && parentId == 0) {
            String sql = "SELECT id FROM Categories WHERE parent_id = ? OR id = ?";
            return DBContext.get().withHandle(handle -> handle.createQuery(sql)
                    .bind(0, categoryId)
                    .bind(1, categoryId)
                    .mapTo(Integer.class)
                    .list());
        } else {
            List<Integer> ids = new ArrayList<>();
            ids.add(categoryId);
            return ids;
        }
    }

    public static void main(String[] args) {
        CategoryDAO dao = new CategoryDAO();
        List<Category> list = dao.getAllCategories();
        System.out.println("Số lượng danh mục: " + list.size());
        for (Category c : list) {
            System.out.println(c.getName());
        }
    }
}
