$(document).ready(function () {

    // ===== DataTable =====
    if ($.fn.DataTable && $('#bannerTable').length) {
        $('#bannerTable').DataTable({
            order: [[0, 'desc']],
            pageLength: 10,
            language: {
                search: 'Tìm kiếm:',
                lengthMenu: 'Hiển thị _MENU_ dòng',
                info: 'Trang _PAGE_ / _PAGES_',
                paginate: { first: '«', last: '»', next: '>', previous: '<' },
                zeroRecords: 'Không tìm thấy banner nào'
            }
        });
    }

    // ===== Mở modal Thêm banner =====
    window.openAddModal = function () {
        $('#modalTitle').text('Thêm Banner Mới');
        $('#formAction').val('add');
        $('#bannerId').val('');
        $('#oldImage').val('');
        $('#title').val('');
        $('#description').val('');
        $('#linkType').val('none');
        $('#linkTarget').val('');
        $('#link').val('');
        $('#displayOrder').val('0');
        $('#status').prop('checked', true);
        $('#imageInput').val('');
        $('#imagePreview').addClass('is-hidden');
        $('#previewImg').attr('src', '');
        handleLinkTypeChange();
        $('#bannerModal').addClass('show');
    };

    // ===== Đóng modal =====
    window.closeModal = function () {
        $('#bannerModal').removeClass('show');
    };

    // Đóng khi click ngoài modal
    $(window).on('click', function (e) {
        if ($(e.target).is('#bannerModal')) {
            window.closeModal();
        }
    });

    // ===== Edit banner — dùng event delegation để hoạt động sau DataTable phân trang =====
    $(document).on('click', '.action-btn.edit', function (e) {
        e.preventDefault();
        const btn = $(this);

        $('#modalTitle').text('Chỉnh sửa Banner');
        $('#formAction').val('update');
        $('#bannerId').val(btn.data('id'));
        $('#title').val(btn.data('title') || '');
        $('#description').val(btn.data('desc') || '');
        $('#linkType').val(btn.data('linktype') || 'none');
        $('#linkTarget').val(btn.data('linktarget') || '');
        $('#link').val(btn.data('link') || '');
        $('#displayOrder').val(btn.data('order') || '0');
        $('#status').prop('checked', btn.data('status') == 1);
        $('#oldImage').val(btn.data('imageurl') || '');
        $('#imageInput').val('');

        // Preview ảnh hiện tại
        const currentImg = btn.data('img') || '';
        if (currentImg) {
            $('#previewImg').attr('src', currentImg);
            $('#imagePreview').removeClass('is-hidden');
        } else {
            $('#imagePreview').addClass('is-hidden');
            $('#previewImg').attr('src', '');
        }

        handleLinkTypeChange();
        $('#bannerModal').addClass('show');
    });

    // ===== Xử lý loại liên kết =====
    window.handleLinkTypeChange = function () {
        const linkType = $('#linkType').val();
        const group = $('#linkTargetGroup');
        const label = $('#linkTargetLabel');
        const hint = $('#linkTargetHint');

        if (linkType === 'none') {
            group.hide();
            $('#link').val('');
        } else {
            group.show();
            if (linkType === 'internal') {
                label.text('Đường dẫn nội bộ');
                hint.text('VD: /shop, /products, /about');
            } else if (linkType === 'product') {
                label.text('ID hoặc slug sản phẩm');
                hint.text('VD: 42 hoặc tao-xanh-huu-co');
            } else if (linkType === 'category') {
                label.text('ID hoặc slug danh mục');
                hint.text('VD: 3 hoặc trai-cay-nhap-khau');
            } else if (linkType === 'external') {
                label.text('URL bên ngoài (đầy đủ)');
                hint.text('VD: https://example.com/sale');
            }
        }
    };

    // Khởi tạo trạng thái linkType ngay khi load
    handleLinkTypeChange();
    $('#linkType').on('change', handleLinkTypeChange);

    // ===== Sync trường link trước khi submit =====
    $('#bannerForm').on('submit', function () {
        const linkType = $('#linkType').val();
        const linkTarget = $('#linkTarget').val().trim();
        if (linkType === 'none') {
            $('#link').val('');
        } else if (linkType === 'internal') {
            $('#link').val(linkTarget);
        } else if (linkType === 'product') {
            $('#link').val('/product/' + linkTarget);
        } else if (linkType === 'category') {
            $('#link').val('/category/' + linkTarget);
        } else if (linkType === 'external') {
            $('#link').val(linkTarget);
        }
    });

    // ===== Preview ảnh khi chọn file mới =====
    $('#imageInput').on('change', function () {
        const file = this.files[0];
        if (!file) return;
        const reader = new FileReader();
        reader.onload = function (e) {
            $('#previewImg').attr('src', e.target.result);
            $('#imagePreview').removeClass('is-hidden');
        };
        reader.readAsDataURL(file);
    });

});
