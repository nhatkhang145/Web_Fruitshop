// slider chính
document.addEventListener('DOMContentLoaded', function() {
    let currentSlide = 0;
    const slideWrapper = document.querySelector(".slide-wrapper");
    const slides = document.querySelectorAll(".slide-item");
    const totalSlides = slides.length;
    const dots = document.querySelectorAll(".indicator-dot");
    const prevButton = document.querySelector(".prev-button");
    const nextButton = document.querySelector(".next-button");
    const slideContainer = document.querySelector(".slide-container");
    const slideIndicators = document.querySelector('.slide-indicators');

    // Kiểm tra xem có slideWrapper không
    if (!slideWrapper || !slideContainer) {
        console.log('Slider elements not found');
        return;
    }

    console.log('Total slides:', totalSlides);

    // Ẩn controls nếu chỉ có 1 slide
    if (totalSlides <= 1) {
        if (prevButton) prevButton.style.display = 'none';
        if (nextButton) nextButton.style.display = 'none';
        if (slideIndicators) slideIndicators.style.display = 'none';
        console.log('Only 1 slide, controls hidden');
        return; // Không cần chạy code slider nếu chỉ có 1 slide
    }

    // Hàm cập nhật vị trí slide
    function updateSlide() {
        slideWrapper.style.transform = `translateX(-${currentSlide * 100}%)`;

        // Cập nhật dots
        dots.forEach((dot, index) => {
            dot.classList.toggle("active", index === currentSlide);
        });
    }

    // Chuyển sang slide tiếp theo
    function nextSlide() {
        currentSlide = (currentSlide + 1) % totalSlides;
        updateSlide();
    }

    // Chuyển về slide trước
    function prevSlide() {
        currentSlide = (currentSlide - 1 + totalSlides) % totalSlides;
        updateSlide();
    }

    // Đi đến slide cụ thể
    window.goToSlide = function(index) {
        currentSlide = index;
        updateSlide();
    }

    // Tự động chuyển slide sau 5 giây
    let autoSlide = setInterval(nextSlide, 5000);
    console.log('Auto-slide started');

    // Dừng auto-slide khi hover vào slider
    slideContainer.addEventListener("mouseenter", () => {
        clearInterval(autoSlide);
        console.log('Auto-slide paused');
    });

    // Tiếp tục auto-slide khi rời khỏi slider
    slideContainer.addEventListener("mouseleave", () => {
        autoSlide = setInterval(nextSlide, 5000);
        console.log('Auto-slide resumed');
    });

    // Hỗ trợ phím mũi tên
    document.addEventListener("keydown", (e) => {
        if (e.key === "ArrowLeft") {
            prevSlide();
        } else if (e.key === "ArrowRight") {
            nextSlide();
        }
    });

    // Hỗ trợ touch swipe trên mobile
    let touchStartX = 0;
    let touchEndX = 0;

    slideContainer.addEventListener("touchstart", (e) => {
        touchStartX = e.changedTouches[0].screenX;
    });

    slideContainer.addEventListener("touchend", (e) => {
        touchEndX = e.changedTouches[0].screenX;
        handleSwipe();
    });

    function handleSwipe() {
        if (touchStartX - touchEndX > 50) {
            nextSlide();
        }
        if (touchEndX - touchStartX > 50) {
            prevSlide();
        }
    }

    // Xử lý click nút prev/next
    if (prevButton) {
        prevButton.addEventListener('click', prevSlide);
    }
    if (nextButton) {
        nextButton.addEventListener('click', nextSlide);
    }
});



