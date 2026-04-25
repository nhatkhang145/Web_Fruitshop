package controller;

import dal.StockImportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.StockImport;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "AdminStockImportServlet", urlPatterns = {"/admin/stock-imports"})
public class StockImportServlet extends HttpServlet {

    private final StockImportDAO daoNhapKho = new StockImportDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String tuKhoa = catKhoangTrang(req.getParameter("keyword"));
        String nhaCungCap = catKhoangTrang(req.getParameter("supplier"));
        String sapXep = catKhoangTrang(req.getParameter("sort"));
        String tuNgayText = catKhoangTrang(req.getParameter("fromDate"));
        String denNgayText = catKhoangTrang(req.getParameter("toDate"));

        Date tuNgay = parseNgay(tuNgayText);
        Date denNgay = parseNgay(denNgayText);

        List<StockImport> imports = daoNhapKho.layDanhSachPhieuNhap(tuKhoa, nhaCungCap, sapXep, tuNgay, denNgay);
        List<String> suppliers = daoNhapKho.layDanhSachNhaCungCap();

        int tongPhieu = imports.size();
        int tongChoXacNhan = 0;
        int tongSoLuong = 0;
        double tongGiaTri = 0;

        for (StockImport item : imports) {
            tongSoLuong += item.getTotalQuantity();
            tongGiaTri += item.getTotalAmount();
            if (item.getStatus() != null) {
                String trangThai = item.getStatus().trim().toLowerCase();
                if ("draft".equals(trangThai) || "pending".equals(trangThai)) {
                    tongChoXacNhan++;
                }
            }
        }

        req.setAttribute("imports", imports);
        req.setAttribute("suppliers", suppliers);
        req.setAttribute("totalReceipts", tongPhieu);
        req.setAttribute("pendingCount", tongChoXacNhan);
        req.setAttribute("totalQuantity", tongSoLuong);
        req.setAttribute("totalAmount", tongGiaTri);

        req.setAttribute("keyword", tuKhoa == null ? "" : tuKhoa);
        req.setAttribute("supplier", nhaCungCap == null ? "" : nhaCungCap);
        req.setAttribute("sort", (sapXep == null || sapXep.isEmpty()) ? "newest" : sapXep);
        req.setAttribute("fromDate", tuNgayText == null ? "" : tuNgayText);
        req.setAttribute("toDate", denNgayText == null ? "" : denNgayText);

        req.getRequestDispatcher("/admin/stock-imports.jsp").forward(req, resp);
    }

    private String catKhoangTrang(String value) {
        return value == null ? null : value.trim();
    }

    private Date parseNgay(String value) {
        if (value == null || value.isEmpty()) {
            return null;
        }
        try {
            return Date.valueOf(value);
        } catch (Exception e) {
            return null;
        }
    }
}
