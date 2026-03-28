const modal = document.getElementById("categoryModal");
const modalTitle = document.getElementById("modalTitle");
const formAction = document.getElementById("formAction");

window.openModal = function (mode) {
    if (!modal || !modalTitle || !formAction) return;

    modal.classList.add("show");
    if (mode === "add") {
        modalTitle.innerText = "Thêm Danh Mục Mới";
        formAction.value = "add";
        const form = document.getElementById("categoryForm");
        if (form) {
            form.reset();
        }
    }
};

window.editCategory = function (id, name, desc, status, parentId) {
    if (!modal || !modalTitle || !formAction) return;

    modal.classList.add("show");
    modalTitle.innerText = "Cập Nhật Danh Mục";
    formAction.value = "edit";

    const catId = document.getElementById("catId");
    const catName = document.getElementById("catName");
    const catDesc = document.getElementById("catDesc");
    const catStatus = document.getElementById("catStatus");
    const catParent = document.getElementById("catParent");

    if (catId) catId.value = id;
    if (catName) catName.value = name;
    if (catDesc) catDesc.value = desc;
    if (catStatus) catStatus.value = status;
    if (catParent) catParent.value = parentId;
};

window.closeModal = function () {
    if (modal) {
        modal.classList.remove("show");
    }
};

window.addEventListener("click", function (event) {
    if (event.target === modal) {
        window.closeModal();
    }
});

document.addEventListener("DOMContentLoaded", function () {
    const itemsPerPage = 100;
    const container = document.getElementById("categoryContainer");
    const pagination = document.getElementById("pagination");

    if (!container || !pagination) {
        return;
    }

    const editButtons = document.querySelectorAll(".js-edit-category");
    editButtons.forEach(function (button) {
        button.addEventListener("click", function () {
            const id = Number(button.dataset.id || 0);
            const name = button.dataset.name || "";
            const desc = button.dataset.desc || "";
            const status = Number(button.dataset.status || 1);
            const parentId = Number(button.dataset.parentId || 0);

            window.editCategory(id, name, desc, status, parentId);
        });
    });

    const items = container.getElementsByClassName("category-card");
    let currentPage = 1;

    function showPage(page) {
        const totalPages = Math.max(1, Math.ceil(items.length / itemsPerPage));

        if (page < 1) page = 1;
        if (page > totalPages) page = totalPages;
        currentPage = page;

        const start = (page - 1) * itemsPerPage;
        const end = start + itemsPerPage;

        for (let i = 0; i < items.length; i++) {
            items[i].style.display = i >= start && i < end ? "flex" : "none";
        }

        renderPagination(totalPages);
    }

    function renderPagination(totalPages) {
        pagination.innerHTML = "";

        const prevBtn = document.createElement("button");
        prevBtn.innerHTML = "<i class='bx bx-chevron-left'></i>";
        prevBtn.className = "page-btn " + (currentPage === 1 ? "disabled" : "");
        prevBtn.onclick = function () {
            showPage(currentPage - 1);
        };
        pagination.appendChild(prevBtn);

        for (let i = 1; i <= totalPages; i++) {
            const btn = document.createElement("button");
            btn.innerText = i;
            btn.className = "page-btn " + (i === currentPage ? "active" : "");
            btn.onclick = function () {
                showPage(i);
            };
            pagination.appendChild(btn);
        }

        const nextBtn = document.createElement("button");
        nextBtn.innerHTML = "<i class='bx bx-chevron-right'></i>";
        nextBtn.className = "page-btn " + (currentPage === totalPages ? "disabled" : "");
        nextBtn.onclick = function () {
            showPage(currentPage + 1);
        };
        pagination.appendChild(nextBtn);
    }

    window.searchCategory = function () {
        const inputElement = document.getElementById("searchInput");
        const query = inputElement ? inputElement.value.toLowerCase() : "";
        const currentItems = document.getElementsByClassName("category-card");

        if (query === "") {
            showPage(1);
            pagination.classList.remove("is-hidden");
            return;
        }

        pagination.classList.add("is-hidden");
        for (let i = 0; i < currentItems.length; i++) {
            const nameElement = currentItems[i].querySelector(".cate-name");
            const name = nameElement ? nameElement.innerText.toLowerCase() : "";
            currentItems[i].style.display = name.includes(query) ? "flex" : "none";
        }
    };

    if (items.length > 0) {
        showPage(1);
    }
});