// -----------------------------------
// js cho offers carousel
document.addEventListener('DOMContentLoaded', function() {
    const container = document.querySelector('.carousel-container');
    const prevBtn = document.querySelector('.arrow.prev');
    const nextBtn = document.querySelector('.arrow.next');

    // Kiểm tra xem các element có tồn tại không
    if (!container || !prevBtn || !nextBtn) {
        return; // Thoát nếu không tìm thấy carousel
    }

    let currentPosition = 0;
    let products = [];

    // Khởi tạo carousel
    function initCarousel() {
        // Lấy tất cả product cards
        products = Array.from(container.querySelectorAll('.product-card'));

        // Ẩn các sản phẩm ngoài viewport ban đầu (từ index 4 trở đi)
        products.forEach((product, index) => {
            if (index >= 4) {
                product.style.display = 'none';
            }
        });

        // Disable nút prev ban đầu
        updateNavigationButtons();
    }

    // Cập nhật trạng thái các nút điều hướng
    function updateNavigationButtons() {
        prevBtn.disabled = currentPosition === 0;
        nextBtn.disabled = currentPosition >= products.length - 4;
    }

    // Xử lý khi click nút next
    function handleNext() {
        if (currentPosition < products.length - 4) {
            // Ẩn sản phẩm đầu tiên của view hiện tại
            products[currentPosition].style.display = 'none';

            // Hiện sản phẩm tiếp theo
            products[currentPosition + 4].style.display = '';

            currentPosition++;
            updateNavigationButtons();
        }
    }

    // Xử lý khi click nút previous
    function handlePrev() {
        if (currentPosition > 0) {
            // Hiện lại sản phẩm trước đó
            products[currentPosition - 1].style.display = '';

            // Ẩn sản phẩm cuối của view hiện tại
            products[currentPosition + 3].style.display = 'none';

            currentPosition--;
            updateNavigationButtons();
        }
    }

    // Thêm event listeners
    nextBtn.addEventListener('click', handleNext);
    prevBtn.addEventListener('click', handlePrev);

    // Khởi tạo carousel khi trang load xong
    initCarousel();
});

// ----------------------------------------------
// Xử lý button "Yêu thích"
document.addEventListener('DOMContentLoaded', function() {
    // Lấy tất cả button/link yêu thích
    const wishlistButtons = document.querySelectorAll('.action-btn[href*="wishlist"]');

    wishlistButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();

            const url = new URL(this.href);
            const action = url.searchParams.get('action');
            const productId = url.searchParams.get('pid');

            if (!productId) {
                alert('Không tìm thấy ID sản phẩm');
                return;
            }

            const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));
            const requestUrl = `${contextPath}/wishlist?action=${action}&pid=${productId}`;

            fetch(requestUrl, {
                method: 'GET',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Cập nhật icon trái tim
                        const icon = this.querySelector('i');
                        if (data.action === 'added') {
                            icon.className = 'fas fa-heart';
                            icon.style.color = 'red';
                            this.title = 'Bỏ yêu thích';
                            // Cập nhật href để lần click sau sẽ remove
                            url.searchParams.set('action', 'remove');
                            this.href = url.toString();
                            showNotification('Đã thêm vào danh sách yêu thích!', 'success');
                        } else {
                            icon.className = 'far fa-heart';
                            icon.style.color = '';
                            this.title = 'Thêm vào yêu thích';
                            // Cập nhật href để lần click sau sẽ add
                            url.searchParams.set('action', 'add');
                            this.href = url.toString();
                            showNotification('Đã bỏ khỏi danh sách yêu thích!', 'success');
                        }

                        // Cập nhật badge wishlist
                        const wishlistBadge = document.querySelector('.wishlist-btn .badge');
                        if (wishlistBadge) {
                            wishlistBadge.textContent = data.count;
                            wishlistBadge.style.animation = 'pulse 0.5s ease-in-out';
                            setTimeout(() => {
                                wishlistBadge.style.animation = '';
                            }, 500);
                        }
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showNotification('Vui lòng đăng nhập để sử dụng chức năng này!', 'error');
                });
        });
    });
});

// ----------------------------------------------
// Xử lý button "Thêm vào giỏ hàng"
document.addEventListener('DOMContentLoaded', function() {
    // Lấy tất cả button "Thêm vào giỏ hàng"
    const addToCartButtons = document.querySelectorAll('.add-to-cart-btn');

    addToCartButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();

            const productId = this.getAttribute('data-id');

            if (!productId) {
                alert('Không tìm thấy ID sản phẩm');
                return;
            }

            // Gửi request AJAX để thêm vào giỏ hàng
            const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));
            const url = `${contextPath}/add-to-cart?pid=${productId}&quantity=1`;

            fetch(url, {
                method: 'GET',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // ✅ Cập nhật badge từ giá trị size trả về từ server
                        const cartBadge = document.querySelector('.cart-btn .badge');
                        if (cartBadge && data.size !== undefined) {
                            cartBadge.textContent = data.size;

                            // Hiệu ứng animation
                            cartBadge.style.animation = 'pulse 0.5s ease-in-out';
                            setTimeout(() => {
                                cartBadge.style.animation = '';
                            }, 500);
                        }

                        // Hiển thị thông báo thành công
                        showNotification('Đã thêm sản phẩm vào giỏ hàng!', 'success');
                    } else {
                        showNotification('Có lỗi xảy ra, vui lòng thử lại!', 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showNotification('Có lỗi xảy ra, vui lòng thử lại!', 'error');
                });
        });
    });
});

