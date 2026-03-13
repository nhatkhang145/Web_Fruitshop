# Quy Trình Làm Việc Nhóm - Dự án Fruitshop

Tài liệu này là quy định chính thức về cách nhóm phối hợp phát triển dự án Fruitshop (Java Web MVC, Tomcat, SQL Server ).

## 1. Thông tin nhóm

- Phạm Nhật Khang: Leader, reviewer chính, người duyệt và merge.
- Phan Tín Thành: Developer.
- Nguyễn Trần Nhật Quân: Developer.

## 2. Chiến lược phân nhánh

### Chức năng từng nhánh

- main:
  - Chỉ chứa code release ổn định, sẵn sàng đưa lên production.
  - Tuyệt đối không phát triển tính năng mới trên main.
  
- develop:
  - Nhánh tích hợp chung của cả nhóm.
  - Nhận code từ nhánh cá nhân của 3 thành viên sau khi review.
  - Phục vụ để kiểm thử tích hợp trước khi merge lên main.
  
- dev/khang, dev/thanh, dev/quan:
  - Nhánh cá nhân của từng thành viên.
  - Nơi để phát triển và test tính năng trước khi gửi PR vào develop.
  - Có thể push code liên tục mà không cần lo xung đột với nhánh khác.

### Quy trình phân nhánh 

1. Mỗi thành viên code trên nhánh cá nhân (dev/tên).
2. Khi xong task hoặc chuẩn bị merge, tạo Pull Request từ dev/tên vào develop.
3. Leader review và merge vào develop.
4. Định kỳ (ví dụ: hàng tuần hoặc khi có milestone) merge develop lên main để release.

### Quy tắc bắt buộc

- **Tuyệt đối không push trực tiếp lên main.**
- **Tuyệt đối không push trực tiếp lên develop.**
- Mọi thay đổi từ nhánh cá nhân lên develop bắt buộc thông qua Pull Request.
- Chỉ Leader (Phạm Nhật Khang) được approve và merge vào develop.
- Chỉ Leader được merge develop lên main (để release).

## 3. Quy trình làm việc hằng ngày 

Mỗi thành viên thực hiện đúng thứ tự sau:

1. Mỗi sáng, kéo code mới nhất từ develop về máy (để cập nhật nhánh cá nhân).
2. Code trên nhánh cá nhân của mình (dev/khang, dev/thanh hoặc dev/quan).
3. Tự test trước khi commit:
   - Build thành công.
   - Chức năng liên quan hoạt động đúng.
   - Không còn debug code/log tạm.
4. Commit theo chuẩn Conventional Commits.
5. Push nhánh cá nhân lên GitHub.
6. Khi task xong, tạo Pull Request từ dev/tên vào develop.
7. Gắn Leader review.
8. Chỉnh sửa theo comment review (nếu có).
9. Leader merge vào develop khi đã reviewed và không còn conflict.
10. Định kỳ (hàng tuần hoặc khi có milestone), Leader merge develop lên main để release.

## 4. Quy ước đặt tên nhánh

### Đặt tên nhánh cá nhân

Nhánh cá nhân mỗi thành viên:

- dev/khang (Phạm Nhật Khang)
- dev/thanh (Phan Tín Thành)
- dev/quan (Nguyễn Trần Nhật Quân)

Quy tắc:

- Mỗi thành viên code trên nhánh cá nhân của mình.
- Có thể tạo nhánh nhỏ từ nhánh cá nhân nếu muốn chia tách task (tùy chọn).
  - Ví dụ: dev/khang/shopping-cart, dev/khang/payment - rồi merge vào dev/khang trước khi PR vào develop.

### Conventional Commits

Cấu trúc:

```text
<type>(scope): <short description>
```

Type sử dụng:

- add: thêm tính năng mới.
- fix: sửa lỗi.
- refactor: cải tổ code, không đổi hành vi.
- test: thêm/sửa test.
- style: format code, không đổi logic.

Ví dụ:

```text
add(auth): them chuc nang dang nhap google vào login
fix(cart): sua logic so luong san pham
```

## 5. Quy trình Pull Request, Review và Merge

### Yêu cầu khi tạo Pull Request

Mỗi PR từ dev/tên vào develop phải ghi rõ:

- Đã làm gì, tính năng/bugfix nào.
- Có thay đổi database hay không.

### Điều kiện merge vào develop

- Không còn conflict với develop.
- Đã xử lý các comment review quan trọng.
- Đã được Leader (Phạm Nhật Khang) review và chấp thuận.

### Merge vào main (release)

Leader merge develop vào main khi:

- Develop đã kiểm thử ổn định.
- Là các đợt release định kỳ hoặc cột mốc quan trọng.
- Tạo tag/release notes để ghi lại phiên bản.

## 6. Quy tắc đồng bộ database (Bắt buộc)

Nếu thay đổi bảng/cột/ràng buộc dữ liệu, người thực hiện phải:

1. Tạo hoặc cập nhật file SQL migration trong thư mục database/ của dự án.
2. Đặt tên file có thời gian rõ ràng.
   - Ví dụ: 2026-03-12-add-order-status-column.sql
3. Mô tả rõ thay đổi DB trong Pull Request:
   - Bảng nào thay đổi.
   - Cột nào thêm/sửa/xóa.
   - Ảnh hưởng dữ liệu hiện tại.
   - Cách rollback (nếu có).
4. Thông báo cho cả nhóm trên kênh chung ngay khi mở PR.
5. Không merge code liên quan DB nếu chưa có file SQL đi kèm.
6. Thành viên khác phải pull code và chạy SQL migration trước khi tiếp tục code.


## 8. Checklist trước khi tạo PR vào develop

- Đã pull develop mới nhất để cập nhật nhánh cá nhân.
- Đã push hết code lên nhánh cá nhân (dev/tên).
- Build thành công trên máy local.
- Commit đúng chuẩn Conventional Commits.
- Có file SQL nếu có thay đổi DB (trong folder database/).
- PR mô tả đầy đủ và đã gắn Leader review.
- Không còn debug code, log tạm hoặc file không liên quan.
