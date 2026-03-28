package dal;

import model.Product;
import model.WeekendDeal;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class AdminWeekendDealDAO {
    public WeekendDeal getDealById(int id) {
        String sql = "SELECT wd.id, wd.product_id, wd.tag, wd.subtitle, wd.discount_percent, " +
                "       wd.start_date, wd.end_date, wd.status, wd.sort_order, wd.created_at, " +
                "       p.id as p_id, p.name, p.product_code, p.price, p.sale_price, " +
                "       p.quantity, p.short_description, p.image, p.category_id, p.status as p_status " +
                "FROM weekend_deals wd " +
                "JOIN products p ON wd.product_id = p.id " +
                "WHERE wd.id = ?";

        return DBContext.get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, id)
                        .map(new WeekendDealWithProductMapper())
                        .findFirst()
                        .orElse(null)
        );
    }

    public List<WeekendDeal> getAllDeals() {
        String sql = "SELECT wd.id, wd.product_id, wd.tag, wd.subtitle, wd.discount_percent, " +
                "       wd.start_date, wd.end_date, wd.status, wd.sort_order, wd.created_at, " +
                "       p.id as p_id, p.name, p.product_code, p.price, p.sale_price, " +
                "       p.quantity, p.short_description, p.image, p.category_id, p.status as p_status " +
                "FROM weekend_deals wd " +
                "LEFT JOIN products p ON wd.product_id = p.id " +
                "ORDER BY wd.created_at DESC";

        return DBContext.get().withHandle(handle ->
                handle.createQuery(sql)
                        .map(new WeekendDealWithProductMapper())
                        .list()
        );
    }

    public boolean insertDeal(WeekendDeal deal) {
        String sql = "INSERT INTO weekend_deals (product_id, tag, subtitle, discount_percent, " +
                "start_date, end_date, status, sort_order) " +
                "VALUES (:productId, :tag, :subtitle, :discountPercent, :startDate, :endDate, :status, :sortOrder)";

        try {
            int result = DBContext.get().withHandle(handle ->
                    handle.createUpdate(sql)
                            .bindBean(deal)
                            .execute()
            );
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateDeal(WeekendDeal deal) {
        String sql = "UPDATE weekend_deals SET product_id = :productId, tag = :tag, subtitle = :subtitle, " +
                "discount_percent = :discountPercent, start_date = :startDate, end_date = :endDate, " +
                "status = :status, sort_order = :sortOrder " +
                "WHERE id = :id";

        try {
            int result = DBContext.get().withHandle(handle ->
                    handle.createUpdate(sql)
                            .bindBean(deal)
                            .execute()
            );
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteDeal(int id) {
        String sql = "DELETE FROM weekend_deals WHERE id = ?";

        try {
            int result = DBContext.get().withHandle(handle ->
                    handle.createUpdate(sql)
                            .bind(0, id)
                            .execute()
            );
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private static class WeekendDealWithProductMapper implements RowMapper<WeekendDeal> {
        @Override
        public WeekendDeal map(ResultSet rs, StatementContext ctx) throws SQLException {
            WeekendDeal deal = new WeekendDeal();
            deal.setId(rs.getInt("id"));
            deal.setProductId(rs.getInt("product_id"));
            deal.setTag(rs.getString("tag"));
            deal.setSubtitle(rs.getString("subtitle"));
            deal.setDiscountPercent(rs.getInt("discount_percent"));
            deal.setStartDate(rs.getTimestamp("start_date"));
            deal.setEndDate(rs.getTimestamp("end_date"));
            deal.setStatus(rs.getInt("status"));
            deal.setSortOrder(rs.getInt("sort_order"));
            deal.setCreatedAt(rs.getTimestamp("created_at"));

            // Map Product
            Product product = new Product();
            product.setId(rs.getInt("p_id"));
            product.setName(rs.getString("name"));
            product.setProductCode(rs.getString("product_code"));
            product.setPrice(rs.getDouble("price"));
            product.setSalePrice(rs.getDouble("sale_price"));
            product.setQuantity(rs.getInt("quantity"));
            product.setDescription(rs.getString("short_description"));
            product.setImage(rs.getString("image"));
            product.setCategoryId(rs.getInt("category_id"));
            product.setStatus(rs.getInt("p_status"));

            deal.setProduct(product);
            return deal;
        }
    }
}
