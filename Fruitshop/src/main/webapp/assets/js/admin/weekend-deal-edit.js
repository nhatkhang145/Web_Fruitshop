function resolveImageUrl(contextPath, imagePath) {
    if (!imagePath) {
        return '';
    }
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
        return imagePath;
    }
    return contextPath + '/' + imagePath;
}

function updatePreview(contextPath) {
    const productSelect = document.getElementById('productId');
    const selectedOption = productSelect.options[productSelect.selectedIndex];

    const previewCard = document.getElementById('previewCard');
    if (!selectedOption || !selectedOption.value) {
        previewCard.style.display = 'none';
        return;
    }

    const productName = selectedOption.dataset.name;
    const productPrice = parseFloat(selectedOption.dataset.price);
    const productImage = selectedOption.dataset.image;
    const discount = parseInt(document.getElementById('discountPercent').value, 10) || 0;
    const tag = document.getElementById('tag').value || 'Tag';
    const subtitle = document.getElementById('subtitle').value || 'Phụ đề';
    const startDate = document.getElementById('startDate').value;
    const endDate = document.getElementById('endDate').value;

    const salePrice = productPrice * (1 - discount / 100);

    previewCard.style.display = 'block';
    document.getElementById('previewImg').src = resolveImageUrl(contextPath, productImage);
    document.getElementById('previewTitle').textContent = productName;
    document.getElementById('previewSubtitle').textContent = subtitle;
    document.getElementById('previewDiscount').textContent = '-' + discount + '%';
    document.getElementById('previewTag').textContent = tag;
    document.getElementById('previewSalePrice').textContent = Math.round(salePrice).toLocaleString('vi-VN') + 'đ';
    document.getElementById('previewOriginalPrice').textContent = Math.round(productPrice).toLocaleString('vi-VN') + 'đ';

    if (startDate && endDate) {
        const start = new Date(startDate).toLocaleString('vi-VN');
        const end = new Date(endDate).toLocaleString('vi-VN');
        document.getElementById('previewTime').textContent = start + ' -> ' + end;
    }
}

document.addEventListener('DOMContentLoaded', () => {
    const contextPath = document.body.dataset.contextPath || '';
    const hasDeal = document.body.dataset.hasDeal === 'true';

    const statusInput = document.querySelector('input[name="status"]');
    const statusText = document.getElementById('statusText');
    if (statusInput && statusText) {
        statusInput.addEventListener('change', function () {
            statusText.textContent = this.checked ? 'Bật' : 'Tắt';
        });
    }

    const previewTriggers = ['productId', 'tag', 'subtitle', 'discountPercent', 'startDate', 'endDate'];
    previewTriggers.forEach((id) => {
        const el = document.getElementById(id);
        if (!el) {
            return;
        }
        const eventName = id === 'productId' ? 'change' : 'input';
        el.addEventListener(eventName, () => updatePreview(contextPath));
    });

    const dealForm = document.getElementById('dealForm');
    if (dealForm) {
        dealForm.addEventListener('submit', (e) => {
            const startDate = new Date(document.getElementById('startDate').value);
            const endDate = new Date(document.getElementById('endDate').value);

            if (endDate <= startDate) {
                e.preventDefault();
                alert('Ngày kết thúc phải sau ngày bắt đầu!');
                return;
            }

            const discount = parseInt(document.getElementById('discountPercent').value, 10);
            if (discount < 1 || discount > 99) {
                e.preventDefault();
                alert('Giảm giá phải từ 1% đến 99%!');
            }
        });
    }

    if (hasDeal) {
        updatePreview(contextPath);
    }
});
