document.addEventListener("DOMContentLoaded", function () {
    var body = document.body;
    var contextPath = body ? body.getAttribute("data-context-path") || "" : "";

    initializeEditor(contextPath);
    initializeMainImagePicker();
    initializeSubImagePicker();
    initializeStatusText();
});

function initializeEditor(contextPath) {
    if (typeof CKEDITOR === "undefined") {
        return;
    }

    if (CKEDITOR.instances && CKEDITOR.instances.productDesc) {
        return;
    }

    var connectorUrl = contextPath + "/ckfinder/core/connector/java/connector";
    CKEDITOR.replace("productDesc", {
        filebrowserBrowseUrl: contextPath + "/assets/ckfinder/ckfinder/ckfinder.html",
        filebrowserImageBrowseUrl: contextPath + "/assets/ckfinder/ckfinder/ckfinder.html?type=Images",
        filebrowserUploadUrl: connectorUrl + "?command=QuickUpload&type=Files",
        filebrowserImageUploadUrl: connectorUrl + "?command=QuickUpload&type=Images"
    });
}

function initializeMainImagePicker() {
    var mainInput = document.getElementById("mainImageInput");
    var mainTrigger = document.getElementById("mainImageTrigger");

    if (mainTrigger && mainInput) {
        mainTrigger.addEventListener("click", function () {
            mainInput.click();
        });
    }

    if (mainInput) {
        mainInput.addEventListener("change", function () {
            previewMainImage(mainInput);
        });
    }
}

function previewMainImage(input) {
    var preview = document.getElementById("mainImagePreview");
    var placeholder = document.getElementById("placeholderIcon");

    if (!input || !input.files || !input.files[0] || !preview) {
        return;
    }

    var reader = new FileReader();
    reader.onload = function (event) {
        preview.src = event.target.result;
        preview.style.display = "block";
        if (placeholder) {
            placeholder.style.display = "none";
        }
    };
    reader.readAsDataURL(input.files[0]);
}

function initializeSubImagePicker() {
    var input = document.getElementById("subImagesInput");
    var container = document.getElementById("subImagesContainer");

    if (!input || !container) {
        return;
    }

    var initialSubImagesHTML = container.innerHTML;
    var selectedSubImages = [];

    input.addEventListener("change", function () {
        var newFiles = Array.from(input.files || []);
        if (newFiles.length === 0) {
            return;
        }

        selectedSubImages = selectedSubImages.concat(newFiles);

        var dt = new DataTransfer();
        selectedSubImages.forEach(function (file) {
            dt.items.add(file);
        });
        input.files = dt.files;

        container.innerHTML = initialSubImagesHTML;
        selectedSubImages.forEach(function (file) {
            var reader = new FileReader();
            reader.onload = function (event) {
                var wrapper = document.createElement("div");
                wrapper.className = "sub-image-item";
                wrapper.dataset.new = "true";

                var image = document.createElement("img");
                image.src = event.target.result;

                wrapper.appendChild(image);
                container.appendChild(wrapper);
            };
            reader.readAsDataURL(file);
        });
    });
}

function initializeStatusText() {
    var statusCheckbox = document.getElementById("statusCheckbox");
    var statusText = document.getElementById("statusText");

    if (!statusCheckbox || !statusText) {
        return;
    }

    function renderStatus() {
        if (statusCheckbox.checked) {
            statusText.innerText = "Đang hiển thị";
            statusText.style.color = "var(--success)";
        } else {
            statusText.innerText = "Đang ẩn";
            statusText.style.color = "var(--dark-grey)";
        }
    }

    statusCheckbox.addEventListener("change", renderStatus);
    renderStatus();
}