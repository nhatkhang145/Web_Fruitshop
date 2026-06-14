document.addEventListener("DOMContentLoaded", function () {
    var approveBtn = document.getElementById("approveBtn");
    var rejectBtn = document.getElementById("rejectBtn");
    var body = document.body;
    var contextPath = body ? body.getAttribute("data-context-path") || "" : "";
    var exportId = body ? body.getAttribute("data-export-id") : "";

    function toggleButtons(hidden) {
        if (approveBtn) {
            approveBtn.style.display = hidden ? "none" : "";
        }
        if (rejectBtn) {
            rejectBtn.style.display = hidden ? "none" : "";
        }
    }

    function setButtonsDisabled(disabled) {
        if (approveBtn) {
            approveBtn.disabled = disabled;
        }
        if (rejectBtn) {
            rejectBtn.disabled = disabled;
        }
    }

    function postAction(url, successMessage) {
        if (!exportId) {
            alert("Không tìm thấy ID phiếu xuất.");
            return;
        }

        setButtonsDisabled(true);

        fetch(url, {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
            },
            body: "exportId=" + encodeURIComponent(exportId)
        })
            .then(function (response) {
                return response
                    .json()
                    .catch(function () {
                        return { success: false, message: "Phản hồi không hợp lệ." };
                    });
            })
            .then(function (data) {
                if (data && data.success) {
                    alert(successMessage);
                    toggleButtons(true);
                    window.location.reload();
                    return;
                }
                var message = data && data.message ? data.message : "Không thể xử lý phiếu.";
                alert(message);
                setButtonsDisabled(false);
            })
            .catch(function () {
                alert("Có lỗi xảy ra khi xử lý phiếu.");
                setButtonsDisabled(false);
            });
    }

    if (approveBtn) {
        approveBtn.addEventListener("click", function () {
            if (!confirm("Bạn có chắc chắn muốn xác nhận xuất kho? Hệ thống sẽ trừ tồn kho.")) {
                return;
            }
            postAction(contextPath + "/admin/inventory-export-approve", "Xác nhận xuất kho thành công.");
        });
    }

    if (rejectBtn) {
        rejectBtn.addEventListener("click", function () {
            if (!confirm("Bạn có chắc chắn muốn từ chối phiếu xuất kho?")) {
                return;
            }
            postAction(contextPath + "/admin/inventory-export-reject", "Từ chối phiếu xuất thành công.");
        });
    }
});
