package dal;

import model.WarehouseBatchRow;

import java.time.LocalDateTime;
import java.util.List;

public class AdminWarehouseDAO {
	public List<WarehouseBatchRow> getWarehouseBatchRows() {
		String sql =
			"SELECT i.id AS item_id, COALESCE(i.available_quantity, i.quantity) AS item_quantity, i.unit_price AS unit_price, " +
						"r.id AS receipt_id, r.code AS receipt_code, r.receipt_date AS receipt_date, " +
						"p.id AS product_id, p.name AS product_name, p.product_code AS product_code, " +
						"p.price AS product_price, p.sale_price AS sale_price, p.quantity AS product_quantity, " +
						"p.image AS product_image " +
							"FROM inventory_receipt_items i " +
							"JOIN inventory_receipts r ON i.receipt_id = r.id " +
							"JOIN products p ON i.product_id = p.id " +
						"WHERE r.status = 'APPROVED' " +
						"ORDER BY r.receipt_date DESC, i.id DESC";

		return DBContext.get().withHandle(handle ->
				handle.createQuery(sql)
						.map((rs, ctx) -> new WarehouseBatchRow(
								rs.getInt("item_id"),
								rs.getInt("item_quantity"),
								rs.getDouble("unit_price"),
								rs.getInt("receipt_id"),
								rs.getString("receipt_code"),
								rs.getObject("receipt_date", LocalDateTime.class),
								rs.getInt("product_id"),
								rs.getString("product_name"),
								rs.getString("product_code"),
								rs.getDouble("product_price"),
								rs.getDouble("sale_price"),
								rs.getInt("product_quantity"),
								rs.getString("product_image")
						))
						.list()
		);
	}

	public List<WarehouseBatchRow> getBatchesOnSale() {
		String sql =
				"SELECT i.id AS item_id, COALESCE(i.available_quantity, i.quantity) AS item_quantity, i.unit_price AS unit_price, " +
						"r.id AS receipt_id, r.code AS receipt_code, r.receipt_date AS receipt_date, " +
						"p.id AS product_id, p.name AS product_name, p.product_code AS product_code, " +
						"p.price AS product_price, p.sale_price AS sale_price, p.quantity AS product_quantity, " +
						"p.image AS product_image " +
						"FROM inventory_receipt_items i " +
						"JOIN inventory_receipts r ON i.receipt_id = r.id " +
						"JOIN products p ON i.product_id = p.id " +
						"WHERE r.status = 'APPROVED' " +
						"AND p.sale_batch_item_id = i.id " +
						"AND p.sale_price_expires_at > NOW() " +
						"AND p.sale_price > 0 " +
						"ORDER BY r.receipt_date DESC, i.id DESC";

		return DBContext.get().withHandle(handle ->
				handle.createQuery(sql)
						.map((rs, ctx) -> new WarehouseBatchRow(
								rs.getInt("item_id"),
								rs.getInt("item_quantity"),
								rs.getDouble("unit_price"),
								rs.getInt("receipt_id"),
								rs.getString("receipt_code"),
								rs.getObject("receipt_date", LocalDateTime.class),
								rs.getInt("product_id"),
								rs.getString("product_name"),
								rs.getString("product_code"),
								rs.getDouble("product_price"),
								rs.getDouble("sale_price"),
								rs.getInt("product_quantity"),
								rs.getString("product_image")
						))
						.list()
		);
	}
}
