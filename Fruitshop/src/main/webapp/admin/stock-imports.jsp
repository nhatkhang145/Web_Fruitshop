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
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/inventory.css" />

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
                                    <h3>128</h3>
                                    <p>Tổng phiếu nhập</p>
                                </span>
                            </li>
                            <li>
                                <i class='bx bx-time-five'></i>
                                <span class="info">
                                    <h3>9</h3>
                                    <p>Phiếu chờ xác nhận</p>
                                </span>
                            </li>
                            <li>
                                <i class='bx bx-package'></i>
                                <span class="info">
                                    <h3>2,486</h3>
                                    <p>Tổng số lượng nhập</p>
                                </span>
                            </li>
                            <li>
                                <i class='bx bx-money'></i>
                                <span class="info">
                                    <h3>1.28 tỷ</h3>
                                    <p>Tổng giá trị nhập</p>
                                </span>
                            </li>
                        </ul>

                        <form class="inventory-toolbar" action="#" method="get">
                            <div class="field">
                                <input type="text" name="keyword" placeholder="Tìm theo mã phiếu nhập" />
                            </div>
                            <div class="field">
                                <select name="supplier">
                                    <option value="">Nhà cung cấp</option>
                                    <option value="NCC001">NCC001 - Green Farm</option>
                                    <option value="NCC002">NCC002 - Fresh Foods</option>
                                    <option value="NCC003">NCC003 - Organic Hub</option>
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
                                        <tr>
                                            <td>PNK-202604-001</td>
                                            <td>25-04-2026 09:15</td>
                                            <td>Green Farm</td>
                                            <td>260</td>
                                            <td>85,200,000 đ</td>
                                            <td>admin01</td>
                                            <td><span class="status confirmed">Đã xác nhận</span></td>
                                            <td><a href="#" class="action-btn view"><i class="bx bx-show"></i></a></td>
                                        </tr>
                                        <tr>
                                            <td>PNK-202604-002</td>
                                            <td>25-04-2026 10:50</td>
                                            <td>Fresh Foods</td>
                                            <td>120</td>
                                            <td>47,800,000 đ</td>
                                            <td>admin02</td>
                                            <td><span class="status draft">Nháp</span></td>
                                            <td><a href="#" class="action-btn view"><i class="bx bx-show"></i></a></td>
                                        </tr>
                                        <tr>
                                            <td>PNK-202604-003</td>
                                            <td>24-04-2026 16:30</td>
                                            <td>Organic Hub</td>
                                            <td>300</td>
                                            <td>96,400,000 đ</td>
                                            <td>admin01</td>
                                            <td><span class="status confirmed">Đã xác nhận</span></td>
                                            <td><a href="#" class="action-btn view"><i class="bx bx-show"></i></a></td>
                                        </tr>
                                        <tr>
                                            <td>PNK-202604-004</td>
                                            <td>23-04-2026 13:00</td>
                                            <td>Green Farm</td>
                                            <td>180</td>
                                            <td>56,100,000 đ</td>
                                            <td>admin03</td>
                                            <td><span class="status cancelled">Đã hủy</span></td>
                                            <td><a href="#" class="action-btn view"><i class="bx bx-show"></i></a></td>
                                        </tr>
                                    </tbody>
                                </table>
                                <p class="meta-note">UI danh sách nhập kho, chưa kết nối dữ liệu backend.</p>
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