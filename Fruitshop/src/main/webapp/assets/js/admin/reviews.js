

const replyModal = document.getElementById("replyModal");
const replyUserSpan = document.getElementById("replyUser");
const replyProductSpan = document.getElementById("replyProduct");
const replyIdInput = document.getElementById("replyReviewId");
const replyTextarea = document.getElementById("replyText");


function openReplyModal(reviewId, userName, productName) {
    if (replyModal) {
        replyUserSpan.innerText = userName;
        replyProductSpan.innerText = productName;
        replyIdInput.value = reviewId;
        replyTextarea.value = "";
        replyModal.style.display = "block";
        replyTextarea.focus();
    }
}


function closeReplyModal() {
    if (replyModal) {
        replyModal.style.display = "none";
    }
}

document.addEventListener("DOMContentLoaded", () => {

    document.querySelectorAll(".action-btn.reply").forEach(btn => {
        btn.addEventListener("click", () => {
            const reviewId = btn.dataset.reviewId;
            const userName = btn.dataset.userName;
            const productName = btn.dataset.productName;
            openReplyModal(reviewId, userName, productName);
        });
    });


    const closeModalBtn = document.querySelector(".modal-close-btn");
    if (closeModalBtn) {
        closeModalBtn.addEventListener("click", closeReplyModal);
    }


    const cancelModalBtn = document.querySelector(".modal-cancel-btn");
    if (cancelModalBtn) {
        cancelModalBtn.addEventListener("click", closeReplyModal);
    }


    window.addEventListener("click", (e) => {
        if (e.target == replyModal) {
            closeReplyModal();
        }
    });


    document.querySelectorAll(".action-btn.hide").forEach(btn => {
        btn.addEventListener("click", (e) => {
            if (!confirm("Bạn muốn ẩn đánh giá này?")) {
                e.preventDefault();
            }
        });
    });


    document.querySelectorAll(".action-btn.delete").forEach(btn => {
        btn.addEventListener("click", (e) => {
            if (!confirm("Xóa vĩnh viễn đánh giá này?")) {
                e.preventDefault();
            }
        });
    });


    const replyForm = document.querySelector("form[action$='/admin/review-action']");
    if (replyForm) {
        replyForm.addEventListener("submit", (e) => {
            const action = replyForm.querySelector("input[name='action']").value;
            if (action === "reply") {
                const content = replyTextarea.value.trim();
                if (content === "") {
                    e.preventDefault();
                    alert("Vui lòng nhập nội dung trả lời!");
                    replyTextarea.focus();
                }
            }
        });
    }
});