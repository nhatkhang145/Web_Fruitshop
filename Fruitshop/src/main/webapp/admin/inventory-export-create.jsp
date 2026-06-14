<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Tạo phiếu xuất kho | Admin</title>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,600;700&family=Space+Grotesk:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin_style.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/inventory-receipt-create.css" />
    <meta name="contextPath" content="${pageContext.request.contextPath}" />
</head>

<body>
<jsp:include page="/admin/layout/sidebar.jsp">
    <jsp:param name="activePage" value="stock-export" />
</jsp:include>

<div class="content">
    <jsp:include page="/admin/layout/header.jsp" />

    <main class="receipt-create-page">
        <section class="receipt-hero">
            <div class="hero-copy">
                <a class="back-link" href="${pageContext.request.contextPath}/admin/stock-export">
                    <i class='bx bx-arrow-back'></i>
                    Quay lại danh sách phiếu xuất
                </a>
                <h1>Phiếu xuất kho mới</h1>
            </div>
        </section>

        <section class="receipt-shell">
            <form id="createReceiptForm" class="receipt-form">
                <div class="receipt-layout">
                    <div class="receipt-main">
                        <div class="card card-glow">
                            <div class="card-head">
                                <div>
                                    <p class="card-kicker">Thông tin phiếu</p>
                                    <h2>Thông tin chung</h2>
                                </div>
                                <span class="status-pill">Bước 1/2</span>
                            </div>

                            <div id="createReceiptMsg" class="form-msg is-hidden"></div>

                            <div class="form-grid form-grid--3">
                                <div class="form-group">
                                    <label for="inputReceiptCode">Mã phiếu xuất <span class="required">*</span></label>
                                    <input type="text" id="inputReceiptCode" name="receipt_code" placeholder="PXK-YYYYMMDD-0001" required />
                                </div>
                                <div class="form-group">
                                    <label for="inputReceiptDate">Ngày xuất <span class="required">*</span></label>
                                    <div class="input-icon">
                                        <i class='bx bx-calendar'></i>
                                        <input type="date" id="inputReceiptDate" name="receipt_date" class="input-date" required />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="inputCreator">Người lập phiếu <span class="required">*</span></label>
                                    <input type="text" id="inputCreator" name="creator_name" value="${sessionScope.account.fullName}" data-default="${sessionScope.account.fullName}" placeholder="Tên người lập" required />
                                </div>
                            </div>

                            <div class="form-grid form-grid--3">
                                <div class="form-group">
                                    <label for="inputExportType">Loại xuất <span class="required">*</span></label>
                                    <select id="inputExportType" name="export_type" required>
                                        <option value="SALES">Bán hàng</option>
                                        <option value="WASTE">Sản phẩm hỏng</option>
                                    </select>
                                </div>
                                <div id="recipientField" class="form-group">
                                    <label for="inputSupplierSelect">Chọn đơn vị nhận <span class="required">*</span></label>
                                    <select id="inputSupplierSelect" name="supplier_select">
                                        <option value="">-- Chọn đơn vị nhận --</option>
                                        <c:forEach var="s" items="${suppliers}">
                                            <option value="${s.id}">${s.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div id="recipientNameField" class="form-group">
                                    <label for="inputSupplierName">Hoặc nhập đơn vị nhận mới</label>
                                    <input type="text" id="inputSupplierName" name="supplier_name" placeholder="Nhập đơn vị nhận mới" />
                                </div>
                                <div id="wasteReasonField" class="form-group is-hidden">
                                    <label for="inputWasteReason">Lý do loại bỏ  <span class="required">*</span></label>
                                    <input type="text" id="inputWasteReason" name="waste_reason" placeholder="Mô tả lý do hỏng/không sử dụng" />
                                </div>
                            </div>
                            <input type="hidden" id="inputSupplierId" name="supplier_id" />
                            <p class="field-hint">Chọn đơn vị nhận có sẵn hoặc nhập tên mới để tạo nhanh phiếu xuất.</p>

                            <div class="form-group form-group-full">
                                <label for="inputNote">Lý do xuất / ghi chú <span class="required">*</span></label>
                                <textarea id="inputNote" name="note" rows="2" placeholder="Thông tin giao nhận, lý do xuất, ghi chú kiểm hàng..." required></textarea>
                            </div>
                        </div>

                        <div class="card card-lines">
                            <div class="card-head card-head--split">
                                <div>
                                    <p class="card-kicker">Bước 2/2</p>
                                    <h2>Danh sách hàng xuất</h2>
                                    <span class="card-subtitle">Thêm từng dòng sản phẩm, số lượng và đơn giá.</span>
                                </div>
                                <button type="button" class="btn btn-dashed" id="addLineItemBtn">
                                    <i class='bx bx-plus'></i>
                                    <span>Thêm dòng hàng</span>
                                </button>
                            </div>
                            <div class="line-grid line-grid--head">
                                <span>Mã sản phẩm</span>
                                <span>Số lượng</span>
                                <span>Đơn giá (VND)</span>
                                <span>Thành tiền</span>
                                <span></span>
                            </div>
                            <div id="lineItemsContainer" class="line-items">
                                <div class="line-item js-line-item">
                                    <select class="line-product-select" name="product_id" required>
                                        <option value="">-- Chọn mã sản phẩm --</option>
                                        <c:forEach var="p" items="${products}">
                                            <option value="${p.id}">${p.id} - ${p.name}</option>
                                        </c:forEach>
                                    </select>
                                    <input type="number" class="line-qty" name="quantity" placeholder="0" min="1" required />
                                    <input type="number" class="line-price" name="price" placeholder="0" min="1" required />
                                    <input type="text" class="line-total" placeholder="Tự tính" readonly />
                                    <button type="button" class="line-remove-btn" aria-label="Xóa dòng hàng"><i class='bx bx-trash'></i></button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <aside class="receipt-summary">
                        <div class="summary-card">
                            <div class="summary-head">
                                <h3>Tổng kết nhanh</h3>
                                <span>Kiểm tra lại trước khi lưu</span>
                            </div>
                            <div class="summary-list">
                                <div class="summary-row">
                                    <span>Mã phiếu</span>
                                    <strong id="summaryCode">---</strong>
                                </div>
                                <div class="summary-row">
                                    <span>Ngày xuất</span>
                                    <strong id="summaryDate">--/--/----</strong>
                                </div>
                                <div class="summary-row">
                                    <span>Đơn vị nhận</span>
                                    <strong id="summarySupplier">Chưa chọn</strong>
                                </div>
                                <div class="summary-row">
                                    <span>Người lập</span>
                                    <strong id="summaryCreator">---</strong>
                                </div>
                            </div>
                            <div class="summary-total">
                                <span>Tổng giá trị</span>
                                <strong id="summaryTotal">0 VND</strong>
                                <small id="summaryItems">0 mặt hàng</small>
                            </div>
                            <div class="summary-actions">
                                <button type="button" class="btn btn-ghost" id="resetFormBtn">Xóa thông tin</button>
                                <button type="button" class="btn btn-primary" id="saveReceiptBtn">
                                    <i class='bx bx-save'></i>
                                    <span>Lưu phiếu xuất</span>
                                </button>
                            </div>
                        </div>
                    </aside>
                </div>
            </form>
        </section>
    </main>
</div>

<script src="${pageContext.request.contextPath}/assets/js/admin/main.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin/inventory-export-create.js"></script>
</body>
</html>
