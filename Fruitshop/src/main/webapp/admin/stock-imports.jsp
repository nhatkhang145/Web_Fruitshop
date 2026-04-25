<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>Quản lý Nhập kho</title>

                <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet" />
                <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">

                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin_style.css" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/stock.css" />

                <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
                <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
            </head>

            <body>
                <jsp:include page="/admin/layout/sidebar.jsp">
                    <jsp:param name="activePage" value="stock-imports" />
                </jsp:include>

                <div class="content">
                    <jsp:include page="/admin/layout/header.jsp" />

                    <main>
                        <div class="header">
                            <div class="left">
                                <h1>Quản lý nhập kho</h1>
                                <ul class="breadcrumb">
                                    <li><a href="${pageContext.request.contextPath}/admin/dashboard">Quản lý</a></li>
                                    <li>/</li>
                                    <li><a href="#" class="active">Nhập kho</a></li>
                                </ul>
                            </div>
                            <a href="#" class="report">
                                <i class="bx bx-plus"></i>
                                <span>Tạo phiếu nhập</span>
                            </a>
                        </div>

                        <ul class="insights">
                            <li>
                                <i class='bx bx-clipboard'></i>
                                <span class="info">
                                    <h3><c:out value="${totalReceipts}" /></h3>
                                    <p>Tổng phiếu nhập</p>
                                </span>
                            </li>
                            <li>
                                <i class='bx bx-time-five'></i>
                                <span class="info">
                                    <h3><c:out value="${pendingCount}" /></h3>
                                    <p>Phiếu chờ xác nhận</p>
                                </span>
                            </li>
                            <li>
                                <i class='bx bx-package'></i>
                                <span class="info">
                                    <h3><fmt:formatNumber value="${totalQuantity}" pattern="#,###" /></h3>
                                    <p>Tổng số lượng nhập</p>
                                </span>
                            </li>
                            <li>
                                <i class='bx bx-money'></i>
                                <span class="info">
                                    <h3><fmt:formatNumber value="${totalAmount}" pattern="#,###" /> đ</h3>
                                    <p>Tổng giá trị nhập</p>
                                </span>
                            </li>
                        </ul>

                        <form class="inventory-toolbar" action="${pageContext.request.contextPath}/admin/stock-imports"
                            method="get">
                            <div class="field">
                                <input type="text" name="keyword" placeholder="Tìm theo mã phiếu nhập"
                                    value="${keyword}" />
                            </div>
                            <div class="field">
                                <select name="supplier">
                                    <option value="" ${empty supplier ? 'selected' : ''}>Nhà cung cấp</option>
                                    <c:forEach items="${suppliers}" var="sp">
                                        <option value="${sp}" ${supplier == sp ? 'selected' : ''}>${sp}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="field">
                                <select name="sort">
                                    <option value="newest" ${sort == 'newest' ? 'selected' : ''}>Mới nhất</option>
                                    <option value="oldest" ${sort == 'oldest' ? 'selected' : ''}>Cũ nhất</option>
                                </select>
                            </div>
                            <div class="field">
                                <input type="date" name="fromDate" value="${fromDate}" />
                            </div>
                            <div class="field">
                                <input type="date" name="toDate" value="${toDate}" />
                            </div>
                            <button type="submit" class="btn-submit">Lọc</button>
                        </form>

                        <div class="bottom-data">
                            <div class="orders">
                                <div class="header">
                                    <h3>Danh sách phiếu nhập kho</h3>
                                </div>

                                <table id="importTable">
                                    <thead>
                                        <tr>
                                            <th>Mã phiếu</th>
                                            <th>Ngày nhập</th>
                                            <th>Nhà cung cấp</th>
                                            <th>Tổng SL</th>
                                            <th>Tổng tiền</th>
                                            <th>Người tạo</th>
                                            <th>Trạng thái</th>
                                            <th>Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty imports}">
                                                <c:forEach items="${imports}" var="it">
                                                    <tr>
                                                        <td><c:out value="${it.importCode}" /></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${it.createdAt != null}">
                                                                    <fmt:formatDate value="${it.createdAt}"
                                                                        pattern="dd-MM-yyyy HH:mm" />
                                                                </c:when>
                                                                <c:otherwise>-</c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td><c:out value="${it.supplierName}" /></td>
                                                        <td><fmt:formatNumber value="${it.totalQuantity}" pattern="#,###" /></td>
                                                        <td><fmt:formatNumber value="${it.totalAmount}" pattern="#,###" /> đ</td>
                                                        <td><c:out value="${it.createdBy}" /></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${it.status == 'confirmed' || it.status == 'completed'}">
                                                                    <span class="status confirmed">Đã xác nhận</span>
                                                                </c:when>
                                                                <c:when test="${it.status == 'cancelled'}">
                                                                    <span class="status cancelled">Đã hủy</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="status draft">Nháp</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td><a href="#" class="action-btn view"><i class="bx bx-show"></i></a></td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="8" style="text-align:center;">Không có dữ liệu phiếu nhập kho</td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </main>
                </div>

                <script src="${pageContext.request.contextPath}/assets/js/admin/main.js"></script>
                <script>
                    $(document).ready(function () {
                        $('#importTable').DataTable({
                            order: [[1, 'desc']],
                            pageLength: 10,
                            language: {
                                search: 'Tìm kiếm:',
                                lengthMenu: 'Hiển thị _MENU_ dòng',
                                info: 'Trang _PAGE_ / _PAGES_',
                                paginate: { first: '«', last: '»', next: '>', previous: '<' },
                                zeroRecords: 'Không tìm thấy phiếu nhập kho'
                            }
                        });
                    });
                </script>
            </body>

            </html>