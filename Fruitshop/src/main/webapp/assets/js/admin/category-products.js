document.addEventListener("DOMContentLoaded", function () {
    const modal = document.getElementById("assignProductModal");
    const openBtn = document.getElementById("openAssignModalBtn");
    const closeBtn = document.getElementById("closeAssignModalBtn");
    const cancelBtn = document.getElementById("cancelAssignBtn");
    const cancelOnlyBtn = document.getElementById("cancelAssignOnlyBtn");

    if (!modal || !openBtn) {
        return;
    }

    const closeModal = function () {
        modal.classList.remove("show");
    };

    openBtn.addEventListener("click", function () {
        modal.classList.add("show");
    });

    if (closeBtn) {
        closeBtn.addEventListener("click", closeModal);
    }

    if (cancelBtn) {
        cancelBtn.addEventListener("click", closeModal);
    }

    if (cancelOnlyBtn) {
        cancelOnlyBtn.addEventListener("click", closeModal);
    }

    modal.addEventListener("click", function (event) {
        if (event.target === modal) {
            closeModal();
        }
    });
});
