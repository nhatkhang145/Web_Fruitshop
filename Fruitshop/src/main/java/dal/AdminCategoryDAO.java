package dal;

import model.Category;
import org.jdbi.v3.core.Handle;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class AdminCategoryDAO {
    public List<Category> getAllCategories() {
        String query = "SELECT id, name, description, parent_id AS parentId, status FROM Categories";

        return DBContext.get().withHandle(handle -> handle.createQuery(query)
                .mapToBean(Category.class)
                .list());
    }

     public Category getCategoryById(int id) {
        String sql = "SELECT id, name, description, parent_id AS parentId, status FROM Categories WHERE id = ?";
        return DBContext.get().withHandle(handle -> handle.createQuery(sql)
                .bind(0, id)
                .mapToBean(Category.class)
                .findFirst()
                .orElse(null));
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

    public void deleteCategoryAndChildren(int rootId) {
        DBContext.get().useTransaction(handle -> deleteCategoryTree(handle, rootId));
    }

    public int countProductsInCategoryTree(int rootId) {
        return DBContext.get().withHandle(handle -> countProductsInCategoryTree(handle, rootId));
    }

    public Map<Integer, Integer> getDirectProductCountByCategoryId() {
        String sql = "SELECT category_id, COUNT(*) AS total FROM products WHERE category_id IS NOT NULL GROUP BY category_id";
        return DBContext.get().withHandle(handle -> {
            Map<Integer, Integer> counts = new HashMap<>();
            handle.createQuery(sql)
                    .map((rs, ctx) -> {
                        counts.put(rs.getInt("category_id"), rs.getInt("total"));
                        return 0;
                    })
                    .list();
            return counts;
        });
    }

    private void deleteCategoryTree(Handle handle, int categoryId) {
        String childQuery = "SELECT id FROM Categories WHERE parent_id = ?";
        List<Integer> childIds = handle.createQuery(childQuery)
                .bind(0, categoryId)
                .mapTo(Integer.class)
                .list();

        for (Integer childId : childIds) {
            deleteCategoryTree(handle, childId);
        }

        String detachProductsQuery = "UPDATE products SET category_id = NULL WHERE category_id = ?";
        handle.createUpdate(detachProductsQuery)
            .bind(0, categoryId)
            .execute();

        String deleteQuery = "DELETE FROM Categories WHERE id = ?";
        handle.createUpdate(deleteQuery)
                .bind(0, categoryId)
                .execute();
    }

    private int countProductsInCategoryTree(Handle handle, int categoryId) {
        String childQuery = "SELECT id FROM Categories WHERE parent_id = ?";
        List<Integer> childIds = handle.createQuery(childQuery)
                .bind(0, categoryId)
                .mapTo(Integer.class)
                .list();

        String countQuery = "SELECT COUNT(*) FROM products WHERE category_id = ?";
        int total = handle.createQuery(countQuery)
                .bind(0, categoryId)
                .mapTo(Integer.class)
                .one();

        for (Integer childId : childIds) {
            total += countProductsInCategoryTree(handle, childId);
        }

        return total;
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

    public List<Category> getNonRootCategories() {
        String query = "SELECT id, name, description, parent_id AS parentId, status FROM Categories WHERE parent_id <> 0";
        return DBContext.get().withHandle(handle -> handle.createQuery(query)
                .mapToBean(Category.class)
                .list());
    }

    public boolean categoryExists(int id) {
        String query = "SELECT 1 FROM Categories WHERE id = ?";
        Integer result = DBContext.get().withHandle(handle -> handle.createQuery(query)
                .bind(0, id)
                .mapTo(Integer.class)
                .findFirst()
                .orElse(null));
        return result != null;
    }

    public boolean categoryNameExists(String name, Integer excludeId) {
        StringBuilder sql = new StringBuilder(
                "SELECT 1 FROM Categories WHERE LOWER(TRIM(name)) = LOWER(TRIM(:name))");

        if (excludeId != null && excludeId > 0) {
            sql.append(" AND id <> :excludeId");
        }

        return DBContext.get().withHandle(handle -> {
            var query = handle.createQuery(sql.toString())
                    .bind("name", name == null ? "" : name.trim());

            if (excludeId != null && excludeId > 0) {
                query.bind("excludeId", excludeId);
            }

            return query.mapTo(Integer.class).findFirst().isPresent();
        });
    }

    public Integer getParentIdByCategoryId(int id) {
        String query = "SELECT parent_id FROM Categories WHERE id = ?";
        return DBContext.get().withHandle(handle -> handle.createQuery(query)
                .bind(0, id)
                .mapTo(Integer.class)
                .findFirst()
                .orElse(null));
    }

    public boolean wouldCreateCycle(int categoryId, int newParentId) {
        if (newParentId == 0) {
            return false;
        }
        if (newParentId == categoryId) {
            return true;
        }

        Set<Integer> visited = new HashSet<>();
        Integer current = newParentId;
        while (current != null && current != 0) {
            if (current == categoryId) {
                return true;
            }
            if (!visited.add(current)) {
                return true;
            }
            current = getParentIdByCategoryId(current);
        }
        return false;
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

}