// Hàm hiển thị thông báo
function showNotification(message, type) {
    // Tạo element thông báo
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    notification.textContent = message;
    notification.style.cssText = `
        position: fixed;
        top: 80px;
        right: 20px;
        background: ${type === 'success' ? '#4CAF50' : '#f44336'};
        color: white;
        padding: 15px 25px;
        border-radius: 5px;
        box-shadow: 0 4px 6px rgba(0,0,0,0.2);
        z-index: 9999;
        animation: slideIn 0.3s ease-out;
    `;

    document.body.appendChild(notification);

    // Tự động xóa sau 3 giây
    setTimeout(() => {
        notification.style.animation = 'slideOut 0.3s ease-out';
        setTimeout(() => {
            document.body.removeChild(notification);
        }, 300);
    }, 3000);
}

// Thêm CSS animation cho notification
const style = document.createElement('style');
style.textContent = `
    @keyframes slideIn {
        from {
            transform: translateX(400px);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
    
    @keyframes slideOut {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(400px);
            opacity: 0;
        }
    }
    
    @keyframes pulse {
        0%, 100% {
            transform: scale(1);
        }
        50% {
            transform: scale(1.2);
        }
    }
`;
document.head.appendChild(style);

// ==================== WEEKEND DEALS CAROUSEL ====================
let currentDealIndex = 0;
const dealCards = document.querySelectorAll('.deal-card');
const dealIndicators = document.querySelectorAll('.deal-indicators .indicator');

function showDeal(index) {
    if (dealCards.length === 0) return;

    currentDealIndex = index;

    // Update cards
    dealCards.forEach((card, i) => {
        card.classList.toggle('active', i === index);
    });

    // Update indicators
    dealIndicators.forEach((indicator, i) => {
        indicator.classList.toggle('active', i === index);
    });
}

function nextDeal() {
    if (dealCards.length === 0) return;
    const nextIndex = (currentDealIndex + 1) % dealCards.length;
    showDeal(nextIndex);
}

function prevDeal() {
    if (dealCards.length === 0) return;
    const prevIndex = (currentDealIndex - 1 + dealCards.length) % dealCards.length;
    showDeal(prevIndex);
}

function goToDeal(index) {
    showDeal(index);
}

// Auto slide every 6 seconds
if (dealCards.length > 1) {
    setInterval(nextDeal, 6000);
}

// ==================== COUNTDOWN TIMER ====================
function updateDealTimers() {
    document.querySelectorAll('.deal-card.active .deal-timer').forEach(timer => {
        const endTime = parseInt(timer.dataset.endTime);
        if (!endTime) return;

        const now = new Date().getTime();
        const timeRemaining = endTime - now;

        if (timeRemaining > 0) {
            const days = Math.floor(timeRemaining / (1000 * 60 * 60 * 24));
            const hours = Math.floor((timeRemaining % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            const minutes = Math.floor((timeRemaining % (1000 * 60 * 60)) / (1000 * 60));
            const seconds = Math.floor((timeRemaining % (1000 * 60)) / 1000);

            const daysEl = timer.querySelector('.days');
            const hoursEl = timer.querySelector('.hours');
            const minutesEl = timer.querySelector('.minutes');
            const secondsEl = timer.querySelector('.seconds');

            if (daysEl) daysEl.textContent = String(days).padStart(2, '0');
            if (hoursEl) hoursEl.textContent = String(hours).padStart(2, '0');
            if (minutesEl) minutesEl.textContent = String(minutes).padStart(2, '0');
            if (secondsEl) secondsEl.textContent = String(seconds).padStart(2, '0');
        } else {
            const daysEl = timer.querySelector('.days');
            const hoursEl = timer.querySelector('.hours');
            const minutesEl = timer.querySelector('.minutes');
            const secondsEl = timer.querySelector('.seconds');

            if (daysEl) daysEl.textContent = '00';
            if (hoursEl) hoursEl.textContent = '00';
            if (minutesEl) minutesEl.textContent = '00';
            if (secondsEl) secondsEl.textContent = '00';
        }
    });
}

// Update timers every second
setInterval(updateDealTimers, 1000);
updateDealTimers(); // Initial call
