<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>Quản lý Xuất kho</title>

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
                    <jsp:param name="activePage" value="stock-export" />
                </jsp:include>

                <div class="content">
                    <jsp:include page="/admin/layout/header.jsp" />

                    <main>
                        <div class="header">
                            <div class="left">
                                <h1>Quản lý xuất kho</h1>
                                <ul class="breadcrumb">
                                    <li><a href="${pageContext.request.contextPath}/admin/dashboard">Quản lý</a></li>
                                    <li>/</li>
                                    <li><a href="#" class="active">Xuất kho</a></li>
                                </ul>
                            </div>
                            <a href="#" class="report">
                                <i class="bx bx-plus"></i>
                                <span>Tạo phiếu xuất</span>
                            </a>
                        </div>

                        <ul class="insights">
                            <li>
                                <i class='bx bx-clipboard'></i>
                                <span class="info">
                                    <h3>96</h3>
                                    <p>Tổng phiếu xuất</p>
                                </span>
                            </li>
                            <li>
                                <i class='bx bx-cart'></i>
                                <span class="info">
                                    <h3>62</h3>
                                    <p>Phiếu bán hàng</p>
                                </span>
                            </li>
                            <li>
                                <i class='bx bx-package'></i>
                                <span class="info">
                                    <h3>1,732</h3>
                                    <p>Tổng số lượng xuất</p>
                                </span>
                            </li>
                            <li>
                                <i class='bx bx-error'></i>
                                <span class="info">
                                    <h3>3</h3>
                                    <p>Phiếu chờ xử lý</p>
                                </span>
                            </li>
                        </ul>

                        <form class="inventory-toolbar" action="#" method="get">
                            <div class="field">
                                <input type="text" name="keyword" placeholder="Tìm mã phiếu xuất hoặc mã sản phẩm" />
                            </div>
                            <div class="field">
                                <select name="type">
                                    <option value="">Loại xuất kho</option>
                                    <option value="sales">Xuất bán hàng</option>
                                    <option value="internal">Xuất nội bộ</option>
                                    <option value="transfer">Xuất điều chuyển</option>
                                </select>
                            </div>
                            <div class="field">
                                <select name="sort">
                                    <option value="newest">Mới nhất</option>
                                    <option value="oldest">Cũ nhất</option>
                                </select>
                            </div>
                            <div class="field">
                                <input type="date" name="fromDate" />
                            </div>
                            <div class="field">
                                <input type="date" name="toDate" />
                            </div>
                            <button type="submit" class="btn-submit">Lọc</button>
                        </form>

                        <div class="bottom-data">
                            <div class="orders">
                                <div class="header">
                                    <h3>Danh sách phiếu xuất kho</h3>
                                </div>

                                <table id="exportTable">
                                    <thead>
                                        <tr>
                                            <th>Mã phiếu</th>
                                            <th>Ngày xuất</th>
                                            <th>Loại xuất</th>
                                            <th>Tổng SL</th>
                                            <th>Tổng tiền</th>
                                            <th>Người tạo</th>
                                            <th>Trạng thái</th>
                                            <th>Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>PXK-202604-001</td>
                                            <td>25-04-2026 11:20</td>
                                            <td><span class="status sales">Bán hàng</span></td>
                                            <td>85</td>
                                            <td>41,350,000 đ</td>
                                            <td>admin01</td>
                                            <td><span class="status confirmed">Đã xác nhận</span></td>
                                            <td><a href="#" class="action-btn view"><i class="bx bx-show"></i></a></td>
                                        </tr>
                                        <tr>
                                            <td>PXK-202604-002</td>
                                            <td>25-04-2026 14:05</td>
                                            <td><span class="status internal">Nội bộ</span></td>
                                            <td>40</td>
                                            <td>18,700,000 đ</td>
                                            <td>admin02</td>
                                            <td><span class="status draft">Nháp</span></td>
                                            <td><a href="#" class="action-btn view"><i class="bx bx-show"></i></a></td>
                                        </tr>
                                        <tr>
                                            <td>PXK-202604-003</td>
                                            <td>24-04-2026 15:10</td>
                                            <td><span class="status transfer">Điều chuyển</span></td>
                                            <td>52</td>
                                            <td>22,600,000 đ</td>
                                            <td>admin03</td>
                                            <td><span class="status confirmed">Đã xác nhận</span></td>
                                            <td><a href="#" class="action-btn view"><i class="bx bx-show"></i></a></td>
                                        </tr>
                                        <tr>
                                            <td>PXK-202604-004</td>
                                            <td>23-04-2026 09:40</td>
                                            <td><span class="status sales">Bán hàng</span></td>
                                            <td>30</td>
                                            <td>15,050,000 đ</td>
                                            <td>admin01</td>
                                            <td><span class="status cancelled">Đã hủy</span></td>
                                            <td><a href="#" class="action-btn view"><i class="bx bx-show"></i></a></td>
                                        </tr>
                                    </tbody>
                                </table>
                                <p class="meta-note">UI danh sách xuất kho, chưa kết nối dữ liệu backend.</p>
                            </div>
                        </div>
                    </main>
                </div>

                <script src="${pageContext.request.contextPath}/assets/js/admin/main.js"></script>
                <script>
                    $(document).ready(function () {
                        $('#exportTable').DataTable({
                            order: [[1, 'desc']],
                            pageLength: 10,
                            language: {
                                search: 'Tìm kiếm:',
                                lengthMenu: 'Hiển thị _MENU_ dòng',
                                info: 'Trang _PAGE_ / _PAGES_',
                                paginate: { first: '«', last: '»', next: '>', previous: '<' },
                                zeroRecords: 'Không tìm thấy phiếu xuất kho'
                            }
                        });
                    });
                </script>
            </body>

            </html>